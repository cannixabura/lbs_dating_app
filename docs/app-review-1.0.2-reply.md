# 回覆 App Review：Guideline 5.1.2(i) 與 2.2（2026-10-27 退件，送審 1.0.2 (9)）

上傳 1.0.2 (9) 後，在 App Store Connect →「App 審查」的訊息串按「回覆 App 審查」，貼上下面這段英文；「App 審核資訊 › 備註」也換成 `docs/store-submission.md` 的新版本。

```
Hello App Review team,

Thank you for the review. Build 1.0.2 (9) addresses both issues.

Guideline 5.1.2(i) - manual check-in
- Users now check in manually every time they want their location displayed. On the entry screen the button reads 在這裡打卡，走進城市 ("Check in here and enter"), and the text under it explains that people nearby will see the user's mood and approximate location once they tap it. The keyboard's Done key does not check in; only the button does.
- There is no automatic check-in and no setting that enables one.
- Others see the place where the user checked in. It does not follow the user as they move. If they move more than 1 km away, a 在這裡重新打卡 ("Check in here") button appears, and their position only changes if they tap it.
- If the app stays in the background for more than 30 minutes, the check-in expires and the user has to check in again.
- Before checking in, the user is invisible to everyone and does not see anyone else either.
- The Terms of Use (English summary at the top, https://mood-whisper-f7de9.web.app/terms.html), the Privacy Policy and the in-app guide (Settings → 操作說明) describe the check-in.

Guideline 2.2 - beta testing features
- We removed the "1.1 internal test" (內部測試版) release-notes dialog that appeared at launch. The app no longer contains any beta or test wording or beta-testing features.

To test with demo people, type #review in the mood field on the entry screen and tap the check-in button (details are in the review notes).

Thank you,
Softchip
```
