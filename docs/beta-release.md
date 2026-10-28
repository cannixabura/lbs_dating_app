# 公測發布步驟（目標：週五 10/30 21:00 第一場點亮之夜；10/31 臺灣同志遊行）

版本：`1.0.2 (8)` 已於 10/28 上傳 App Store 與 Google Play；下一次上傳用 `1.0.2 (9)`（8 頁新導覽）（集會、平行宇宙、翻譯、每次手動打卡；條款版本 2026-10.8，iOS 18 以上）。檔案：
- iOS：`build/ios/archive/Runner.xcarchive`（用 Xcode Organizer 上傳，見 A2）
- Android：`build/app/outputs/bundle/release/app-release.aab`

## 時程
| 日期 | 要做的事 |
|---|---|
| **週二 10/27 前** | 上傳 `1.0.2 (8)`，iOS 與 Android 都送審（外部測試／封閉測試） |
| 週二–週三 | 等審核；同時發社群貼文招募，請大家先到報名頁登記 |
| **週四 10/29** | 審核通過 → 匯出報名名單、寄邀請、在 LINE 社群發安裝連結 |
| 週四晚上 | 若審核還沒過：改用「內部測試」先邀核心成員（下方 Plan B） |
| **週五 10/30 21:00** | 第一場點亮之夜 |
| **週六 10/31** | 臺灣同志遊行：可用 🌈 開集會 |

---

## A. Apple：TestFlight

### A1. 建立 App（只需做一次）
App Store Connect（ccabura@icloud.com）→「App」→「＋」→「新增 App」
- 平台：iOS｜名稱：城市低語｜主要語言：繁體中文（台灣）
- 套件 ID：`com.softchip.moodwhisper`｜SKU：`moodwhisper`
- 若下拉選單沒有這個套件 ID：先到 developer.apple.com →「Identifiers」新增同名 App ID

### A2. 上傳建置版本（第一次用 Xcode）
這台 Mac 還沒有「iOS Distribution」憑證，所以第一次要用 Xcode 上傳，Xcode 會自動建立憑證與包含推播的描述檔：
1. Xcode › Settings › Accounts：確認已登入 ccabura@icloud.com（團隊 JCFN9LMAXF）
2. 打開封存檔：`open build/ios/archive/Runner.xcarchive`（會開啟 Organizer）
3. 選 `Runner 1.0.2 (8)` → **Distribute App** → **App Store Connect** → **Upload**
4. 簽署選「**Automatically manage signing**」→ 一路「Next」→「Upload」

之後的版本就能直接用 `flutter build ipa` 產生 `.ipa`，再用 Transporter 上傳。

上傳後約 10–30 分鐘，App Store Connect →「TestFlight」會出現 `1.0.2 (8)`。若顯示「缺少出口合規資訊」，選「否，不使用加密」（Info.plist 已宣告）。

### A3. 內部測試（立刻可用，不需審核，最多 100 人）
TestFlight →「內部測試」→ 新增群組「核心成員」→ 加入你的帳號與核心成員（他們要先被加為 App Store Connect 使用者）。

### A4. 外部測試（需要 Beta 版審核，通常 1–2 天）
TestFlight →「外部測試」→ 新增群組「公測」→ 加入建置版本 `1.0.2 (8)` → 填寫：
- **測試資訊 › 測試內容**（貼下面「What to Test」）
- **Beta 版 App 審核資訊**：聯絡人、電話、service.softchip@gmail.com；「需要登入」**不勾**；備註貼 `docs/store-submission.md` 的英文審核備註（含 `#review`）
- 送出審核 → 通過後開啟「**公開連結**」，把連結貼到 LINE 社群與 Email

**What to Test（測試內容，貼到 TestFlight）**
```
歡迎參加城市低語公測！🌙
這次想請你試試：
1. 寫下心情，按「在這裡打卡，走進城市」，看看雷達上附近的心情氣泡（每次打開都要自己打卡，別人才看得到你）
2. 長按別人的氣泡「敲門」，對方同意後聊 10 分鐘
3. 雙擊氣泡送出「微光」，或從底部選單留一則「低語」
4. 點雷達右上角的地球，打開「平行宇宙」，看看東京、首爾、吉隆坡此刻的心情
5. 點一下外語的訊息或心情氣泡，就會翻成你的語言（iPhone 需要 iOS 18 以上）
6. 遇到不舒服的內容試試檢舉與封鎖
每週五 21:00–23:00 是點亮之夜，大家一起上線最好玩。
有任何問題，在 LINE 社群或寫信到 service.softchip@gmail.com 告訴我們。
```

---

## B. Google Play：封閉測試

### B1. 建立應用程式（只需做一次）
Play Console（cannixmusic@gmail.com）→「建立應用程式」
- 名稱：城市低語｜預設語言：中文（台灣）｜應用程式｜免費
- 勾選開發人員計畫政策與美國出口法聲明

### B2. 應用程式內容（**封閉測試也必須先完成**）
照 `docs/submission-checklist.md` 的 D1 逐項填寫：隱私權政策、應用程式存取權（貼英文審核說明）、廣告（否）、內容分級、目標對象（18+）、資料安全性、刪除帳號網址。

### B3. 商店資訊（封閉測試也要）
簡短說明、完整說明、圖示 512×512、主題圖片 `store_screenshots/android/feature_graphic.png`、手機截圖 `store_screenshots/android/1–5.png`。

### B4. 內部測試（立刻可用，最多 100 人）
「測試」›「內部測試」→ 建立版本 → 上傳 `app-release.aab` → 版本名稱 `1.0.2 (8)` → 測試人員加入 Email 清單 → 推出。通常幾分鐘內就能安裝。

### B5. 封閉測試（需要審核，新 App 可能要幾天）
「測試」›「封閉測試」→ 建立測試群組「公測」：
- **測試人員**：建議建立 Google 群組（例如 `moodwhisper-beta@googlegroups.com`），把報名者加進群組，Play Console 只要填這個群組
- 上傳同一個 `.aab`（或從內部測試「升級」）→ 送審
- 通過後複製「**加入測試的網址**」，貼到 LINE 社群與 Email

**新的個人開發者帳號**：要申請正式上架，必須有 **12 位以上測試者連續參與封閉測試 14 天**。這次公測正好可以累積，請確保至少 12 人加入並持續開啟。

---

## C. 通知報名者（審核通過後）
```bash
python3 tool/export_beta_signups.py
```
- `ios_emails.txt` → TestFlight 外部群組「新增測試人員」貼上（TestFlight 會自動寄邀請信）
- `android_emails.txt` → 加進 Google 群組
- LINE 社群貼「安裝連結公告」（`marketing/line-community.md`）

## Plan B（週四晚上審核還沒過）
- iOS：把核心成員加到 TestFlight **內部測試**
- Android：把核心成員加到 Play **內部測試**
- 點亮之夜照常舉行，其他人等審核通過再加入
