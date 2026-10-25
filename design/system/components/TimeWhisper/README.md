# TimeWhisper

低語穿越: a letter to your future self, left at a place. Only the author can ever see it. It unseals after a month or a year, and opens only when the author is back within 100 m. It can be read once, then it is gone. Four parts: the composer mode, the sealed marker, the reader, and the list in settings.

- **Composer**: the Whisper composer with a segmented control 給經過的人 / 寄給未來的自己.
  - Choosing the future adds a second segment 一個月後 / 一年後 and switches the icon to the hourglass in `aurora-violet`.
  - Title 低語穿越, prompt 「寫給未來的自己。時間到了，回到這裡才能打開。」, up to 120 characters.
  - Caption 「只有你看得到 · 一個月後解封並通知你 · 回到 100 公尺內打開」. The primary button reads 封存在這裡.
  - At most 5 unopened letters per person.
- **Sealed marker**: a 26px circle at 75% opacity, drawn on the bottom layer under envelopes and bubbles.
  - It is not tappable and has no date label, so it never covers or competes with other people.
  - Sealed: lock-clock icon in `ink-faint`. Unsealed: open-lock icon in `aurora-violet` with a soft glow.
- **Unlock**: one push when the time arrives: 「一個月前的你，在某個地方留下了一句話。回到那裡，就能讀到。」 Walking back within 100 m opens the reader automatically.
- **Reader**: an open-lock icon, 「一個月前的你，在這裡說」, 「寫於 2026/10/24」, the text in a `night-700` box with an `aurora-violet` border and glow, then 「這封信只會出現這一次。」 and a single button 收進心裡. The letter is deleted from the server as it opens.
- **List (設定 › 我的低語穿越)**: sealed letters show 「2026/11/23 解封 · 寫於 2026/10/24」, unsealed ones 「已解封 · 距離你 350 公尺」. Each row has a delete button, and the list never shows the text before it is opened.
