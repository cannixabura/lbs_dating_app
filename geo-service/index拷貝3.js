const functions = require("firebase-functions/v1"); // 🌟 核心修正：明確宣告使用 v1 版本的 API
const admin = require("firebase-admin");
const cors = require("cors")({ origin: true });

// 初始化 Firebase Admin
admin.initializeApp();

const UPSTASH_URL = 'https://***REMOVED***.upstash.io'; 
const UPSTASH_TOKEN = '***REMOVED***';

async function sendUpstashCommand(commandArray) {
    const response = await fetch(UPSTASH_URL, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${UPSTASH_TOKEN}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(commandArray)
    });
    
    if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Upstash API Error: ${response.status} - ${errorText}`);
    }
    const data = await response.json();
    if (data.error) {
        throw new Error(`Redis Error: ${data.error}`);
    }
    return data.result;
}

// ============================================================================
// API 1: 更新用戶座標與狀態
// ============================================================================
exports.updateLocation = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const { uid, lat, lng, mood, nickname, timestamp } = req.body;
    
    try {
      await sendUpstashCommand(["GEOADD", "city_users", lng.toString(), lat.toString(), String(uid)]);
      await sendUpstashCommand([
          "HSET", `user_data:${uid}`, 
          "mood", mood || "", 
          "nickname", nickname || "", 
          "timestamp", timestamp.toString(), 
          "lat", lat.toString(), 
          "lng", lng.toString()
      ]);
      res.status(200).json({ success: true, message: "城市已感知你的存在" });
    } catch (error) {
      console.error("更新座標失敗:", error);
      res.status(500).json({ success: false, error: "感知失敗", details: error.toString() });
    }
  });
});

// ============================================================================
// API 2: 掃描附近的使用者與歷史殘影
// ============================================================================
exports.getNearby = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const { lat, lng, radiusKM = 5 } = req.body; 
    
    try {
      const nearbyUids = await sendUpstashCommand([
          "GEORADIUS", "city_users", 
          lng.toString(), lat.toString(), 
          radiusKM.toString(), "km"
      ]);

      const results = [];
      if (Array.isArray(nearbyUids)) {
        for (const memberUid of nearbyUids) {
          if (!memberUid) continue;
          const userDataArray = await sendUpstashCommand(["HGETALL", `user_data:${memberUid}`]);
          
          if (Array.isArray(userDataArray) && userDataArray.length > 0) {
              const userData = {};
              for (let i = 0; i < userDataArray.length; i += 2) {
                  userData[userDataArray[i]] = userDataArray[i+1];
              }
              if (userData.lat && userData.lng) {
                  results.push({
                      uid: memberUid,
                      lng: parseFloat(userData.lng),
                      lat: parseFloat(userData.lat),
                      mood: userData.mood || "",
                      nickname: userData.nickname || "",
                      timestamp: parseInt(userData.timestamp || "0", 10)
                  });
              }
          }
        }
      }
      res.status(200).json({ success: true, data: results });
    } catch (error) {
      console.error("掃描城市失敗:", error);
      res.status(500).json({ success: false, error: "掃描失敗", details: error.toString() });
    }
  });
});

// ============================================================================
// API 3: 敲門推播通知 (解決背景收不到通知的問題)
// ============================================================================
exports.notifyOnKnock = functions.database.ref('/requests/{targetUid}/{senderUid}')
  .onWrite(async (change, context) => {
    const data = change.after.val();
    const beforeData = change.before.val();
    
    if (!data || data.status !== 'pending') return null;
    if (beforeData && beforeData.status === 'pending') return null;

    const targetUid = context.params.targetUid;
    const senderUid = context.params.senderUid;

    const senderName = data.nickname || `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;

    const tokenSnap = await admin.database().ref(`/tokens/${targetUid}`).once('value');
    const token = tokenSnap.val();
    if (!token) return null;

    const message = {
        notification: {
            title: '片刻交集',
            body: `${senderName} 正在敲門，想與你產生交集...`
        },
        token: token
    };

    try {
        await admin.messaging().send(message);
    } catch (error) {
        console.error('Knock Push Error:', error);
    }
    return null;
  });

// ============================================================================
// API 4: 聊天室訊息推播通知 (解決通知只顯示 #xxxx 的問題)
// ============================================================================
exports.notifyOnChat = functions.database.ref('/chats/{roomId}/messages/{msgId}')
  .onCreate(async (snapshot, context) => {
    const msg = snapshot.val();
    if (!msg) return null;

    const senderUid = msg.sender;
    const roomId = context.params.roomId;

    const uids = roomId.split('_');
    const targetUid = uids.find(id => id !== senderUid);
    if (!targetUid) return null;

    const profileSnap = await admin.database().ref(`/profiles/${senderUid}/nickname`).once('value');
    const nickname = profileSnap.val();
    const senderName = (nickname && nickname.trim() !== '') ? nickname : `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;

    const tokenSnap = await admin.database().ref(`/tokens/${targetUid}`).once('value');
    const token = tokenSnap.val();
    if (!token) return null;

    const message = {
        notification: {
            title: `收到 ${senderName} 的訊息`,
            body: msg.text
        },
        token: token
    };

    try {
        await admin.messaging().send(message);
    } catch (error) {
        console.error('Chat Push Error:', error);
    }
    return null;
  });