const { onRequest } = require("firebase-functions/v2/https");
const functionsV1 = require("firebase-functions/v1");
const admin = require("firebase-admin");
const { defineSecret } = require("firebase-functions/params");
const cors = require("cors")({ origin: true });
const {
    DENSITY_RADIUS_KM, MAX_SHADOW_RETENTION_MS, shadowRetentionFor, classifyPresence,
} = require("./presence");

if (!admin.apps.length) admin.initializeApp();

// 🔐 金鑰改由 Firebase Secret Manager 提供，設定方式：
//    firebase functions:secrets:set UPSTASH_REDIS_REST_URL
//    firebase functions:secrets:set UPSTASH_REDIS_REST_TOKEN
const UPSTASH_URL = defineSecret("UPSTASH_REDIS_REST_URL");
const UPSTASH_TOKEN = defineSecret("UPSTASH_REDIS_REST_TOKEN");
const UPSTASH_SECRETS = [UPSTASH_URL, UPSTASH_TOKEN];

const MAX_RADIUS_KM = 5;
const MAX_MOOD_LENGTH = 20;
const MAX_NICKNAME_LENGTH = 10;
const MAX_NEARBY_RESULTS = 300;

// 去除貼上 Secret 時誤帶的空白、換行與引號
function cleanSecret(secret) {
    return secret.value().trim().replace(/^["']|["']$/g, '').trim();
}

async function upstashFetch(path, body) {
    const response = await fetch(cleanSecret(UPSTASH_URL).replace(/\/+$/, '') + path, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${cleanSecret(UPSTASH_TOKEN)}`, 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
    });
    if (!response.ok) throw new Error(`Upstash API Error: ${response.status}`);
    return response.json();
}

async function sendUpstashCommand(commandArray) {
    const data = await upstashFetch('', commandArray);
    if (data.error) throw new Error(`Redis Error: ${data.error}`);
    return data.result;
}

// 🚀 Pipeline：多個指令合併成一次 HTTP 請求，回傳每個指令的 result
async function sendUpstashPipeline(commands) {
    if (commands.length === 0) return [];
    const data = await upstashFetch('/pipeline', commands);
    return data.map((item) => {
        if (item.error) throw new Error(`Redis Error: ${item.error}`);
        return item.result;
    });
}

// 備用金庫：向 Redis 查詢最新暱稱
async function getNicknameFromRedis(uid) {
    try {
        return await sendUpstashCommand(["HGET", `user_data:${uid}`, "nickname"]);
    } catch (e) { console.error('Redis lookup failed:', e); }
    return null;
}

// 驗證 Firebase ID Token，回傳真實的 uid；失敗則回傳 null
async function verifyCaller(req) {
    const match = (req.headers.authorization || '').match(/^Bearer (.+)$/);
    if (!match) return null;
    try {
        const decoded = await admin.auth().verifyIdToken(match[1]);
        return decoded.uid;
    } catch (e) { return null; }
}

// 以「肉眼看到的字數」截斷（emoji 如 😵‍💫 算 1 個字），與 App 輸入框的 maxLength 一致
const graphemeSegmenter = new Intl.Segmenter('zh', { granularity: 'grapheme' });
function truncateVisible(value, maxChars) {
    const chars = Array.from(graphemeSegmenter.segment(String(value || '')), (seg) => seg.segment);
    return chars.slice(0, maxChars).join('');
}

function isValidCoordinate(lat, lng) {
    return typeof lat === 'number' && typeof lng === 'number' &&
        Number.isFinite(lat) && Number.isFinite(lng) &&
        lat >= -85 && lat <= 85 && lng >= -180 && lng <= 180;
}

// ============================================================================
// API 1 & 2: 地理雷達運算 (維持在亞洲區，加速你的地圖讀取)
// ============================================================================
exports.updateLocation = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    // 🔐 uid 只信任 ID Token，不再接受 body 傳入，防止冒用他人身分
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: "未授權" });

    const { lat, lng } = req.body;
    if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: "座標格式錯誤" });
    const mood = truncateVisible(req.body.mood, MAX_MOOD_LENGTH);
    const nickname = truncateVisible(req.body.nickname, MAX_NICKNAME_LENGTH);
    const timestamp = Date.now();
    try {
      await sendUpstashPipeline([
          ["GEOADD", "city_users", lng.toString(), lat.toString(), uid],
          // 只有前景的 App 會呼叫，因此同時視為「活躍」心跳
          ["HSET", `user_data:${uid}`, "mood", mood, "nickname", nickname, "timestamp", timestamp.toString(),
              "state", "active", "stateAt", timestamp.toString()],
      ]);
      res.status(200).json({ success: true, message: "更新成功" });
    } catch (error) {
      console.error('updateLocation failed:', error);
      res.status(500).json({ success: false, error: "更新失敗" });
    }
  });
});

exports.getNearby = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: "未授權" });

    const { lat, lng } = req.body;
    if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: "座標格式錯誤" });
    const radiusKM = Math.min(Math.max(Number(req.body.radiusKM) || MAX_RADIUS_KM, 0.1), MAX_RADIUS_KM);
    try {
      // 1 次請求：由近到遠取出半徑內的人，座標與距離直接由地理索引帶回
      const nearby = await sendUpstashCommand([
          "GEOSEARCH", "city_users", "FROMLONLAT", lng.toString(), lat.toString(),
          "BYRADIUS", radiusKM.toString(), "km", "ASC", "COUNT", MAX_NEARBY_RESULTS.toString(), "WITHDIST", "WITHCOORD"
      ]);
      // 每筆格式：[uid, 距離(km), [lng, lat]]
      const members = (Array.isArray(nearby) ? nearby : []).filter((m) => Array.isArray(m) && m[0] && m[0] !== uid);

      // 1 次請求：以 pipeline 一口氣取回所有人的資料
      const profiles = await sendUpstashPipeline(
          members.map(([memberUid]) => ["HMGET", `user_data:${memberUid}`, "mood", "nickname", "timestamp", "state", "stateAt"])
      );

      const now = Date.now();
      const staleUids = [];
      const candidates = [];
      members.forEach(([memberUid, dist, coord], i) => {
          const [mood, nickname, timestamp, state, stateAt] = profiles[i] || [];
          const lastSeen = parseInt(timestamp || "0", 10);
          if (!lastSeen) { staleUids.push(memberUid); return; }
          const presence = classifyPresence(state || null, parseInt(stateAt || "0", 10), lastSeen, now);
          // 超過最長留存（10 天）的殘影，任何密度下都不會再顯示，直接清除
          if (presence.status === 'shadow' && now - presence.shadowSince > MAX_SHADOW_RETENTION_MS) { staleUids.push(memberUid); return; }
          candidates.push({ memberUid, dist: parseFloat(dist), coord, mood, nickname, lastSeen, presence });
      });

      // 密度：觀看者周圍 1 公里內的人數，決定殘影能留存多久
      const peopleNearby = candidates.filter((c) => c.dist <= DENSITY_RADIUS_KM).length;
      const retentionMs = shadowRetentionFor(peopleNearby);

      const results = [];
      for (const c of candidates) {
          const { status, shadowSince } = c.presence;
          let shadowAge = 0;
          if (status === 'shadow') {
              shadowAge = (now - shadowSince) / retentionMs;
              if (shadowAge > 1) continue; // 超過此密度允許的留存時間
          }
          results.push({
              uid: c.memberUid, lng: parseFloat(c.coord[0]), lat: parseFloat(c.coord[1]),
              mood: c.mood || "",
              nickname: status === 'shadow' ? "" : (c.nickname || ""), // 殘影不公開暱稱
              status,
              shadowAge, // 0 = 剛成為殘影，1 = 即將消失；供 App 計算淡出程度
              timestamp: c.lastSeen,
          });
      }

      // 🧹 順手清掉過期的殘影，避免地理索引無限膨脹
      if (staleUids.length > 0) {
          try {
              await sendUpstashPipeline([["ZREM", "city_users", ...staleUids], ...staleUids.map((u) => ["DEL", `user_data:${u}`])]);
          } catch (e) { console.error('stale cleanup failed:', e); }
      }

      res.status(200).json({ success: true, data: results, density: { peopleNearby, shadowRetentionHours: retentionMs / 3600000 } });
    } catch (error) {
      console.error('getNearby failed:', error);
      res.status(500).json({ success: false, error: "掃描失敗" });
    }
  });
});

// ============================================================================
// 推播：全專案唯一的推播出口（其他 codebase 的重複推播已移除）
// ============================================================================
async function sendPush(targetUid, title, body, data) {
    const tokenSnap = await admin.database().ref(`/tokens/${targetUid}`).once('value');
    const token = tokenSnap.val();
    if (!token) return;
    try {
        await admin.messaging().send({
            token,
            notification: { title, body },
            data,
            android: { priority: 'high', notification: { sound: 'default' } },
            apns: { headers: { 'apns-priority': '10' }, payload: { aps: { sound: 'default', badge: 1 } } },
        });
    } catch (error) {
        console.error(`推播失敗 (${data.type} → ${targetUid}):`, error);
    }
}

// ============================================================================
// API 3: 敲門推播通知
// ============================================================================
exports.notifyOnKnock = functionsV1.runWith({ secrets: UPSTASH_SECRETS }).database.ref('/requests/{targetUid}/{senderUid}')
  .onWrite(async (change, context) => {
    const data = change.after.val(); const beforeData = change.before.val();
    if (!data || data.status !== 'pending') return null;
    if (beforeData && beforeData.status === 'pending') return null;

    const targetUid = context.params.targetUid; const senderUid = context.params.senderUid;
    
    let senderName = data.nickname;
    if (!senderName || senderName.trim() === '' || senderName.startsWith('#')) {
        const redisName = await getNicknameFromRedis(senderUid);
        if (redisName && redisName.trim() !== '') senderName = redisName;
    }
    if (!senderName || senderName.trim() === '') senderName = `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;

    await sendPush(targetUid, '片刻交集', `${senderName} 正在敲門，想與你產生交集...`, { type: 'knock_request', senderUid });
    return null;
  });

// ============================================================================
// API 4: 聊天推播通知
// ============================================================================
exports.notifyOnChat = functionsV1.runWith({ secrets: UPSTASH_SECRETS }).database.ref('/chats/{roomId}/messages/{msgId}')
  .onCreate(async (snapshot, context) => {
    const msg = snapshot.val(); if (!msg) return null;
    const senderUid = msg.sender;
    const targetUid = context.params.roomId.split('_').find(id => id !== senderUid);
    if (!targetUid) return null;

    // 第一防線：抓取訊息夾帶的名字
    let senderName = msg.senderName;
    
    // 第二防線：若無名字，強制去 Redis 找
    if (!senderName || senderName.trim() === '' || senderName.startsWith('#')) {
        const redisName = await getNicknameFromRedis(senderUid);
        if (redisName && redisName.trim() !== '') senderName = redisName;
    }
    
    // 第三防線：真的沒有才給代號
    if (!senderName || senderName.trim() === '' || senderName.startsWith('#')) {
        senderName = `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;
    }

    await sendPush(targetUid, `來自 ${senderName} 的低語`, String(msg.text || ''), { type: 'chat_message', roomId: context.params.roomId, senderUid });
    return null;
  });

// ============================================================================
// API 5: 在線狀態同步 —— 把 RTDB 的 presence/{uid} 同步到 Redis 供雷達判定
// ============================================================================
exports.syncPresence = functionsV1.runWith({ secrets: UPSTASH_SECRETS }).database.ref('/presence/{uid}')
  .onWrite(async (change, context) => {
    const data = change.after.val();
    if (!data || !data.state || !data.at) return null;
    const uid = context.params.uid;
    try {
        // 只接受比 Redis 現有狀態更新的事件，避免延遲送達的舊事件覆蓋新狀態
        const [currentAt] = await sendUpstashCommand(["HMGET", `user_data:${uid}`, "stateAt"]);
        if (currentAt && parseInt(currentAt, 10) > data.at) return null;
        await sendUpstashCommand(["HSET", `user_data:${uid}`, "state", data.state, "stateAt", String(data.at)]);
    } catch (e) {
        console.error(`syncPresence failed (${uid}):`, e);
    }
    return null;
  });
