# 城市低語 上架填寫指南

依照目前程式碼實際蒐集的資料整理（2026-10，App 1.0.2 (9)，條款版本 2026-10.8；位置模糊化目前關閉，見 geo-service/index.js 的 FUZZ_LOCATION）。

**位置一律手動打卡（App Store 5.1.2(i)）**：每次打開 App 都要按「在這裡打卡，走進城市」，別人才看得到你；看到的是打卡的地方，不會跟著移動；App 在背景超過 30 分鐘要重新打卡。沒有自動打卡的選項。**不放任何測試版功能（App Store 2.2）**：App 裡不能有「測試版、內部測試、Beta」等字樣或回報測試問題的功能。功能有變動時，這份要跟著更新。

## 網址

| 欄位 | 網址 |
| --- | --- |
| 隱私權政策（Apple、Google 必填） | https://mood-whisper-f7de9.web.app/privacy.html |
| 使用條款 / EULA（Apple 可填在「授權協議」） | https://mood-whisper-f7de9.web.app/terms.html |
| 刪除帳號網址（Google Play 必填） | https://mood-whisper-f7de9.web.app/delete-account.html |
| 支援信箱 | service.softchip@gmail.com |
| 行銷網站 / 落地頁（心情卡與邀請連結指向這裡） | https://mood-whisper-f7de9.web.app/ |

## Apple：App 隱私權（App Store Connect → App 隱私權）

「是否蒐集資料」：**是**。「是否用於追蹤」：全部**否**（沒有廣告、沒有分析 SDK、沒有跨 App 追蹤）。

| Apple 資料類型 | 蒐集內容 | 與使用者身分連結 | 用途 |
| --- | --- | --- | --- |
| 位置 → 精確位置 | 使用 App 時的 GPS 位置（查詢附近的人）；打卡時的位置（顯示給附近的人） | 是 | App 功能 |
| 使用者內容 → 照片或影片 | 大頭貼（選填） | 是 | App 功能 |
| 使用者內容 → 其他使用者內容 | 心情、城市稱呼 | 是 | App 功能 |
| 使用者內容 → 電子郵件或文字訊息 | 限時聊天訊息（對話結束即刪除） | 是 | App 功能 |
| 使用者內容 → 客服 | 檢舉內容 | 是 | App 功能 |
| 識別碼 → 使用者 ID | 匿名帳號 ID | 是 | App 功能 |
| 識別碼 → 裝置 ID | 推播通知權杖 | 是 | App 功能 |

不要勾選：聯絡資訊、健康、財務、瀏覽紀錄、搜尋紀錄、購買項目、使用狀況資料、診斷資料。

## Google Play：資料安全性（Play Console → 應用程式內容 → 資料安全性）

- 是否蒐集或分享必要的使用者資料類型：**是**
- 所有資料在傳輸時是否加密：**是**
- 是否提供使用者要求刪除資料的方式：**是**（App 內＋上方刪除帳號網址）
- 「分享」：**否**。Firebase、Upstash、OpenFreeMap 是代你處理資料的服務供應商，依 Google 的定義不算分享；讓附近的人看到你的心情是使用者自己發起的功能，也不算分享。

| Google 資料類型 | 蒐集 | 必要 / 選填 | 用途 |
| --- | --- | --- | --- |
| 位置 → 精確位置 | 是 | 必要 | 應用程式功能 |
| 個人資訊 → 使用者 ID | 是 | 必要 | 應用程式功能、帳戶管理 |
| 個人資訊 → 其他資訊（城市稱呼、心情） | 是 | 必要（心情）/ 選填（稱呼） | 應用程式功能 |
| 相片和影片 → 相片 | 是 | 選填 | 應用程式功能 |
| 訊息 → 其他應用程式內訊息 | 是 | 選填 | 應用程式功能 |
| 裝置或其他 ID | 是 | 必要 | 應用程式功能 |

所有項目的「是否為暫時性處理」：**否**（聊天訊息雖然對話結束就刪除，但會經過伺服器儲存一段時間）。

## 年齡分級

本服務僅限 18 歲以上（使用條款第 1 條、進場勾選「我已年滿 18 歲」）。

**Apple（年齡分級問卷）**
- 使用者產生的內容、使用者之間的訊息與聊天：**有**
- 位置分享給其他使用者：**有**（雷達上的位置與分級距離）
- 不受限制的網頁存取：**無**（App 只開啟自己的條款網頁）
- 預期結果：**18+**。若問卷給出較低分級，在「年齡分級覆寫」選 18+，與條款一致。

**Google Play（IARC 問卷＋目標對象）**
- 類別：社交
- 使用者可以互動或交換內容：**是**
- 會與其他使用者分享使用者的位置：**是**
- 目標對象與內容：只勾選 **18 歲以上**
- 是否為約會應用程式：依你的定位決定。若勾選「是」，Google 會要求額外的安全聲明。

## 提交審核時的備註（兩個平台都要填）

審核人員只有一支手機、通常在美國，雷達上不會有真人，所以 App 內建「審核示範」：在心情欄輸入通關碼 `#review`，伺服器會在審核人員所在位置周圍放 20 位示範對象（距離 200 公尺、400 公尺……到 4 公里），只有輸入過通關碼的帳號看得到。示範對象會自動同意敲門、在聊天室自動回覆說明、收到微光會回送一道，也可以被檢舉與封鎖。

台北市中心另有 200 位「示範」導覽員給一般使用者體驗，名字前一律標示「示範」，長按選單與聊天室都會說明「由程式自動回應，不是真人」。

**App Review 備註（英文，貼到 App Store Connect →「App 審核資訊」→「備註」）**

```
Mood Whisper (城市低語) is an anonymous, location-based app for adults (18+). No account or password is needed: entering the app signs in anonymously.

Because the radar only shows people within 5 km, we added a review mode so you can test every social feature alone:
1. Swipe through or skip (略過) the intro, answer the age question with 已滿 18 歲 (I am 18 or older), and allow precise location while using the app.
2. Type #review in the mood field (此時此刻，你想對城市說什麼？), tick the terms box, and tap 在這裡打卡，走進城市 (Check in here and enter). This is the manual check-in: your location is shown to others only after this tap, every time you open the app.
3. 20 demo people appear around your location, 200 m apart. They are labelled 示範 (demo) and are only visible to accounts that entered the code. Pinch to zoom; overlapping bubbles merge into a glowing orb — tap it to fan them out.
4. Knock: long-press a bubble → 敲門. The demo person accepts in about 3 seconds and a 10-minute chat opens; it replies automatically.
5. Report: chat header flag icon, the bubble long-press menu (檢舉), or the knock card. Block: bubble long-press menu → 封鎖.
6. Glimmer (resonance): double-tap a bubble; the demo person sends one back.
7. Gatherings: Settings (sliders icon, bottom right) → 集會主持人 creates a 5 km event identified by one emoji. People who add that emoji to their name receive the host's announcements; every announcement has a report button.
8. Guide: Settings → 操作說明. Delete account: Settings → 刪除帳號與資料 at the bottom.
9. Parallel Universe: the globe at the top right of the radar (off every time the app opens). Translation: tap a chat message or a mood bubble in another language.

Location (Guideline 5.1.2(i)):
- Users check in manually every time they want their location shown on the map: the button 在這裡打卡，走進城市 (Check in here and enter) on the entry screen, which also explains that people nearby will see their mood and approximate location.
- There is no automatic check-in and no setting to enable one. Others see the place where the user checked in; it does not update as they move. If they move more than 1 km away, a 在這裡重新打卡 (Check in here) button appears, and nothing changes until they tap it. After 30 minutes in the background the check-in expires and must be repeated.
- Before checking in, the user is not visible to anyone and does not see anyone either.

User-generated content (Guideline 1.2):
- Age rating 18+. Users confirm they are 18+ and must accept the terms (EULA) before entering; the terms state zero tolerance for objectionable content and abusive users, with an English summary at the top: https://mood-whisper-f7de9.web.app/terms.html
- Filtering: moods, nicknames, whispers, chat messages and gathering announcements are filtered for objectionable words and contact details (on the device and again on the server).
- Flag: every bubble, knock, chat, whisper and gathering announcement has a report button.
- Block: bubble long-press menu → 封鎖, or the report sheet.
- Immediate removal: once a report is sent, that person or post disappears from the reporter's screen at once, and a reported chat ends immediately.
- 24-hour action: reported users or whispers are hidden for everyone after 3 reports; we review every report within 24 hours, remove the content and eject the user.
- Contact: Settings → 聯絡我們 (service.softchip@gmail.com).
```

**Google Play（Play Console →「應用程式內容」→「應用程式存取權」）**
選「部分功能受限」，說明欄貼上同一段英文說明（不需要帳號密碼）。
