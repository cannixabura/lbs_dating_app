# 回覆 App Review：Guideline 5.1.2(i)（2026-11-03 退件，送審 1.0.3 (12)）

1. 伺服器先部署（`firebase deploy --only functions`）：地圖上只顯示此刻打卡中、開著 App 的人，不再顯示休息中與殘影。
2. 上傳 1.0.3 (13)，在版本頁把建置版本換成 (13)。
3. 「App 審查資訊 › 備註」整段換成下面的 Review notes（原本的只剩 22 字元可用）。
4. 在退件訊息串按「回覆 App 審查」，貼上 Reply，然後按「重新提交至 App 審查」。

## Reply

```
Hello App Review team,

Thank you for the review. Build 1.0.3 (13) and a server update tighten both precautions.

1) Blocking other users
- Tap any person's bubble on the map (or long-press it) to open their menu, then tap "Block" (封鎖). Once blocked, both people disappear from each other's map for good. The same menu has "Report" (檢舉).
- Blocking and reporting are also available inside every chat (the flag icon at the top), on whispers, on gatherings and on café guestbook notes.
- Settings > Block list (封鎖名單) shows everyone you have blocked and lets you unblock them.

2) Manual check-in every time, no automatic check-in
- Nothing about the user appears on the map until they tap "Check in here" (在這裡打卡). There is no setting, option or shortcut for automatic check-in.
- New in this build: the check-in ends as soon as the app goes to the background or the screen locks. The user disappears from everyone's map immediately and has to tap "Check in here" again when they come back.
- New in this build: while checked in, a "Checked in · Check out" (打卡中 · 結束打卡) button is always on screen. Tapping it removes the user from the map right away.
- New on the server: the map only shows people who are checked in right now with the app open. People who have left, locked their phone or switched apps are no longer shown, and no trace of their location remains.
- Other people see the spot where the user checked in, never their live position. If the user walks more than 1 km away, a "Check in here" button appears; their position only changes if they tap it.

To test with demo people, type #review in the mood field on the entry screen and tap the check-in button. Demo people then appear around you; tap one to see the Block and Report options.

Thank you,
Softchip
```

## Review notes（整段取代原本的備註，約 2200 字元，上限 4000）

```
Mood Whisper (城市低語) is an anonymous, location-based app for adults (18+). No account or password is needed.

Changes in 1.0.3: Quantum avatar with an optional Rainbow Orb purchase (Quantum World → hive button, top right → 量子化身); Parallel Universe adds Bangkok, Manila and Sydney; Thai language.

Review mode (the radar only shows people within 5 km, so you can test every social feature alone):
1. Skip (略過) the intro, answer 已滿 18 歲 (I am 18 or older) and allow precise location.
2. Type #review in the mood field, tick the terms box and tap 在這裡打卡，走進城市 (Check in here and enter). This is the manual check-in.
3. 20 demo people (labelled 示範) appear around you. With Parallel Universe on (globe, top right) some appear as visitors from Tokyo, Seoul, Bangkok, etc.
4. Tap a bubble to open its menu: Block (封鎖), Report (檢舉), Knock (敲門), Glimmer. A knocked demo person accepts and a 10-minute chat opens.
5. Settings (sliders icon, bottom right): Block list (封鎖名單), Guide (操作說明), Contact, Delete account.

Location (Guideline 5.1.2(i)):
- Users must tap "Check in here" every time to appear on the map. There is no automatic check-in and no setting for one.
- The check-in ends as soon as the app goes to the background or the screen locks; the user disappears from the map and must check in again.
- While checked in, a "打卡中 · 結束打卡" (Checked in · Check out) button is always on screen and removes the user from the map at once.
- The map only shows people checked in right now with the app open. No trace remains after someone leaves.
- Others see the check-in spot, never a live position. Before checking in, the user is invisible and sees no one.

User-generated content (Guideline 1.2):
- 18+ rating; users confirm age and accept the terms (zero tolerance for objectionable content): https://mood-whisper-f7de9.web.app/terms-en.html
- Moods, names, whispers, chats and announcements are filtered for objectionable words and contact details.
- Every bubble, chat, whisper and gathering announcement can be reported; blocking removes both people from each other's map.
- Reported content disappears for the reporter at once; we act on every report within 24 hours.
- Contact: service.softchip@gmail.com
```
