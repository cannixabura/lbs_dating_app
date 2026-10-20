# Dock

The glass bar at the bottom of the radar. It is the viewer's own presence in the city, plus the three things they can do on their own: write, share, settings. It replaces the lone settings gear.

- **Placement**: 16px from the left and right edges, 16px above the safe-area bottom; 64px tall; `glass-fill`, `glass-line` border, `radius-lg`, `lift` shadow. Fades in with the bubbles after the entry flight lands.
- **Left (the whole area is one button, 「編輯你的心情」)**: a 38px avatar ringed in the viewer's mood colour with a soft glow, then the mood on one line (15px `ink`, ellipsis) and a caption:
  - no nickname yet: 「你的心情 · 點一下修改」
  - with a nickname: 「小樹 · 你的心情」
  - glimmers received in the last 24h: 「今晚 N 道微光與你共鳴」 in `knock-pink` (takes priority; see Resonance)
- **Right**: three `ink-muted` icon buttons, each at least 44×48 with a tooltip and an accessible label: `i-pen` 留下一則低語 (Whisper composer), `i-share` 分享我的心情卡 (MoodCard), `i-sliders` 設定.
- **Settings sheet**: a GlassCard titled 「設定」 with section labels in `ink-faint`:
  - **我**: 編輯個人狀態, 管理封鎖名單 (danger-coloured icon), 我的心情軌跡, then the 每晚提醒 switch (21:30).
  - **分享**: 分享我的心情卡, 邀請朋友點亮街區.
  - **關於**: 使用條款, 隱私權政策, 聯絡我們 (shows the email).
  - Then a divider and 刪除帳號與資料, with both the text and the icon in `danger`.
  - Every row has a 22px icon, a title with an optional caption, and a chevron.
- The EmptyRadar card sits 96px above the dock so the two never overlap.
