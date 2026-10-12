const { onRequest } = require("firebase-functions/v2/https");
const functionsV1 = require("firebase-functions/v1");
const admin = require("firebase-admin");
const cors = require("cors")({ origin: true });

if (!admin.apps.length) admin.initializeApp();

// ⚠️ 務必填入你的 Upstash 憑證
const UPSTASH_URL = 'https://***REMOVED***.upstash.io'; 
const UPSTASH_TOKEN = '***REMOVED***';

async function sendUpstashCommand(commandArray) {
    const response = await fetch(UPSTASH_URL, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${UPSTASH_TOKEN}`, 'Content-Type': 'application/json' },
        body: JSON.stringify(commandArray)
    });
    if (!response.ok) throw new Error(`Upstash API Error: ${response.status}`);
    const data = await response.json();
    if (data.error) throw new Error(`Redis Error: ${data.error}`);
    return data.result;
}

// ============================================================================
// API 1: 更新座標 (🌟 核心修正：自動將暱稱備份至 Firebase /profiles)
// ============================================================================
exports.updateLocation = onRequest({ region: "asia-southeast1" }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const { uid, lat, lng, mood, nickname, timestamp } = req.body;
    try {
      await sendUpstashCommand(["GEOADD", "city_users", lng.toString(), lat.toString(), String(uid)]);
      await sendUpstashCommand([
          "HSET", `user_data:${uid}`, "mood", mood || "", "nickname", nickname || "", 
          "timestamp", timestamp.toString(), "lat", lat.toString(), "lng", lng.toString()
      ]);
      
      // 🌟 無論手機 App 是新是舊，只要更新定位，就把暱稱備份到 Firebase！
      if (nickname && nickname.trim() !== '') {
          await admin.database().ref(`/profiles/${uid}/nickname`).set(nickname);
      }
      
      res.status(200).json({ success: true, message: "更新成功" });
    } catch (error) { res.status(500).json({ success: false, error: "更新失敗" }); }
  });
});

exports.getNearby = onRequest({ region: "asia-southeast1" }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const { lat, lng, radiusKM = 5 } = req.body; 
    try {
      const nearbyUids = await sendUpstashCommand(["GEORADIUS", "city_users", lng.toString(), lat.toString(), radiusKM.toString(), "km"]);
      const results = [];
      if (Array.isArray(nearbyUids)) {
        for (const memberUid of nearbyUids) {
          if (!memberUid) continue;
          const userDataArray = await sendUpstashCommand(["HGETALL", `user_data:${memberUid}`]);
          if (Array.isArray(userDataArray) && userDataArray.length > 0) {
              const userData = {};
              for (let i = 0; i < userDataArray.length; i += 2) userData[userDataArray[i]] = userDataArray[i+1];
              if (userData.lat && userData.lng) {
                  results.push({ uid: memberUid, lng: parseFloat(userData.lng), lat: parseFloat(userData.lat), mood: userData.mood || "", nickname: userData.nickname || "", timestamp: parseInt(userData.timestamp || "0", 10) });
              }
          }
        }
      }
      res.status(200).json({ success: true, data: results });
    } catch (error) { res.status(500).json({ success: false, error: "掃描失敗" }); }
  });
});

// ============================================================================
// API 3: 敲門推播通知 
// ============================================================================
exports.notifyOnKnock = functionsV1.region('asia-southeast1').database.ref('/requests/{targetUid}/{senderUid}')
  .onWrite(async (change, context) => {
    const data = change.after.val(); const beforeData = change.before.val();
    if (!data || data.status !== 'pending') return null;
    if (beforeData && beforeData.status === 'pending') return null;

    const targetUid = context.params.targetUid; const senderUid = context.params.senderUid;
    
    let senderName = data.nickname;
    if (!senderName || senderName.trim() === '' || senderName.startsWith('#')) {
        const profileSnap = await admin.database().ref(`/profiles/${senderUid}/nickname`).once('value');
        if (profileSnap.exists()) senderName = profileSnap.val();
    }
    if (!senderName || senderName.trim() === '') senderName = `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;

    const tokenSnap = await admin.database().ref(`/tokens/${targetUid}`).once('value');
    const token = tokenSnap.val(); if (!token) return null;
    try { await admin.messaging().send({ notification: { title: '片刻交集', body: `${senderName} 正在敲門，想與你產生交集...` }, token: token }); } catch (error) { }
    return null;
  });

// ============================================================================
// API 4: 聊天推播通知 
// ============================================================================
exports.notifyOnChat = functionsV1.region('asia-southeast1').database.ref('/chats/{roomId}/messages/{msgId}')
  .onCreate(async (snapshot, context) => {
    const msg = snapshot.val(); if (!msg) return null;
    const senderUid = msg.sender;
    const targetUid = context.params.roomId.split('_').find(id => id !== senderUid);
    if (!targetUid) return null;

    // 🌟 1. 第一防線：檢查訊息本身有沒有夾帶名字 (針對新版 App)
    let senderName = msg.senderName;
    
    // 🌟 2. 第二防線：如果是舊手機發送的 (沒夾帶名字)，去剛才的備份金庫找！
    if (!senderName || senderName.trim() === '' || senderName.startsWith('#')) {
        const profileSnap = await admin.database().ref(`/profiles/${senderUid}/nickname`).once('value');
        if (profileSnap.exists()) senderName = profileSnap.val();
    }
    
    // 🌟 3. 最後防線：真的都沒有才給代號
    if (!senderName || senderName.trim() === '') {
        senderName = `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;
    }

    const tokenSnap = await admin.database().ref(`/tokens/${targetUid}`).once('value');
    const token = tokenSnap.val(); if (!token) return null;
    try { await admin.messaging().send({ notification: { title: `來自 ${senderName} 的低語`, body: msg.text }, token: token }); } catch (error) { }
    return null;
  });