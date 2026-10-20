# ReportSheet

The report flow required by App Store guideline 1.2 and Google Play's user-generated-content policy: pick a reason, optionally add details, send, and block in the same step. It is a bottom sheet on a GlassCard that rises with the keyboard.

- **Reachable from four places**:
  - a bubble's long-press menu
  - KnockCard: 「檢舉這個人」 also declines the knock
  - the chat header: a report with block also ends the chat with 「已封鎖對方，交集結束。」
  - the whisper reader: 「檢舉這則低語」
- **Header**: a `danger` flag icon and 「檢舉 遊蕩的貓」 (one line, ellipsis), then 「你的檢舉不會讓對方知道。請選擇原因：」.
- **Reasons**, in this order: 騷擾或霸凌、色情或性暗示、詐騙或廣告、仇恨或暴力言論、冒充他人、其他. Each is a round radio button on a row with a `night-600` divider.
- **Details**: 「補充說明（選填）」, up to 500 characters.
- **Block**: 「同時封鎖對方，雙方將從彼此的城市中消失」, checked by default. Blocking is two-way: both people disappear from each other's radar.
- **Whispers**: the author is anonymous, so there is nobody to block; the checkbox is hidden and the title reads 「檢舉 這則低語」.
- **Sending**: 送出檢舉 stays disabled until a reason is chosen, and reads 「送出中…」 while sending. On success, close the sheet and show 「已收到你的檢舉，我們會在 24 小時內處理。」; on failure show a `danger` toast and keep the sheet open.
- **Server side**: three reports from different people automatically hide that person (or whisper) until a moderator reviews it.
