# Gathering

集會: one host broadcasts to everyone within 5 km whose city nickname carries the event's emoji. Built for parades, New Year's Eve and tour groups. Four parts: the host on the radar, the pinned banner, the host panel, and the handoff.

- **Host ring**: the host's avatar gets a 5px conic ring from `aurora-violet` to `aurora-blue` and back, with a blue glow (`rgba(79,195,247,.45)`, 14px). The caption starts with 「主持 🌈」 in `aurora-blue`. Hosts float above everyone else and are never merged into a cluster orb, so a crowd can always find them.
- **Pinned banner**: a glass card under the city-mood chip, above the radar.
  - Head row: the emoji, the event name in bold, then 「主持人公告」 for participants or 「你正在主持」 for the host, a report flag (participants) or the manage icon (host), and a collapse chevron.
  - Body: the latest announcement and how long ago. An open question shows below it as 「主持人問：…」 in `aurora-blue`.
  - After a handoff it shows 「主持人已交棒 · 2 分鐘前」.
- **Host panel**: a sheet with the emoji, name, time window and 「你正在主持」. It contains:
  - The audience rule 「5 公里內、稱呼裡有 🌈 的人會看到公告並收到推播。你看不到他們是誰。」
  - The announcement composer (200 characters) and the recent announcements list.
  - The whole-room question (40 characters) and its tally, which shows percentages only and stays quiet under 10 answers.
  - The handoff hint and a danger 結束活動 button.
- **Create form**: name with the hint 「活動名稱，例如：台北101跨年煙火秀」, exactly one emoji (no default), start and end within 24 hours. The same emoji cannot run twice within 10 km.
- **Handoff**: long-press a participant → 轉移主持人 → 公開交棒 (everyone is notified) or 安靜交棒 (no notice). The recipient has 5 minutes to accept and must still be in range with the emoji.
- **Never reveal participants**: the host sees no list and no names, only the tally. Reports target a single announcement and hide it only at max(10, 10% of participants) valid reports.
