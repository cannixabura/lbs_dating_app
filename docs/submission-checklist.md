# 城市低語 送審清單

照順序做，每完成一項就打勾。各欄位要填的內容在 [store-submission.md](store-submission.md)；這份只列步驟。

目前版本：`pubspec.yaml` 的 `version: 1.0.2+9`（1.0.2 (8) 已於 10/28 上傳；+9 是下一次上傳）（1.0.2 是對外版號，+8 是建置號，每次上傳都要加 1）。iOS 最低版本 18（Apple 翻譯需要）。

---

## A. 送審前一天：伺服器與資料

- [ ] 確認 Cloud Functions 都在 Node 22：`firebase functions:list --project mood-whisper-f7de9`
- [ ] 示範對象都在：執行 `node tool/seed_demo_bots.js`（會顯示「已建立 200 位台北示範對象…與 20 位審核示範對象」，可重複執行）
- [ ] 用模擬器把位置設在加州（37.3349, -122.0090），心情輸入 `#review`，確認雷達上出現 20 位「示範對象」，敲門會自動同意、聊天會回覆
  - 測完到設定刪除這個帳號，避免留下審核模式的帳號
- [ ] 打開這三個網址，確認都正常顯示：
  - https://mood-whisper-f7de9.web.app/privacy.html
  - https://mood-whisper-f7de9.web.app/terms.html
  - https://mood-whisper-f7de9.web.app/delete-account.html
- [ ] 清掉測試期間留下的帳號與資料（Firebase Console → Authentication / Realtime Database），只留示範對象

## B. 建置

- [ ] `pubspec.yaml` 的建置號加 1（例如 `1.0.0+2`），commit
- [ ] `flutter test` 全部通過、`flutter analyze lib` 沒有 error
- [ ] **iOS**：`flutter build ipa --release`，產出 `build/ios/ipa/*.ipa`
- [ ] **Android**：`flutter build appbundle --release`，產出 `build/app/outputs/bundle/release/app-release.aab`
  - 簽章用 `android/key.properties` 與 `android/app/upload-keystore.jks`（兩個都不在 git 裡，**請另外備份**；遺失就無法再更新這個 App）
- [ ] 兩支實機各裝一次 release 版，完整走一遍：進場 → 雷達 → 敲門 → 聊天 → 檢舉 → 封鎖 → 低語 → 刪除帳號

## C. Apple App Store

### C1. 上傳
- [ ] 用 Xcode Organizer 或 Transporter 上傳 `.ipa`
- [ ] 等 App Store Connect 處理完成（約 10–30 分鐘），留意 Apple 寄來的信
  - 若收到 **ITMS-91053（缺少隱私權清單 / Required Reason API）**：需要在 `ios/Runner` 加 `PrivacyInfo.xcprivacy`，告訴我，我來加

### C2. App 資訊（App Store Connect → App 資訊）
- [ ] 名稱：城市低語；副標題（30 字內）
- [ ] 類別：社交
- [ ] 年齡分級問卷 → 依 store-submission.md「年齡分級」填，結果應為 **18+**
- [ ] 隱私權政策網址
- [ ] App 隱私權 → 依 store-submission.md「Apple：App 隱私權」逐項勾選

### C3. 版本頁（1.0 準備提交）
- [ ] 截圖：上傳 `store_screenshots/ios/1.png`～`5.png`（6.9 吋欄位；較小尺寸 Apple 會自動縮放）
- [ ] 推廣文字、描述、關鍵字、支援網址（可用落地頁 https://mood-whisper-f7de9.web.app/）
- [ ] 選擇剛剛上傳的建置版本
- [ ] **App 審核資訊**：
  - 「需要登入」：**不勾**（匿名登入，不需要帳號密碼）
  - 備註：貼上 store-submission.md 裡的英文審核備註（含 `#review` 通關碼與步驟）
  - 聯絡資訊：你的姓名、電話、service.softchip@gmail.com
- [ ] 版本發佈：建議選「手動發佈此版本」，審核通過後自己按發佈
- [ ] 按「提交以供審核」

## D. Google Play

### D1. 應用程式內容（Play Console → 政策 → 應用程式內容），全部要先完成
- [ ] 隱私權政策網址
- [ ] 應用程式存取權 → 「部分功能受限」，貼上同一段英文審核說明（不需要帳號密碼）
- [ ] 廣告：**否**
- [ ] 內容分級（IARC 問卷）→ 依 store-submission.md 填
- [ ] 目標對象：只勾 **18 歲以上**
- [ ] 資料安全性 → 依 store-submission.md「Google Play：資料安全性」
- [ ] 刪除帳號網址：https://mood-whisper-f7de9.web.app/delete-account.html
- [ ] 政府應用程式、金融功能、健康：都選否
- [ ] 前景服務權限說明（若 Play Console 要求）：App 只在使用中取得位置，不使用背景定位

### D2. 商店資訊
- [ ] 應用程式名稱、簡短說明（80 字內）、完整說明
- [ ] 圖示 512×512（用 `assets/images/app_icon.png` 縮成 512）
- [ ] 主題圖片 1024×500：上傳 `store_screenshots/android/feature_graphic.png`（用 `tool/make_feature_graphic.py` 產生）
- [ ] 手機截圖：上傳 `store_screenshots/android/1.png`～`5.png`

### D3. 發布
- [ ] **新的個人開發者帳號**：Google 要求先跑**封閉測試**，至少 **12 位測試者連續 14 天**，才能申請正式版。先建立「封閉測試」軌道、上傳 `.aab`、邀請測試者
- [ ] 若是機構帳號或舊帳號：直接建立「正式版」發布、上傳 `.aab`、送審

## E. 審核期間

- [ ] 每天看一次 App Store Connect 與 Play Console 的訊息
- [ ] 被退件時，把退件原文貼給我，我們一起改；常見原因與對策：
  - **1.2 使用者產生內容**：指出檢舉入口（氣泡長按、敲門卡、聊天室右上角、低語）、封鎖、24 小時處理、3 次檢舉自動隱藏
  - **2.1 無法測試功能**：再次說明 `#review` 通關碼，必要時錄一段操作影片附上
  - **5.1.1(v) 刪除帳號**：設定最下方「刪除帳號與資料」
  - **5.1.2(i) 位置分享**：每次都要手動打卡才顯示位置、沒有自動打卡（見 docs/app-review-1.0.2-reply.md）
  - **2.2 測試版功能**：App 內不能出現「測試版／內部測試／Beta」字樣或測試用功能
  - **4.3 / 5.6 假帳號疑慮**：說明示範對象一律標示「示範」、說明「由程式自動回應，不是真人」，且不計入任何統計

## F. 上架後

- [ ] 用一般帳號（不輸入通關碼）確認雷達上看不到審核示範對象
- [ ] 真人變多之後，評估逐步減少台北示範導覽員（`tool/seed_demo_bots.js --remove` 可全部移除）
- [ ] 補拍一張「城市心情天氣」比例圖，替換截圖 ⑤（目前用心情卡）
