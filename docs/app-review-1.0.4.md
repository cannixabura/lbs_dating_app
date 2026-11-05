# 送審 1.0.4 (16)：App Store Connect 要填的文字（2026-11-05）

1.0.3 沒有上架，所以 1.0.4 的「新增功能」要把 1.0.3 和 1.0.4 的內容合在一起寫。

## 行銷宣傳文字（繁體中文，上限 170 字）

```
今晚，寫下一句心情，看見附近 5 公里的人。城市太安靜？點一下地球，和東京、首爾、曼谷的夜晚重疊；或走進量子世界，和全世界坐在同一間房間，跟住在光柱裡的 AI 艾婭聊聊。
```

## 此版本的新增功能（繁體中文）

```
・新增艾婭：量子世界中央光柱裡的 AI，點光柱底下的「艾婭 · AI」就能聊天，每天 3 次免費
・艾婭偶爾會在光柱裡現身：整點報時、每天第一次進來，或不經意的偶遇
・新增時光包：免費次數用完後，可以購買聊天次數
・新增水晶球頭像：選一顆屬於你的光球，在地圖上陪著你
・光球、星環兩款免費；彩虹水晶球為一次購買、永久擁有，換手機或重新安裝時可用「恢復購買」找回
・平行宇宙新增曼谷、馬尼拉、雪梨；新增泰文介面
・量子中心的光柱改為光粒子，報時微光更明顯
・抓不到定位時（例如沒有 GPS 的 iPad），可以在地圖上選擇自己的位置
・細節優化與錯誤修正
```

## App 審查資訊 › 備註（英文，整段取代，上限 4000 字元）

```
Mood Whisper (城市低語) is an anonymous, location-based app for adults (18+). No account or password is needed.

Changes in 1.0.4:
- AIYA, an AI character in the light pillar at the center of Quantum World (details below).
- Consumable "time packs" for AIYA chats: aiya_time_5 (5 chats) and aiya_time_20 (20 chats).
- Quantum avatar with an optional Rainbow Orb non-consumable purchase (Quantum World → hive button, top right → 量子化身), with Restore Purchases.
- Parallel Universe adds Bangkok, Manila and Sydney; Thai language.
- Location fallback for devices without GPS (Guideline 2.1(a), iPad): see "iPad and location" below.

Review mode (the radar only shows people within 5 km, so you can test every social feature alone):
1. Skip (略過) the intro, answer 已滿 18 歲 (I am 18 or older) and allow location.
2. Type #review in the mood field, tick the terms box and tap 在這裡打卡，走進城市 (Check in here and enter). This is the manual check-in.
3. 20 demo people (labelled 示範) appear around you. Tap a bubble for Block (封鎖), Report (檢舉), Knock (敲門) and Glimmer. A knocked demo person accepts and a 10-minute chat opens.
4. Settings (sliders icon, bottom right): Block list (封鎖名單), Guide (操作說明), Contact, Delete account.

iPad and location:
- On a Wi-Fi-only iPad the app first tries precise location, then the last known location, then Wi-Fi positioning.
- If no location can be found, the screen 暫時抓不到你的位置 shows 在地圖上選擇位置 (Choose on the map). Move the map so the dot sits on your location and tap 就是這裡 (I'm here), then check in as usual.

AIYA (AI chat) and time packs:
1. In Quantum World, tap the small 艾婭 · AI label under the light pillar, accept the AI notice and AIYA greets you.
2. AIYA always says she is an AI. Chats last up to 10 minutes; every reply can be reported (long-press it). Messages are filtered, and AIYA refuses romance, sexual content, location requests and professional advice.
3. Everyone gets 3 free chats a day. In review mode chats stay free. To see the purchase sheet, tap "＋ 時光包" (+ Time packs) above the message box at any time, then buy 5 or 20 chats with a sandbox account. Purchased chats are stored on the account on our server.

Location (Guideline 5.1.2(i)):
- Users must tap "Check in here" every time to appear on the map. There is no automatic check-in and no setting for one.
- The check-in ends as soon as the app goes to the background or the screen locks; the user disappears from the map and must check in again.
- While checked in, a "打卡中 · 結束打卡" (Checked in · Check out) button is always on screen and removes the user from the map at once.
- Others see the check-in spot, never a live position. Before checking in, the user is invisible and sees no one.

User-generated content (Guideline 1.2):
- 18+ rating; users confirm age and accept the terms (zero tolerance for objectionable content): https://mood-whisper-f7de9.web.app/terms-en.html
- Moods, names, whispers, chats and announcements are filtered for objectionable words and contact details.
- Every bubble, chat, whisper and gathering announcement can be reported; blocking removes both people from each other's map.
- Reported content disappears for the reporter at once; we act on every report within 24 hours.
- Contact: service.softchip@gmail.com
```

## 回覆 App 審查（貼在 2.1(a) 退件的訊息串）

```
Hello App Review team,

Thank you for the review. We fixed this in version 1.0.4 (16).

On a Wi-Fi-only iPad the app now falls back from precise location to the device's last known location and then to Wi-Fi positioning. If location still cannot be determined, the screen "暫時抓不到你的位置" (Can't find your location yet) offers "在地圖上選擇位置" (Choose on the map). The user moves the map to their location, taps "就是這裡" (I'm here) and continues to the manual check-in. We tested this with location unavailable.

Thank you,
Softchip
```
