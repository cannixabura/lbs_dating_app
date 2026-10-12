const { onValueCreated, onValueWritten } = require("firebase-functions/v2/database");
const admin = require("firebase-admin");

admin.initializeApp();

const DB_REGION = "asia-southeast1";
const DB_INSTANCE = "mood-whisper-f7de9-default-rtdb";

/**
 * 🌟 觸發器 1：監聽敲門請求
 */
exports.sendKnockNotification = onValueWritten(
  {
    ref: "/requests/{targetUid}/{senderUid}",
    region: DB_REGION,
    instance: DB_INSTANCE,
  },
  async (event) => {
    const status = event.data.after.val();
    if (status !== "pending") return;

    const targetUid = event.params.targetUid;
    const senderUid = event.params.senderUid;

    try {
      const tokenSnapshot = await admin.database().ref(`/tokens/${targetUid}`).once("value");
      const targetToken = tokenSnapshot.val();

      if (!targetToken) {
        console.log(`[敲門] 用戶 ${targetUid} 查無 Token`);
        return;
      }

      const senderSnapshot = await admin.database().ref(`/users/${senderUid}/nickname`).once("value");
      const senderNickname = senderSnapshot.val() || `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;

      const payload = {
        token: targetToken,
        notification: {
          title: "城市低語 · 片刻交集",
          body: `${senderNickname} 正在敲門，想與你產生交集...`,
        },
        data: {
          type: "knock_request",
          senderUid: senderUid,
        },
        android: {
          priority: "high",
          notification: {
            channelId: "high_importance_channel",
            sound: "default",
            defaultSound: true,
            defaultVibrateTimings: true,
            priority: "high",
          },
        },
        apns: {
          headers: {
            "apns-priority": "10",
          },
          payload: {
            aps: {
              alert: {
                title: "城市低語 · 片刻交集",
                body: `${senderNickname} 正在敲門，想與你產生交集...`,
              },
              sound: "default",
              badge: 1,
              contentAvailable: true,
            },
          },
        },
      };

      const res = await admin.messaging().send(payload);
      console.log(`[敲門] 推播已送出至 ${targetUid}, ID: ${res}`);
    } catch (error) {
      console.error("[敲門] 發送通知失敗:", error);
    }
  }
);

/**
 * 🌟 觸發器 2：監聽聊天室新訊息
 */
exports.sendChatMessageNotification = onValueCreated(
  {
    ref: "/chats/{roomId}/messages/{messageId}",
    region: DB_REGION,
    instance: DB_INSTANCE,
  },
  async (event) => {
    const msgData = event.data.val();
    if (!msgData || !msgData.sender || !msgData.text) return;

    const roomId = event.params.roomId;
    const senderUid = msgData.sender;

    // 解析接收者 UID
    let recipientUid = "";
    if (roomId.startsWith(senderUid + "_")) {
      recipientUid = roomId.substring(senderUid.length + 1);
    } else if (roomId.endsWith("_" + senderUid)) {
      recipientUid = roomId.substring(0, roomId.length - (senderUid.length + 1));
    }

    if (!recipientUid) {
      console.log(`[聊天] 無法從 roomId (${roomId}) 解析接收者 UID`);
      return;
    }

    try {
      const tokenSnapshot = await admin.database().ref(`/tokens/${recipientUid}`).once("value");
      const recipientToken = tokenSnapshot.val();

      if (!recipientToken) {
        console.log(`[聊天] 接收者 ${recipientUid} 查無 Token`);
        return;
      }

      const senderSnapshot = await admin.database().ref(`/users/${senderUid}/nickname`).once("value");
      const senderNickname = senderSnapshot.val() || `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;

      const payload = {
        token: recipientToken,
        notification: {
          title: `來自 ${senderNickname} 的低語`,
          body: msgData.text,
        },
        data: {
          type: "chat_message",
          roomId: roomId,
          senderUid: senderUid,
        },
        android: {
          priority: "high",
          notification: {
            channelId: "high_importance_channel",
            sound: "default",
            defaultSound: true,
            defaultVibrateTimings: true,
            priority: "high",
          },
        },
        apns: {
          headers: {
            "apns-priority": "10",
          },
          payload: {
            aps: {
              alert: {
                title: `來自 ${senderNickname} 的低語`,
                body: msgData.text,
              },
              sound: "default",
              badge: 1,
              contentAvailable: true,
            },
          },
        },
      };

      const res = await admin.messaging().send(payload);
      console.log(`[聊天] 推播已送出至 ${recipientUid}, ID: ${res}`);
    } catch (error) {
      console.error("[聊天] 發送通知失敗:", error);
    }
  }
);