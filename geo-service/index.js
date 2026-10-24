const { onRequest } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const functionsV1 = require("firebase-functions/v1");
const admin = require("firebase-admin");
const { defineSecret } = require("firebase-functions/params");
const cors = require("cors")({ origin: true });
const {
    DENSITY_RADIUS_KM, MAX_SHADOW_RETENTION_MS, shadowRetentionFor, classifyPresence,
} = require("./presence");
const { evaluateReports } = require("./moderation");
const { fuzzLocation } = require("./fuzz");
const citymood = require("./citymood");
const whisper = require("./whisper");
const { maskBlockedTerms } = require("./contentfilter");
const demo = require("./demo");
const betasignup = require("./betasignup");
const gathering = require("./gathering");
const publicmood = require("./publicmood");
const timewhisper = require("./timewhisper");

// 位置模糊化開關（2026-10 暫時關閉，雷達顯示真實位置；距離仍由 App 分級顯示）。
// 重新開啟：改成 true 並重新部署 geo-service，同時更新隱私權政策與使用條款的位置說明。
const FUZZ_LOCATION = false;

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
    // 不當字詞替換成「＊」（App Store 1.2 的內容過濾）
    // 審核通關碼：心情欄輸入後開啟審核示範對象，通關碼本身不會出現在雷達上
    const reviewCode = demo.isReviewCode(req.body.mood);
    const mood = reviewCode ? demo.REVIEW_MOOD : maskBlockedTerms(truncateVisible(req.body.mood, MAX_MOOD_LENGTH));
    const nickname = maskBlockedTerms(truncateVisible(req.body.nickname, MAX_NICKNAME_LENGTH));
    const timestamp = Date.now();
    try {
      if (reviewCode) await sendUpstashCommand(["SADD", demo.REVIEWERS_KEY, uid]);
      // 🔒 先算出對外公開的模糊位置（100m 網格，含遲滯）；精確座標只進地理索引，不會回傳給任何人
      const fuzzFields = [];
      if (FUZZ_LOCATION) {
          const [prevRow, prevCol] = await sendUpstashCommand(["HMGET", `user_data:${uid}`, "cellRow", "cellCol"]);
          const previousCell = prevRow != null && prevCol != null ? { row: parseInt(prevRow, 10), col: parseInt(prevCol, 10) } : null;
          const pub = fuzzLocation(lat, lng, uid, previousCell, timestamp);
          fuzzFields.push("flat", pub.lat.toString(), "flng", pub.lng.toString(), "cellRow", String(pub.row), "cellCol", String(pub.col));
      }
      const [, , hostingGid] = await sendUpstashPipeline([
          ["GEOADD", "city_users", lng.toString(), lat.toString(), uid],
          // 只有前景的 App 會呼叫，因此同時視為「活躍」心跳
          ["HSET", `user_data:${uid}`, "mood", mood, "nickname", nickname, "timestamp", timestamp.toString(),
              "state", "active", "stateAt", timestamp.toString(), ...fuzzFields],
          ["HGET", `user_data:${uid}`, "host"],
      ]);
      // 集會的中心跟著主持人走（遊行隊伍會移動）；活動已被結束（例如人工審查）就移除「主持」標記
      if (hostingGid) {
          try {
              const status = (await admin.database().ref(`gatherings/${hostingGid}/status`).once('value')).val();
              if (status === 'active') await admin.database().ref(`gatherings/${hostingGid}`).update(gathering.publicCenter(lat, lng));
              else await sendUpstashCommand(["HDEL", `user_data:${uid}`, "host", "hostEmoji"]);
          } catch (e) { console.error('gathering centre update failed:', e); }
      }
      res.status(200).json({ success: true, message: "更新成功" });
    } catch (error) {
      console.error('updateLocation failed:', error);
      res.status(500).json({ success: false, error: "更新失敗" });
    }
  });
});

/**
 * 附近的示範對象：台北示範（所有人）＋審核示範（只給輸入過通關碼的帳號）。
 * 不計入密度，也不在 city_users 裡，所以不影響殘影留存與城市心情天氣。
 * realCount：附近的真人數（不含殘影）；真人多時台北示範減量，審核示範不受影響。
 */
async function nearbyDemoBots(viewerUid, lat, lng, radiusKM, realCount = 0) {
    const here = { lat, lng };
    const found = []; // [uid, distanceKm, {lat, lng}]
    const publicHits = await sendUpstashCommand([
        "GEOSEARCH", demo.PUBLIC_GEO_KEY, "FROMLONLAT", lng.toString(), lat.toString(),
        "BYRADIUS", radiusKM.toString(), "km", "ASC", "COUNT",
        String(realCount >= demo.CROWDED_REAL_USERS ? demo.CROWDED_MAX_RESULTS : demo.PUBLIC_MAX_RESULTS), "WITHDIST", "WITHCOORD",
    ]);
    for (const m of Array.isArray(publicHits) ? publicHits : []) {
        if (Array.isArray(m) && m[0]) found.push([m[0], parseFloat(m[1]), { lat: parseFloat(m[2][1]), lng: parseFloat(m[2][0]) }]);
    }

    const isReviewer = await sendUpstashCommand(["SISMEMBER", demo.REVIEWERS_KEY, viewerUid]);
    if (isReviewer === 1) {
        // 錨點跟著審核人員：第一次或移動超過 5 公里時重新放置
        const [aLat, aLng] = (await sendUpstashCommand(["HMGET", `demo_anchor:${viewerUid}`, "lat", "lng"])) || [];
        let anchor = aLat && aLng ? { lat: parseFloat(aLat), lng: parseFloat(aLng) } : null;
        if (!anchor || demo.distanceKm(anchor, here) > demo.REVIEW_REANCHOR_KM) {
            anchor = here;
            await sendUpstashCommand(["HSET", `demo_anchor:${viewerUid}`, "lat", String(lat), "lng", String(lng)]);
        }
        for (const bot of demo.reviewBots(anchor)) {
            const d = demo.distanceKm(here, bot);
            if (d <= radiusKM) found.push([bot.uid, d, { lat: bot.lat, lng: bot.lng }]);
        }
    }
    if (found.length === 0) return [];

    const profiles = await sendUpstashPipeline(found.map(([botUid]) => ["HMGET", `user_data:${botUid}`, "mood", "nickname", "hidden", "hostEmoji"]));
    const now = Date.now();
    const bots = [];
    found.forEach(([botUid, , pos], i) => {
        const [mood, nickname, hidden, hostEmoji] = profiles[i] || [];
        if (hidden === "1" || !nickname) return; // 被檢舉隱藏，或尚未建立資料
        bots.push({ uid: botUid, lat: pos.lat, lng: pos.lng, mood: mood || "", nickname, status: 'active', shadowAge: 0, timestamp: now, demo: true, ...(hostEmoji ? { hostEmoji } : {}) });
    });
    return bots;
}

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
          members.map(([memberUid]) => ["HMGET", `user_data:${memberUid}`, "mood", "nickname", "timestamp", "state", "stateAt", "hidden", "flat", "flng", "hostEmoji"])
      );

      const now = Date.now();
      const staleUids = [];
      const candidates = [];
      members.forEach(([memberUid, dist, coord], i) => {
          const [mood, nickname, timestamp, state, stateAt, hidden, flat, flng, hostEmoji] = profiles[i] || [];
          if (hidden === "1") return; // 被檢舉自動隱藏或人工隱藏，不出現在任何人的雷達上
          const lastSeen = parseInt(timestamp || "0", 10);
          if (!lastSeen) { staleUids.push(memberUid); return; }
          const presence = classifyPresence(state || null, parseInt(stateAt || "0", 10), lastSeen, now);
          // 超過最長留存（10 天）的殘影，任何密度下都不會再顯示，直接清除
          if (presence.status === 'shadow' && now - presence.shadowSince > MAX_SHADOW_RETENTION_MS) { staleUids.push(memberUid); return; }
          const precise = { lat: parseFloat(coord[1]), lng: parseFloat(coord[0]) };
          // 模糊化開啟時只回傳模糊位置；舊資料沒有存模糊位置時，當場由精確座標換算（無遲滯）
          const pub = !FUZZ_LOCATION ? precise
              : flat && flng ? { lat: parseFloat(flat), lng: parseFloat(flng) }
              : fuzzLocation(precise.lat, precise.lng, memberUid, null, now);
          candidates.push({ memberUid, dist: parseFloat(dist), pub, mood, nickname, lastSeen, presence, hostEmoji });
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
              uid: c.memberUid, lng: c.pub.lng, lat: c.pub.lat,
              mood: c.mood || "",
              nickname: status === 'shadow' ? "" : (c.nickname || ""), // 殘影不公開暱稱
              status,
              shadowAge, // 0 = 剛成為殘影，1 = 即將消失；供 App 計算淡出程度
              timestamp: c.lastSeen,
              // 正在主持集會：雷達上顯示「主持」光環與活動圖標（殘影不顯示）
              ...(c.hostEmoji && status !== 'shadow' ? { hostEmoji: c.hostEmoji } : {}),
          });
      }

      const realCount = results.filter((r) => r.status !== 'shadow').length;
      results.push(...await nearbyDemoBots(uid, lat, lng, radiusKM, realCount));

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

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function replyAsDemoBot(roomId, botUid) {
    const room = admin.database().ref(`/chats/${roomId}`);
    try {
        await room.child(`typing/${botUid}`).set(true);
        await sleep(1800);
        const [status, messagesSnap] = await Promise.all([room.child('status').once('value'), room.child('messages').once('value')]);
        if (status.val() !== 'active') return; // 使用者已經離開
        let botMessages = 0;
        messagesSnap.forEach((m) => { if (m.child('sender').val() === botUid) botMessages++; });
        const botName = (await getNicknameFromRedis(botUid)) || '示範對象';
        await room.child('messages').push({ sender: botUid, senderName: botName, text: demo.chatReply(botMessages), timestamp: Date.now() });
    } catch (e) {
        console.error(`demo bot reply failed (${roomId}):`, e);
    } finally {
        await room.child(`typing/${botUid}`).remove().catch(() => {});
    }
}

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

    // 示範對象：稍等一下（讓敲門儀式的虛線弧跑一會兒）就自動同意
    if (demo.isDemoUid(targetUid)) {
        await sleep(2500);
        const ref = admin.database().ref(`/requests/${targetUid}/${senderUid}`);
        const current = (await ref.once('value')).val();
        if (current && current.status === 'pending') {
            const botName = (await getNicknameFromRedis(targetUid)) || '示範對象';
            await ref.set({ status: 'accepted', nickname: botName });
        }
        return null;
    }

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
    const roomId = context.params.roomId;
    const targetUid = roomId.split('_').find(id => id !== senderUid);
    if (!targetUid) return null;

    // 示範對象：輸入中一下，再依序回覆說明；示範對象沒有推播權杖，不需要推播
    if (demo.isDemoUid(targetUid)) {
        await replyAsDemoBot(roomId, targetUid);
        return null;
    }
    if (demo.isDemoUid(senderUid)) return null; // 使用者正在聊天室裡，訊息已在畫面上

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

// ============================================================================
// API 6: 檢舉 —— 24 小時內被 3 個不同的人檢舉，自動從雷達隱藏並等待人工審查
// ============================================================================
exports.onReportCreated = functionsV1.runWith({ secrets: UPSTASH_SECRETS, timeoutSeconds: 300 }).database.ref('/reports/{reportId}')
  .onCreate(async (snapshot) => {
    const report = snapshot.val();
    if (!report || !report.target) return null;
    const target = report.target;
    // 集會的檢舉：一律進人工審查；達到門檻只隱藏那一則公告，活動不自動結束
    if (report.context === 'gathering') {
        try { await handleGatheringReport(target, report); } catch (e) { console.error(`[檢舉] 集會處理失敗 (${target}):`, e); }
        return null;
    }
    // 低語的檢舉：target = "whisper:<id>"，3 個不同的人檢舉就隱藏這則低語
    if (report.context === 'whisper' && String(target).startsWith('whisper:')) {
        try {
            const all = (await admin.database().ref('/reports').orderByChild('target').equalTo(target).once('value')).val() || {};
            const { hide, reporters } = evaluateReports(Object.values(all), Date.now());
            console.log(`[檢舉] 低語 ${target} 被檢舉（${report.reason}），24 小時內共 ${reporters} 人`);
            if (hide) {
                await sendUpstashCommand(["HSET", `whisper:${target.slice(8)}`, "hidden", "1"]);
                console.warn(`[檢舉] 低語 ${target} 已自動隱藏，請到 Firebase 主控台審查`);
            }
        } catch (e) { console.error(`[檢舉] 低語處理失敗 (${target}):`, e); }
        return null;
    }
    try {
        const all = (await admin.database().ref('/reports').orderByChild('target').equalTo(target).once('value')).val() || {};
        const { hide, reporters } = evaluateReports(Object.values(all), Date.now());
        console.log(`[檢舉] ${target} 被 ${report.reporter} 檢舉（${report.reason}），24 小時內共 ${reporters} 人`);
        if (!hide) return null;
        const modRef = admin.database().ref(`/moderation/${target}`);
        const current = (await modRef.once('value')).val();
        if (current && current.hidden === true) return null;
        await modRef.set({ hidden: true, at: Date.now(), reason: `auto: ${reporters} reporters in 24h`, reviewed: false });
        console.warn(`[檢舉] ${target} 已自動隱藏，請在 24 小時內到 Firebase 主控台審查 reports 與 moderation/${target}`);
    } catch (e) {
        console.error(`[檢舉] 處理失敗 (${target}):`, e);
    }
    return null;
  });

// 審核狀態同步到 Redis：getNearby 依此過濾。人工解除隱藏 = 把 moderation/{uid}/hidden 改成 false 或刪除
exports.syncModeration = functionsV1.runWith({ secrets: UPSTASH_SECRETS }).database.ref('/moderation/{uid}')
  .onWrite(async (change, context) => {
    const data = change.after.val();
    const hidden = !!(data && data.hidden === true);
    try {
        await sendUpstashCommand(["HSET", `user_data:${context.params.uid}`, "hidden", hidden ? "1" : "0"]);
    } catch (e) {
        console.error(`syncModeration failed (${context.params.uid}):`, e);
    }
    return null;
  });

// ============================================================================
// API 7: 刪除帳號（Apple 5.1.1(v)：App 內可建立帳號，就必須能在 App 內刪除）
// 刪除：雷達位置、心情與暱稱、大頭貼、推播權杖、在線狀態、封鎖名單、敲門請求、聊天室、同意紀錄、登入身分。
// 保留：檢舉紀錄與審核狀態（隱私權政策載明保存 1 年，用於防止濫用）。
// ============================================================================
exports.deleteAccount = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: "未授權" });

    const db = admin.database();
    try {
      // 正在主持的集會先結束（通知參加的人），再刪資料
      const hostingGid = (await db.ref(`hosting/${uid}`).once("value")).val();
      if (hostingGid) await endGathering(hostingGid, 'host_left');
      await sendUpstashPipeline([["ZREM", "city_users", uid], ["DEL", `user_data:${uid}`], ["SREM", demo.REVIEWERS_KEY, uid], ["DEL", `demo_anchor:${uid}`]]);
      const myWhispers = (await sendUpstashCommand(["SMEMBERS", `whispers_by:${uid}`])) || [];
      if (myWhispers.length > 0) {
          await sendUpstashPipeline([["ZREM", "whispers", ...myWhispers], ...myWhispers.map((id) => ["DEL", `whisper:${id}`, `whisper_readers:${id}`]), ["DEL", `whispers_by:${uid}`]]);
      }
      // 收下別人低語時留下的讀者紀錄（只保留匿名的收下次數）
      const allWhispers = (await sendUpstashCommand(["ZRANGE", "whispers", "0", "-1"])) || [];
      if (allWhispers.length > 0) {
          await sendUpstashPipeline(allWhispers.map((id) => ["SREM", `whisper_readers:${id}`, uid]));
      }

      const updates = {};
      for (const path of ["presence", "profiles", "user_avatars", "tokens", "blocks", "blockedBy", "consents", "requests", "resonance", "resonancePush", "gatheringHandoffs", "timeWhispers"]) {
          updates[`${path}/${uid}`] = null;
      }
      // 自己寫在別人底下的資料：封鎖對方時的 blockedBy、對別人的敲門
      const myBlocks = (await db.ref(`blocks/${uid}`).once("value")).val() || {};
      for (const target of Object.keys(myBlocks)) updates[`blockedBy/${target}/${uid}`] = null;
      const requestTargets = (await db.ref("requests").once("value")).val() || {};
      for (const [target, senders] of Object.entries(requestTargets)) {
          if (senders && Object.prototype.hasOwnProperty.call(senders, uid)) updates[`requests/${target}/${uid}`] = null;
      }
      // 送給別人的微光
      const resonanceTargets = (await db.ref("resonance").once("value")).val() || {};
      for (const [target, senders] of Object.entries(resonanceTargets)) {
          if (target !== uid && senders && Object.prototype.hasOwnProperty.call(senders, uid)) updates[`resonance/${target}/${uid}`] = null;
      }
      // 低語穿越的解封提醒排程
      const twQueue = (await db.ref("timeWhisperQueue").orderByChild("uid").equalTo(uid).once("value")).val() || {};
      for (const id of Object.keys(twQueue)) updates[`timeWhisperQueue/${id}`] = null;
      const rooms = (await db.ref("chats").once("value")).val() || {};
      for (const roomId of Object.keys(rooms)) {
          if (roomId.split("_").includes(uid)) updates[`chats/${roomId}`] = null;
      }
      await db.ref().update(updates);

      try {
          await admin.storage().bucket().file(`avatars/${uid}.jpg`).delete();
      } catch (e) {
          if (e.code !== 404) console.error(`deleteAccount avatar (${uid}):`, e);
      }
      await admin.auth().deleteUser(uid);

      console.log(`[刪除帳號] ${uid} 已刪除（${Object.keys(updates).length} 個資料節點）`);
      res.status(200).json({ success: true });
    } catch (error) {
      console.error(`deleteAccount failed (${uid}):`, error);
      res.status(500).json({ success: false, error: "刪除失敗" });
    }
  });
});

// ============================================================================
// API 8: 共鳴推播 —— 有人送你一道微光；同一人 30 分鐘內最多一則，避免洗版
// ============================================================================
const RESONANCE_PUSH_THROTTLE_MS = 30 * 60 * 1000;

exports.notifyOnResonance = functionsV1.database.ref('/resonance/{targetUid}/{senderUid}')
  .onWrite(async (change, context) => {
    const after = change.after.val();
    const before = change.before.val();
    if (typeof after !== 'number' || (typeof before === 'number' && before >= after)) return null; // 刪除或舊值，不推播
    const targetUid = context.params.targetUid;

    // 示範對象收到微光：回送一道，讓使用者也體驗「收到微光」（24 小時一次，和真人規則相同）
    if (demo.isDemoUid(targetUid)) {
        const senderUid = context.params.senderUid;
        if (demo.isDemoUid(senderUid)) return null;
        await sleep(3000);
        const back = admin.database().ref(`/resonance/${senderUid}/${targetUid}`);
        const last = (await back.once('value')).val();
        if (typeof last !== 'number' || Date.now() - last > 24 * 60 * 60 * 1000) await back.set(Date.now());
        return null;
    }
    const throttleRef = admin.database().ref(`/resonancePush/${targetUid}`);
    try {
        // 用交易確保同時多道微光只推一次
        const result = await throttleRef.transaction((last) => {
            if (typeof last === 'number' && Date.now() - last < RESONANCE_PUSH_THROTTLE_MS) return; // 放棄寫入
            return Date.now();
        });
        if (!result.committed) return null;
        await sendPush(targetUid, '城市低語', '有人在附近，與你的心情共鳴了。', { type: 'resonance' });
    } catch (e) {
        console.error(`notifyOnResonance failed (${targetUid}):`, e);
    }
    return null;
  });

// ============================================================================
// API 9: 城市心情天氣 —— 20 公里內、24 小時內的匿名心情百分比（少於 10 人只回「城市還很安靜」）
// ============================================================================
const CITY_MOOD_CACHE_SECONDS = 300;
const CITY_MOOD_MAX_PEOPLE = 3000;

// ============================================================================
// API: 公測報名（落地頁 beta.html）。不需登入；以隱藏欄位與 IP 頻率限制擋機器人
// ============================================================================
exports.betaSignup = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const checked = betasignup.validateSignup(req.body, Date.now());
    if (checked.error === "bot") return res.status(200).json({ success: true }); // 不讓機器人知道被擋
    if (checked.error) return res.status(400).json({ success: false, error: checked.error });
    try {
      const ip = String(req.headers["x-forwarded-for"] || req.ip || "").split(",")[0].trim() || "unknown";
      const n = await sendUpstashCommand(["INCR", `beta_rl:${ip}`]);
      if (n === 1) await sendUpstashCommand(["EXPIRE", `beta_rl:${ip}`, "600"]);
      if (n > 5) return res.status(429).json({ success: false, error: "報名太頻繁了，請稍後再試。" });
      await admin.database().ref(`betaSignups/${checked.key}`).set(checked.record);
      res.status(200).json({ success: true });
    } catch (e) {
      console.error("betaSignup failed:", e);
      res.status(500).json({ success: false, error: "報名沒有送出，請稍後再試。" });
    }
  });
});

exports.getCityMood = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: "未授權" });
    const { lat, lng } = req.body;
    if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: "座標格式錯誤" });

    const key = citymood.cacheKey(lat, lng);
    try {
      const cached = await sendUpstashCommand(["GET", key]);
      if (cached) return res.status(200).json({ success: true, data: JSON.parse(cached), cached: true });

      const members = await sendUpstashCommand([
          "GEOSEARCH", "city_users", "FROMLONLAT", lng.toString(), lat.toString(),
          "BYRADIUS", String(citymood.CITY_RADIUS_KM), "km", "COUNT", String(CITY_MOOD_MAX_PEOPLE),
      ]);
      const uids = Array.isArray(members) ? members.filter(Boolean) : [];
      const rows = await sendUpstashPipeline(uids.map((u) => ["HMGET", `user_data:${u}`, "mood", "timestamp", "hidden"]));
      const people = rows
          .filter((r) => r && r[2] !== "1")
          .map(([mood, ts]) => ({ mood, lastSeen: parseInt(ts || "0", 10) }));
      const summary = citymood.summarize(people, Date.now());

      await sendUpstashCommand(["SET", key, JSON.stringify(summary), "EX", String(CITY_MOOD_CACHE_SECONDS)]);
      res.status(200).json({ success: true, data: summary });
    } catch (error) {
      console.error('getCityMood failed:', error);
      res.status(500).json({ success: false, error: "讀取失敗" });
    }
  });
});

// ============================================================================
// API 10: 低語（城市漂流瓶）—— action: post / list / collect / delete
//   作者永遠不回傳給其他人；位置對齊到 100 公尺網格；7 天後自動消失
// ============================================================================
const WHISPER_TTL = String(whisper.TTL_SECONDS);

async function blockedUidsFor(uid) {
    const [mine, byOthers] = await Promise.all([
        admin.database().ref(`blocks/${uid}`).once('value'),
        admin.database().ref(`blockedBy/${uid}`).once('value'),
    ]);
    return new Set([...Object.keys(mine.val() || {}), ...Object.keys(byOthers.val() || {})]);
}

exports.whisper = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: "未授權" });
    const { action, lat, lng, id } = req.body || {};
    const now = Date.now();
    try {
      if (action === "post") {
        if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: "座標格式錯誤" });
        const checked = whisper.validateText(req.body.text);
        if (checked.error) return res.status(400).json({ success: false, error: checked.error });
        const moderation = (await admin.database().ref(`moderation/${uid}/hidden`).once('value')).val();
        if (moderation === true) return res.status(403).json({ success: false, error: "你的帳號正在審查中，暫時無法留下低語。" });

        // 每人同時最多 3 則（先清掉已過期的）
        const mine = (await sendUpstashCommand(["SMEMBERS", `whispers_by:${uid}`])) || [];
        const alive = mine.length ? await sendUpstashPipeline(mine.map((w) => ["EXISTS", `whisper:${w}`])) : [];
        const expired = mine.filter((_, i) => !alive[i]);
        if (expired.length) await sendUpstashPipeline([["SREM", `whispers_by:${uid}`, ...expired], ["ZREM", "whispers", ...expired]]);
        if (mine.length - expired.length >= whisper.MAX_ACTIVE_PER_USER) {
            return res.status(429).json({ success: false, error: `你已經在城市裡留下 ${whisper.MAX_ACTIVE_PER_USER} 則低語了，等其中一則消散再留吧。` });
        }
        // 每 10 分鐘最多 1 則
        const ok = await sendUpstashCommand(["SET", `whisper_rl:${uid}`, "1", "EX", String(whisper.POST_COOLDOWN_SECONDS), "NX"]);
        if (ok !== "OK") return res.status(429).json({ success: false, error: "剛剛才留過低語，過幾分鐘再來吧。" });

        const wid = `${now.toString(36)}${Math.random().toString(36).slice(2, 8)}`;
        const pos = whisper.snapToCell(lat, lng);
        const moodKey = citymood.classifyMood(req.body.mood);
        await sendUpstashPipeline([
            ["GEOADD", "whispers", pos.lng.toString(), pos.lat.toString(), wid],
            ["HSET", `whisper:${wid}`, "text", checked.text, "author", uid, "createdAt", String(now), "mood", moodKey, "reads", "0", "hidden", "0"],
            ["EXPIRE", `whisper:${wid}`, WHISPER_TTL],
            ["SADD", `whispers_by:${uid}`, wid],
            ["EXPIRE", `whispers_by:${uid}`, WHISPER_TTL],
        ]);
        return res.status(200).json({ success: true, data: { id: wid } });
      }

      if (action === "list") {
        if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: "座標格式錯誤" });
        const found = await sendUpstashCommand([
            "GEOSEARCH", "whispers", "FROMLONLAT", lng.toString(), lat.toString(),
            "BYRADIUS", String(whisper.DISCOVER_RADIUS_KM), "km", "ASC", "COUNT", String(whisper.MAX_RESULTS), "WITHCOORD",
        ]);
        const items = (Array.isArray(found) ? found : []).filter((f) => Array.isArray(f) && f[0]);
        const rows = await sendUpstashPipeline(items.map(([wid]) => ["HMGET", `whisper:${wid}`, "text", "author", "createdAt", "mood", "reads", "hidden"]));
        const blocked = await blockedUidsFor(uid);
        const gone = [];
        const data = [];
        items.forEach(([wid, coord], i) => {
            const [text, author, createdAt, mood, reads, hidden] = rows[i] || [];
            if (!text) { gone.push(wid); return; }             // 已過期
            if (hidden === "1" || blocked.has(author)) return;  // 被檢舉隱藏，或與作者互相封鎖
            data.push({
                id: wid, text, mood: mood || "other",
                createdAt: parseInt(createdAt, 10), reads: parseInt(reads || "0", 10),
                lat: parseFloat(coord[1]), lng: parseFloat(coord[0]),
                mine: author === uid,                            // 作者本人才知道是自己的；從不回傳作者 uid
            });
        });
        if (gone.length) await sendUpstashCommand(["ZREM", "whispers", ...gone]);
        return res.status(200).json({ success: true, data });
      }

      if (action === "collect") {
        const author = await sendUpstashCommand(["HGET", `whisper:${id}`, "author"]);
        if (!author) return res.status(404).json({ success: false, error: "這則低語已經消散了。" });
        if (author === uid) return res.status(200).json({ success: true });
        const added = await sendUpstashCommand(["SADD", `whisper_readers:${id}`, uid]);
        if (added === 1) {
            await sendUpstashPipeline([["HINCRBY", `whisper:${id}`, "reads", "1"], ["EXPIRE", `whisper_readers:${id}`, WHISPER_TTL]]);
        }
        return res.status(200).json({ success: true });
      }

      if (action === "delete") {
        const author = await sendUpstashCommand(["HGET", `whisper:${id}`, "author"]);
        if (author !== uid) return res.status(403).json({ success: false, error: "只能收回自己的低語。" });
        await sendUpstashPipeline([["ZREM", "whispers", id], ["DEL", `whisper:${id}`, `whisper_readers:${id}`], ["SREM", `whispers_by:${uid}`, id]]);
        return res.status(200).json({ success: true });
      }

      return res.status(400).json({ success: false, error: "未知的操作" });
    } catch (error) {
      console.error(`whisper ${action} failed:`, error);
      res.status(500).json({ success: false, error: "低語暫時無法使用，請稍後再試。" });
    }
  });
});


// ============================================================================
// API 11: 集會 —— action: create / end / announce / ask / answer
//   任何人都能開；以主持人的位置為中心 5 公里；用一個表情符號識別。
//   稱呼裡有這個符號、又在範圍內的人就是參加者：看得到置頂公告、收得到推播、可以回答提問。
//   主持人看不到參加者是誰；提問只回傳比例（少於 10 人不給比例）。
// ============================================================================
const GATHERING_AUDIENCE_MAX = 100000; // 遊行等大型集會：5 公里內所有人都要能篩到
const GATHERING_LOOKUP_CHUNK = 1000;
const GATHERING_AUDIENCE_FRESH_MS = 12 * 60 * 60 * 1000; // 12 小時內出現過的人才推播

async function readGathering(gid) {
    return (await admin.database().ref(`gatherings/${gid}`).once('value')).val();
}

/** 參加者：主持人 5 公里內、稱呼裡有活動圖標、沒有和主持人互相封鎖、沒有被隱藏 */
async function gatheringAudience(g) {
    const found = await sendUpstashCommand([
        "GEOSEARCH", "city_users", "FROMLONLAT", String(g.lng), String(g.lat),
        "BYRADIUS", String(gathering.PARTICIPANT_RADIUS_KM), "km", "COUNT", String(GATHERING_AUDIENCE_MAX),
    ]);
    const uids = (Array.isArray(found) ? found : []).filter((u) => u && u !== g.hostUid && !u.startsWith(demo.DEMO_PREFIX));
    if (uids.length === 0) return [];
    const rows = [];
    for (let i = 0; i < uids.length; i += GATHERING_LOOKUP_CHUNK) {
        rows.push(...await sendUpstashPipeline(uids.slice(i, i + GATHERING_LOOKUP_CHUNK).map((u) => ["HMGET", `user_data:${u}`, "nickname", "timestamp", "hidden"])));
    }
    const blocked = await blockedUidsFor(g.hostUid);
    const now = Date.now();
    return uids.filter((u, i) => {
        const [nickname, ts, hidden] = rows[i] || [];
        if (hidden === "1" || blocked.has(u)) return false;
        if (now - parseInt(ts || "0", 10) > GATHERING_AUDIENCE_FRESH_MS) return false;
        return gathering.emojiKeysIn(nickname).has(g.emojiKey);
    });
}

/** 一次推給很多人：每批 500 則 */
async function pushToMany(uids, title, body, data) {
    if (uids.length === 0) return 0;
    const tokens = [];
    for (let i = 0; i < uids.length; i += GATHERING_LOOKUP_CHUNK) {
        const snaps = await Promise.all(uids.slice(i, i + GATHERING_LOOKUP_CHUNK).map((u) => admin.database().ref(`tokens/${u}`).once('value')));
        tokens.push(...snaps.map((snap) => snap.val()).filter(Boolean));
    }
    let sent = 0;
    for (let i = 0; i < tokens.length; i += 500) {
        const messages = tokens.slice(i, i + 500).map((token) => ({
            token,
            notification: { title, body },
            data,
            android: { priority: 'high', notification: { sound: 'default' } },
            apns: { headers: { 'apns-priority': '10' }, payload: { aps: { sound: 'default' } } },
        }));
        try {
            const result = await admin.messaging().sendEach(messages);
            sent += result.successCount;
        } catch (e) { console.error('gathering push batch failed:', e); }
    }
    return sent;
}

async function notifyGathering(gid, g, body) {
    try {
        const audience = await gatheringAudience(g);
        const sent = await pushToMany(audience, `${g.emoji} ${g.name}`, body, { type: 'gathering', gid });
        console.log(`[集會] ${gid} 推播 ${sent}/${audience.length} 人`);
    } catch (e) { console.error(`[集會] ${gid} 推播失敗:`, e); }
}

const GATHERING_END_MESSAGES = {
    host: '活動結束了，謝謝你今晚一起在這裡。',
    expired: '活動時間到了，謝謝你今晚一起在這裡。',
    host_left: '主持人已離開，活動結束。',
};

/** 結束活動：主持人變回一般使用者，圖標釋出給下一位；通知參加的人 */
async function endGathering(gid, reason) {
    const ref = admin.database().ref(`gatherings/${gid}`);
    const before = (await ref.once('value')).val();
    if (!before || before.status !== 'active') return false;
    // 交易的第一次執行常拿到本地快取的 null：當成還在進行中，伺服器會用真實值再跑一次
    const result = await ref.child('status').transaction((status) => (status === 'active' || status === null ? 'ended' : undefined));
    if (!result.committed) return false;
    const g = before;
    await Promise.all([
        ref.update({ endedAt: Date.now(), endedReason: reason }),
        admin.database().ref(`hosting/${g.hostUid}`).remove(),
        sendUpstashCommand(["HDEL", `user_data:${g.hostUid}`, "host", "hostEmoji"]).catch(() => {}),
    ]);
    await notifyGathering(gid, g, GATHERING_END_MESSAGES[reason] || GATHERING_END_MESSAGES.host);
    return true;
}

exports.gathering = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS, timeoutSeconds: 300, memory: "512MiB" }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: "未授權" });
    const { action, gid } = req.body || {};
    const db = admin.database();
    const now = Date.now();
    const fail = (code, error) => res.status(code).json({ success: false, error });
    try {
      if (action === "create") {
        const { lat, lng } = req.body;
        if (!isValidCoordinate(lat, lng)) return fail(400, "座標格式錯誤");
        if ((await db.ref(`moderation/${uid}/hidden`).once('value')).val() === true) return fail(403, "你的帳號正在審查中，暫時無法主持活動。");
        const current = (await db.ref(`hosting/${uid}`).once('value')).val();
        if (current) {
            const g = await readGathering(current);
            if (g && g.status === 'active') return fail(409, "你已經在主持一場活動了，先結束它再開新的。");
        }
        const name = gathering.validateName(req.body.name);
        if (name.error) return fail(400, name.error);
        const emoji = gathering.validateEmoji(req.body.emoji);
        if (emoji.error) return fail(400, emoji.error);
        const times = gathering.validateTimes(Number(req.body.startAt), Number(req.body.endAt), now);
        if (times.error) return fail(400, times.error);

        const center = gathering.publicCenter(lat, lng);
        const sameEmoji = Object.values((await db.ref('gatherings').orderByChild('emojiKey').equalTo(emoji.key).once('value')).val() || {})
            .filter((g) => g.status === 'active');
        if (gathering.conflicts(sameEmoji, center)) {
            return fail(409, `附近已經有人用 ${emoji.emoji} 開了活動，等它結束或換一個圖標吧。`);
        }

        const newGid = db.ref('gatherings').push().key;
        await db.ref().update({
            [`gatherings/${newGid}`]: {
                name: name.text, emoji: emoji.emoji, emojiKey: emoji.key,
                startAt: times.startAt, endAt: times.endAt, createdAt: now,
                hostUid: uid, status: 'active', ...center,
            },
            [`hosting/${uid}`]: newGid,
        });
        await sendUpstashCommand(["HSET", `user_data:${uid}`, "host", newGid, "hostEmoji", emoji.emoji]);
        console.log(`[集會] ${uid} 開了 ${newGid} ${emoji.emoji} ${name.text}`);
        return res.status(200).json({ success: true, data: { gid: newGid } });
      }

      // 被邀請接下主持的人：接受或婉拒（不需要是主持人，也不從 body 帶 gid）
      if (action === "accept-handoff" || action === "decline-handoff") {
        const offerRef = db.ref(`gatheringHandoffs/${uid}`);
        const offer = (await offerRef.once('value')).val();
        if (!offer || offer.expiresAt < now) {
            await offerRef.remove();
            return fail(410, "這個邀請已經失效了。");
        }
        const og = await readGathering(offer.gid);
        const stillValid = og && og.status === 'active' && og.hostUid === offer.fromUid;
        await Promise.all([offerRef.remove(), db.ref(`gatherings/${offer.gid}/pendingHandoff`).remove()]);
        if (!stillValid) return fail(410, "這場活動已經結束或換了主持人。");
        if (action === "decline-handoff") {
            await sendPush(offer.fromUid, `${og.emoji} ${og.name}`, "對方婉拒了接下主持。", { type: 'gathering_handoff', gid: offer.gid });
            return res.status(200).json({ success: true });
        }
        const problem = gathering.handoffProblem(og, await handoffCandidate(og, uid));
        if (problem) return fail(409, problem);
        await transferHost(offer.gid, og, uid, offer.quiet === true);
        return res.status(200).json({ success: true });
      }

      const g = gid ? await readGathering(gid) : null;
      if (!g) return fail(404, "找不到這場活動。");
      if (g.status !== 'active') return fail(410, "這場活動已經結束了。");
      const isHost = g.hostUid === uid;

      if (action === "end") {
        if (!isHost) return fail(403, "只有主持人可以結束活動。");
        if (!(await endGathering(gid, 'host'))) return fail(409, "活動沒有結束成功，請再試一次。");
        return res.status(200).json({ success: true });
      }

      if (action === "handoff") {
        if (!isHost) return fail(403, "只有主持人可以轉移活動。");
        const toUid = String(req.body.toUid || '');
        if (!toUid || toUid === uid || toUid.startsWith(demo.DEMO_PREFIX)) return fail(400, "無法把活動交給這位使用者。");
        const problem = gathering.handoffProblem(g, await handoffCandidate(g, toUid));
        if (problem) return fail(409, problem);
        const quiet = req.body.quiet === true;
        const expiresAt = now + gathering.HANDOFF_TTL_MS;
        const toName = (await getNicknameFromRedis(toUid)) || '';
        await db.ref().update({
            [`gatheringHandoffs/${toUid}`]: { gid, fromUid: uid, quiet, name: g.name, emoji: g.emoji, at: now, expiresAt },
            [`gatherings/${gid}/pendingHandoff`]: { toName, expiresAt },
        });
        await sendPush(toUid, `${g.emoji} ${g.name}`, "主持人想把這場活動交給你主持，打開 App 回覆。", { type: 'gathering_handoff', gid });
        return res.status(200).json({ success: true });
      }

      if (action === "cancel-handoff") {
        if (!isHost) return fail(403, "只有主持人可以取消。");
        const pending = (await db.ref('gatheringHandoffs').orderByChild('gid').equalTo(gid).once('value')).val() || {};
        const updates = { [`gatherings/${gid}/pendingHandoff`]: null };
        for (const target of Object.keys(pending)) updates[`gatheringHandoffs/${target}`] = null;
        await db.ref().update(updates);
        return res.status(200).json({ success: true });
      }

      if (action === "announce") {
        if (!isHost) return fail(403, "只有主持人可以發公告。");
        const checked = gathering.validateAnnouncement(req.body.text);
        if (checked.error) return fail(400, checked.error);
        const aRef = db.ref(`gatheringAnnouncements/${gid}`).push();
        const latest = { id: aRef.key, text: checked.text, at: now };
        await aRef.set({ text: checked.text, at: now });
        await db.ref(`gatherings/${gid}/latest`).set(latest);
        await notifyGathering(gid, g, checked.text);
        return res.status(200).json({ success: true });
      }

      if (action === "ask") {
        if (!isHost) return fail(403, "只有主持人可以提問。");
        const checked = gathering.validateQuestion(req.body.text);
        if (checked.error) return fail(400, checked.error);
        const qid = `${now.toString(36)}`;
        await db.ref().update({
            [`gatherings/${gid}/question`]: { id: qid, text: checked.text, at: now },
            [`gatheringTally/${gid}`]: { qid, total: 0, quiet: true },
        });
        await notifyGathering(gid, g, `主持人問：${checked.text}`);
        return res.status(200).json({ success: true });
      }

      if (action === "answer") {
        const q = g.question;
        if (!q || q.id !== req.body.qid) return fail(410, "這個問題已經換了。");
        const checked = gathering.validateAnswer(req.body.text);
        if (checked.error) return fail(400, checked.error);
        // 只有參加者能回答：稱呼裡有圖標、人在範圍內
        const [[nickname], pos] = await sendUpstashPipeline([
            ["HMGET", `user_data:${uid}`, "nickname"],
            ["GEOPOS", "city_users", uid],
        ]);
        const here = Array.isArray(pos) && pos[0] ? { lng: parseFloat(pos[0][0]), lat: parseFloat(pos[0][1]) } : null;
        if (!gathering.emojiKeysIn(nickname).has(g.emojiKey)) return fail(403, `把 ${g.emoji} 加進你的城市稱呼，就能參加這場活動。`);
        if (!here || gathering.distanceKm(here, g) > gathering.PARTICIPANT_RADIUS_KM) return fail(403, "你離活動有點遠，靠近一點再回答吧。");

        const answersRef = db.ref(`gatheringAnswers/${gid}/${q.id}`);
        await answersRef.child(uid).set(citymood.classifyMood(checked.text));
        const all = Object.values((await answersRef.once('value')).val() || {});
        await db.ref(`gatheringTally/${gid}`).set({ qid: q.id, ...gathering.tally(all) });
        return res.status(200).json({ success: true });
      }

      return fail(400, "未知的操作");
    } catch (error) {
      console.error(`gathering ${action} failed:`, error);
      res.status(500).json({ success: false, error: "活動功能暫時無法使用，請稍後再試。" });
    }
  });
});

/**
 * 集會檢舉的三層防護（防止選舉造勢等場合被對手惡意檢舉）：
 *   1. 檢舉針對單則公告；達門檻只隱藏那一則，活動照常進行。整場活動不因檢舉自動結束。
 *   2. 門檻 = max(10, 參加人數 10%)。
 *   3. 只計算「活動開始前就存在的帳號」且「此刻是參加者」的檢舉人；其他檢舉仍留紀錄給人工審查。
 * 每一則檢舉都會在 gatheringReview/<gid> 標記，24 小時內人工處理。
 */
async function handleGatheringReport(target, report) {
    const parsed = gathering.parseReportTarget(target);
    if (!parsed) return;
    const { gid, aid } = parsed;
    const db = admin.database();
    const g = await readGathering(gid);
    if (!g) return;
    await db.ref(`gatheringReview/${gid}`).update({ flagged: true, lastReportAt: Date.now(), name: g.name, emoji: g.emoji, hostUid: g.hostUid });
    console.warn(`[檢舉] 集會 ${gid}${aid ? ` 公告 ${aid}` : '（整場）'} 被檢舉（${report.reason}），已標記人工審查`);
    if (!aid || g.status !== 'active') return;

    const all = Object.values((await db.ref('/reports').orderByChild('target').equalTo(target).once('value')).val() || {});
    const reporters = [...new Set(all.map((r) => r.reporter).filter(Boolean))];
    const audience = new Set(await gatheringAudience(g));
    const threshold = gathering.reportThreshold(audience.size);
    let valid = 0;
    for (const uid of reporters) {
        if (!audience.has(uid)) continue;
        try {
            const created = Date.parse((await admin.auth().getUser(uid)).metadata.creationTime);
            if (created < g.startAt) valid++;
        } catch (e) { /* 帳號已刪除：不計入 */ }
    }
    console.log(`[檢舉] 公告 ${gid}/${aid}：有效檢舉 ${valid}/${threshold}（共 ${reporters.length} 人檢舉，參加者 ${audience.size} 人）`);
    if (valid < threshold) return;
    await hideAnnouncement(gid, aid);
    console.warn(`[檢舉] 公告 ${gid}/${aid} 已自動隱藏，請到 Firebase 主控台審查 gatheringReview/${gid}`);
}

/** 隱藏一則公告；若它是置頂的那則，改成前一則沒被隱藏的公告 */
async function hideAnnouncement(gid, aid) {
    const db = admin.database();
    await db.ref(`gatheringAnnouncements/${gid}/${aid}/hidden`).set(true);
    const latest = (await db.ref(`gatherings/${gid}/latest`).once('value')).val();
    if (!latest || latest.id !== aid) return;
    const items = (await db.ref(`gatheringAnnouncements/${gid}`).orderByChild('at').once('value')).val() || {};
    const visible = Object.entries(items).filter(([, a]) => !a.hidden).sort((a, b) => b[1].at - a[1].at);
    await db.ref(`gatherings/${gid}/latest`).set(visible.length ? { id: visible[0][0], text: visible[0][1].text, at: visible[0][1].at } : null);
}

/** 交棒對象目前的狀態（給 gathering.handoffProblem 判斷） */
async function handoffCandidate(g, uid) {
    const [[nickname, hidden], pos] = await sendUpstashPipeline([
        ["HMGET", `user_data:${uid}`, "nickname", "hidden"],
        ["GEOPOS", "city_users", uid],
    ]);
    const hostingGid = (await admin.database().ref(`hosting/${uid}`).once('value')).val();
    const hostingActive = hostingGid ? ((await readGathering(hostingGid)) || {}).status === 'active' : false;
    const blocked = (await blockedUidsFor(g.hostUid)).has(uid);
    const here = Array.isArray(pos) && pos[0] ? { lng: parseFloat(pos[0][0]), lat: parseFloat(pos[0][1]) } : null;
    return { nickname, hidden, pos: here, hosting: hostingActive ? hostingGid : null, blocked };
}

/** 交棒：活動不變，只換主持人；中心改跟著新主持人。公開交棒才通知參加者。 */
async function transferHost(gid, g, toUid, quiet) {
    const db = admin.database();
    const fromUid = g.hostUid;
    const [pos] = await sendUpstashPipeline([["GEOPOS", "city_users", toUid]]);
    const center = Array.isArray(pos) && pos[0] ? gathering.publicCenter(parseFloat(pos[0][1]), parseFloat(pos[0][0])) : {};
    const now = Date.now();
    await db.ref().update({
        [`gatherings/${gid}/hostUid`]: toUid,
        ...Object.fromEntries(Object.entries(center).map(([k, v]) => [`gatherings/${gid}/${k}`, v])),
        [`gatherings/${gid}/pendingHandoff`]: null,
        ...(quiet ? {} : { [`gatherings/${gid}/handoffAt`]: now }),
        [`gatheringHandoffLog/${gid}/${now}`]: { from: fromUid, to: toUid, quiet },
        [`hosting/${fromUid}`]: null,
        [`hosting/${toUid}`]: gid,
    });
    await sendUpstashPipeline([
        ["HDEL", `user_data:${fromUid}`, "host", "hostEmoji"],
        ["HSET", `user_data:${toUid}`, "host", gid, "hostEmoji", g.emoji],
    ]);
    console.log(`[集會] ${gid} 主持人 ${fromUid} → ${toUid}${quiet ? '（安靜交棒）' : ''}`);
    await sendPush(fromUid, `${g.emoji} ${g.name}`, "對方接下了主持，你回到了城市裡。", { type: 'gathering_handoff', gid });
    if (!quiet) await notifyGathering(gid, { ...g, ...center, hostUid: toUid }, "主持人已交棒，活動繼續進行。");
}

// 時間到的活動自動結束（每 5 分鐘檢查一次）；結束滿 30 天的活動連同公告、提問與回答一併刪除（隱私權政策第 2 節）
const GATHERING_RETENTION_MS = 30 * 24 * 60 * 60 * 1000;

exports.endExpiredGatherings = onSchedule({ schedule: "every 5 minutes", region: "asia-southeast1", secrets: UPSTASH_SECRETS, timeoutSeconds: 300, memory: "512MiB" }, async () => {
    const db = admin.database();
    const active = (await db.ref('gatherings').orderByChild('status').equalTo('active').once('value')).val() || {};
    const now = Date.now();
    for (const [gid, g] of Object.entries(active)) {
        if (g.endAt <= now) {
            try { await endGathering(gid, 'expired'); } catch (e) { console.error(`[集會] ${gid} 自動結束失敗:`, e); }
        }
    }
    const ended = (await db.ref('gatherings').orderByChild('status').equalTo('ended').once('value')).val() || {};
    const updates = {};
    for (const [gid, g] of Object.entries(ended)) {
        if (now - (g.endedAt || g.endAt || 0) < GATHERING_RETENTION_MS) continue;
        for (const path of ['gatherings', 'gatheringAnnouncements', 'gatheringTally', 'gatheringAnswers', 'gatheringHandoffLog', 'gatheringReview']) updates[`${path}/${gid}`] = null;
    }
    if (Object.keys(updates).length) {
        await db.ref().update(updates);
        console.log(`[集會] 刪除 ${Object.keys(updates).length / 6} 場結束滿 30 天的活動`);
    }
});

// ============================================================================
// 今晚的台灣心情：每 15 分鐘把全台 24 小時內的心情匯總成比例，寫到 RTDB publicMood/（公開可讀）
//   latest：最新一筆；hourly/<整點時間>：每小時一筆趨勢，保留 7 天
//   只有比例，少於 10 人的區域不給比例；示範對象與被隱藏的帳號不算
// ============================================================================
const PUBLIC_MOOD_CHUNK = 1000;
const PUBLIC_MOOD_KEEP_MS = 7 * 24 * 60 * 60 * 1000;

exports.updatePublicMood = onSchedule({ schedule: "every 15 minutes", region: "asia-southeast1", secrets: UPSTASH_SECRETS, timeoutSeconds: 300, memory: "512MiB" }, async () => {
    const uids = ((await sendUpstashCommand(["ZRANGE", "city_users", "0", "-1"])) || []).filter((u) => u && !u.startsWith(demo.DEMO_PREFIX));
    const people = [];
    for (let i = 0; i < uids.length; i += PUBLIC_MOOD_CHUNK) {
        const chunk = uids.slice(i, i + PUBLIC_MOOD_CHUNK);
        const [positions, ...rows] = await sendUpstashPipeline([
            ["GEOPOS", "city_users", ...chunk],
            ...chunk.map((u) => ["HMGET", `user_data:${u}`, "mood", "timestamp", "hidden"]),
        ]);
        chunk.forEach((u, k) => {
            const pos = positions && positions[k];
            const [mood, ts, hidden] = rows[k] || [];
            if (!pos || hidden === "1") return;
            people.push({ lng: parseFloat(pos[0]), lat: parseFloat(pos[1]), mood, lastSeen: parseInt(ts || "0", 10) });
        });
    }
    const now = Date.now();
    const snapshot = publicmood.aggregate(people, now);
    const hour = Math.floor(now / 3600000) * 3600000;
    const db = admin.database();
    const updates = { "publicMood/latest": snapshot, [`publicMood/hourly/${hour}`]: publicmood.hourlyPoint(snapshot) };
    const old = (await db.ref("publicMood/hourly").orderByKey().endAt(String(now - PUBLIC_MOOD_KEEP_MS)).once("value")).val() || {};
    for (const k of Object.keys(old)) updates[`publicMood/hourly/${k}`] = null;
    await db.ref().update(updates);
    console.log(`[台灣心情] ${people.length} 人，全台 ${snapshot.taiwan.total} 人在 24 小時內出現`);
});

// ============================================================================
// API 12: 低語穿越 —— action: create / list / open / delete
//   寫給未來的自己：只有作者讀得到；一個月或一年後解封，回到 100 公尺內才能打開，讀過一次就刪除。
//   timeWhispers/{uid}/{id}：內容與精確位置（只有伺服器讀寫）
//   timeWhisperQueue/{id}：{uid, unlockAt}，解封時推播一次
// ============================================================================
exports.timeWhisper = onRequest({ region: "asia-southeast1" }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: "未授權" });
    const { action, id, lat, lng } = req.body || {};
    const db = admin.database();
    const mine = db.ref(`timeWhispers/${uid}`);
    const now = Date.now();
    const fail = (code, error) => res.status(code).json({ success: false, error });
    try {
      if (action === "create") {
        if (!isValidCoordinate(lat, lng)) return fail(400, "座標格式錯誤");
        const checked = timewhisper.validateText(req.body.text);
        if (checked.error) return fail(400, checked.error);
        const unlockAt = timewhisper.unlockAtFor(req.body.delay, now);
        if (!unlockAt) return fail(400, "請選一個月後或一年後。");
        const all = (await mine.once("value")).val() || {};
        if (Object.values(all).filter((w) => !w.openedAt).length >= timewhisper.MAX_ACTIVE) {
            return fail(429, `你已經有 ${timewhisper.MAX_ACTIVE} 封還沒打開的低語穿越了，先讀完一封再寫吧。`);
        }
        const ref = mine.push();
        await db.ref().update({
            [`timeWhispers/${uid}/${ref.key}`]: { text: checked.text, lat, lng, createdAt: now, unlockAt },
            [`timeWhisperQueue/${ref.key}`]: { uid, unlockAt },
        });
        return res.status(200).json({ success: true, data: timewhisper.forOwner(ref.key, { lat, lng, createdAt: now, unlockAt }, now) });
      }

      if (action === "list") {
        const all = (await mine.once("value")).val() || {};
        const data = Object.entries(all).map(([k, w]) => timewhisper.forOwner(k, w, now)).sort((a, b) => a.unlockAt - b.unlockAt);
        return res.status(200).json({ success: true, data });
      }

      if (action === "open") {
        const w = (await mine.child(String(id || "")).once("value")).val();
        const here = isValidCoordinate(lat, lng) ? { lat, lng } : null;
        const problem = timewhisper.openProblem(w, here, now);
        if (problem) return fail(403, problem);
        // 只讀一次：回傳內容後立刻刪除
        await db.ref().update({ [`timeWhispers/${uid}/${id}`]: null, [`timeWhisperQueue/${id}`]: null });
        return res.status(200).json({ success: true, data: timewhisper.forOwner(id, { ...w, openedAt: now }, now) });
      }

      if (action === "delete") {
        await db.ref().update({ [`timeWhispers/${uid}/${id}`]: null, [`timeWhisperQueue/${id}`]: null });
        return res.status(200).json({ success: true });
      }

      return fail(400, "未知的操作");
    } catch (error) {
      console.error(`timeWhisper ${action} failed:`, error);
      res.status(500).json({ success: false, error: "低語穿越暫時無法使用，請稍後再試。" });
    }
  });
});

// 每小時：解封的低語穿越推播給作者一次
exports.unlockTimeWhispers = onSchedule({ schedule: "every 60 minutes", region: "asia-southeast1" }, async () => {
    const db = admin.database();
    const due = (await db.ref("timeWhisperQueue").orderByChild("unlockAt").endAt(Date.now()).once("value")).val() || {};
    for (const [id, q] of Object.entries(due)) {
        try {
            const w = (await db.ref(`timeWhispers/${q.uid}/${id}`).once("value")).val();
            if (w && !w.openedAt) {
                const ago = Math.round((w.unlockAt - w.createdAt) / 86400000) >= 365 ? "一年前" : "一個月前";
                await sendPush(q.uid, "低語穿越", `${ago}的你，在某個地方留下了一句話。回到那裡，就能讀到。`, { type: "time_whisper", id });
            }
            await db.ref(`timeWhisperQueue/${id}`).remove();
        } catch (e) { console.error(`[低語穿越] ${id} 提醒失敗:`, e); }
    }
    if (Object.keys(due).length) console.log(`[低語穿越] 解封提醒 ${Object.keys(due).length} 封`);
});
