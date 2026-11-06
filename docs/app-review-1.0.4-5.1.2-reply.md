# 回覆 App Review：Guideline 5.1.2(i)（2026-11-05 退件，送審 1.0.4 (16)）

## 這次真正改的地方（build 17）

1. **量子世界的席位不再跟著走路移動**：以前進入量子世界後，App 會一直送出走路的位移，氣泡跟著人移動，等於持續自動更新位置。現在席位固定在按下「進入」的那一刻，想換位置要離開再進入（再打卡一次）。說明文字、操作說明、隱私權政策都已更新。
2. **第一次打卡前明確詢問「要在地圖上顯示你的位置嗎？」**，可以選「允許」或「不允許」。拒絕就不打卡、不出現在任何人的地圖上。雷達的打卡、重新打卡、量子世界的「進入」都會先檢查。設定裡新增「在地圖上顯示我的位置」開關，關掉立刻結束打卡。
3. App Store Connect：英文（美國）的隱私權政策網址改成英文版 `privacy-en.html`（原本指向中文版）。年齡分級已是 18+。

## 附件（回覆時上傳）

- `marketing/shots/review_proof_consent.png`：打卡前的位置同意（允許／不允許）
- `marketing/shots/review_proof_settings.png`：設定裡的「在地圖上顯示我的位置」
- `marketing/shots/review_proof_quantum_fixed.png`：量子世界說明「席位固定在按下進入的那一刻，走路不會移動」

## Reply

```
Hello App Review team,

Thank you for the review. Build 1.0.4 (17) addresses every point, and we would also like to put on record why we believe the Quantum World already met Guideline 5.1.2(i).

1) Permission to show location on a map, with the option to decline
Before the first check-in, the app now asks "Show your location on the map?" with "Allow" and "Don't allow". If the user declines, they are not checked in and do not appear on anyone's map. The same question is asked before entering the Quantum World, and users can withdraw permission at any time in Settings > "Show my location on the map", which ends the check-in immediately. (Screenshot 1.)

2) Manual check-in every time
On the main map, others see only the spot where the user tapped "Check in here". The check-in ends when the app goes to the background, and there is no automatic check-in or setting for one.

About the Quantum World: we respectfully disagree that it displayed users' locations. Every user there sits on a seat in a single shared hive centered on Taipei 101, regardless of the country or city they are actually in. Nobody can tell which country, city or street another user is in. We have reviewed this carefully and confirmed that the displayed position cannot be converted back to a real location. The only thing that changed after entering was the user's own walking distance, added to that seat. If you believe a real location can be derived from the Quantum World, please share the specific data or method that shows it; we will fix any real issue immediately.

Even so, to remove any doubt, build 17 fixes the seat at the moment the user taps "Enter"; it no longer moves while the user walks. To move, the user has to leave and tap "Enter" again, which is a new manual check-in. (Screenshot 2.)

Mood Whisper is a location-based app, and showing people who are nearby is its purpose. We have taken every precaution the guideline asks for. If you still see any part of the app as showing a user's location without these precautions, please point us to the exact screen and steps. We would also appreciate confirmation of whether the walking movement in the Quantum World, which never reveals a real location, would be acceptable in a future version.

3) Blocking
Tap any person's bubble to open their menu and tap "Block" (封鎖); both people disappear from each other's map. Settings > Block list manages blocked users, and blocking is also available in every chat.

4) Age rating and privacy policy
The app is rated 18+, and users confirm they are 18 or older before entering. The privacy policy URL is set for every localization; the English localization now points to the English policy: https://mood-whisper-f7de9.web.app/privacy-en.html

To test with demo people, type #review in the mood field on the entry screen, tick the terms box, tap the check-in button and choose "Allow".

Thank you,
Softchip
```
