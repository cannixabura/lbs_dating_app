const { onRequest } = require("firebase-functions/v2/https");
const functionsV1 = require("firebase-functions/v1");
const admin = require("firebase-admin");
const { defineSecret } = require("firebase-functions/params");
const cors = require("cors")({ origin: true });

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
const STALE_AFTER_MS = 10 * 24 * 60 * 60 * 1000; // 與 App 端殘影完全消失的 10 天一致

async function upstashFetch(path, body) {
    const response = await fetch(UPSTASH_URL.value() + path, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${UPSTASH_TOKEN.value()}`, 'Content-Type': 'application/json' },
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
    const mood = String(req.body.mood || "").slice(0, MAX_MOOD_LENGTH);
    const nickname = String(req.body.nickname || "").slice(0, MAX_NICKNAME_LENGTH);
    const timestamp = Date.now();
    try {
      await sendUpstashPipeline([
          ["GEOADD", "city_users", lng.toString(), lat.toString(), uid],
          ["HSET", `user_data:${uid}`, "mood", mood, "nickname", nickname, "timestamp", timestamp.toString()],
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
      // 1 次請求：由近到遠取出半徑內的人，座標直接由地理索引帶回
      const nearby = await sendUpstashCommand([
          "GEOSEARCH", "city_users", "FROMLONLAT", lng.toString(), lat.toString(),
          "BYRADIUS", radiusKM.toString(), "km", "ASC", "COUNT", MAX_NEARBY_RESULTS.toString(), "WITHCOORD"
      ]);
      const members = (Array.isArray(nearby) ? nearby : []).filter((m) => Array.isArray(m) && m[0]);

      // 1 次請求：以 pipeline 一口氣取回所有人的心情 / 暱稱 / 時間戳
      const profiles = await sendUpstashPipeline(
          members.map(([memberUid]) => ["HMGET", `user_data:${memberUid}`, "mood", "nickname", "timestamp"])
      );

      const now = Date.now();
      const results = [];
      const staleUids = [];
      members.forEach(([memberUid, coord], i) => {
          const [mood, nickname, timestamp] = profiles[i] || [];
          const ts = parseInt(timestamp || "0", 10);
          if (!ts || now - ts > STALE_AFTER_MS) { staleUids.push(memberUid); return; }
          results.push({ uid: memberUid, lng: parseFloat(coord[0]), lat: parseFloat(coord[1]), mood: mood || "", nickname: nickname || "", timestamp: ts });
      });

      // 🧹 順手清掉超過 10 天沒出現的殘影，避免地理索引無限膨脹
      if (staleUids.length > 0) {
          try {
              await sendUpstashPipeline([["ZREM", "city_users", ...staleUids], ...staleUids.map((u) => ["DEL", `user_data:${u}`])]);
          } catch (e) { console.error('stale cleanup failed:', e); }
      }

      res.status(200).json({ success: true, data: results });
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