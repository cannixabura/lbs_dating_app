# Whisper

A sentence left at a place for whoever passes by next (城市漂流瓶). Three parts: the envelope on the radar, the composer, and the reader.

- **Envelope**: a 30px `night-700` circle with a 1.5px border and glow in the author's mood colour (keyword table in the README), drawn under the bubbles with the same 3D projection. Your own whispers use the pen icon. Only whispers within 300m appear.
- **Composer**: up to 60 visible characters, prompt 「寫給下一個經過這裡的人。」, caption 「7 天後消散 · 不會顯示你是誰 · 只透露你曾在這一帶」. The primary button 留在這裡 is disabled while the field is empty.
- **Reader**: the text in a `night-700` box with a mood-coloured border, time as 「3 小時前留在這一帶」.
  - Someone else's whisper: opening it collects it. Shows 「你收下了這則低語。」, how many collected it before you, and the required 檢舉這則低語 link.
  - Your own whisper: 「已被 N 個人收下」 and a danger button 收回這則低語.
- **Never show the author**, and never link a whisper to a bubble on the radar: that would reveal who wrote it. A report goes to the whisper, so the report sheet has no block option.
- Limits the copy must explain when hit: 3 active whispers per person, one per 10 minutes, blocked words rejected with 「這則低語含有不適合的字詞，換個說法吧。」
