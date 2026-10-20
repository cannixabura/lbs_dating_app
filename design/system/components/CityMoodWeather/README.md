# CityMoodWeather

How the city feels tonight: anonymous moods from the last 24 hours within 20km, as one chip at the top left of the radar and a breakdown sheet behind it.

- **Chip**: under the status bar on the left; a dot in the top mood's colour and 「今晚的城市 · 平靜 38%」. Tap it to open the sheet.
- **Sheet**: gradient title 「今晚的城市心情」, 「20 公里內，今晚有 N 個人留下心情」, one glowing bar per mood in its `mood-*` colour, sorted largest first, then the caption 「匿名統計 24 小時內的心情；少於 10 人時不顯示比例。」
- **Quiet**: below 10 people, never show percentages (with few people they reveal who feels what). The chip reads 「今晚的城市還很安靜」 in `mood-default`, and the sheet invites the person to light the city up.
- Moods are grouped with the same keyword table as the bubble colours. The empty-radar card borrows the top mood: 「今晚城市裡有 N 個人，多半感到『平靜』」.
- Election night uses this same component as a non-partisan moment: the city's mood, never a side.
