const functions = require("firebase-functions");
const cors = require("cors")({ origin: true });

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

exports.updateLocation = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    
    // 🌟 修正：確實從 App 接收 nickname 欄位
    const { uid, lat, lng, mood, nickname, timestamp } = req.body;
    
    try {
      await sendUpstashCommand(["GEOADD", "city_users", lng.toString(), lat.toString(), String(uid)]);
      
      // 🌟 修正：將 nickname 加入 Redis 的詳細資料儲存指令中
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
                      nickname: userData.nickname || "", // 🌟 修正：確保將暱稱打包回傳給 App
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