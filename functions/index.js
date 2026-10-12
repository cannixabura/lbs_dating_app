const { onValueWritten } = require("firebase-functions/v2/database");
const { setGlobalOptions } = require("firebase-functions/v2");
const admin = require("firebase-admin");

admin.initializeApp();

setGlobalOptions({ region: "asia-southeast1" });

exports.sendKnockNotification = onValueWritten(
    "/requests/{targetUid}/{senderUid}",
    async (event) => {
        const status = event.data.after.val();

        if (status !== 'pending') {
            return null;
        }

        const targetUid = event.params.targetUid;

        try {
            const tokenSnapshot = await admin.database().ref(`/tokens/${targetUid}`).once('value');
            const token = tokenSnapshot.val();

            if (!token) return null;

            // 🌟 核心修正：升級推播包裹，強制加入雙平台的預設聲音提示
            const message = {
                notification: {
                    title: '片刻交集',
                    body: '有人正在敲門，想與你產生交集...',
                },
                // 針對 Android 的設定
                android: {
                    notification: {
                        sound: 'default', // 強制開啟聲音
                    }
                },
                // 針對 iOS (APNs) 的設定
                apns: {
                    payload: {
                        aps: {
                            sound: 'default', // 強制開啟聲音
                            badge: 1          // 可以在 App 圖示右上角顯示紅點數字
                        }
                    }
                },
                token: token
            };

            const response = await admin.messaging().send(message);
            console.log('推播發送成功！', response);
            return null;

        } catch (error) {
            console.error('推播發送失敗：', error);
            return null;
        }
    }
);