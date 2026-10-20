# ProfileEdit

「編輯個人狀態」: avatar, city name and current mood in one glowing GlassCard dialog. It opens from a tap on the dock's own area or from Settings › 我. Nothing changes until 儲存; 取消 discards everything, including a newly uploaded avatar.

- **Avatar ring**: 92px with a 3px ring in a gradient from the **mood colour** to `aurora-violet`, and a soft glow in the mood colour. A 30px deep-gradient camera badge sits bottom-right. The caption 「輕觸更換大頭貼 · 光環是你的心情色」 sits below.
- **Live mood colour**: as the person types in 當下心情, the ring changes colour (300ms), using the same keyword table as the bubbles:
  - 😊 開心 笑 → `mood-joy`
  - 😢 難過 哭 → `mood-sad`
  - 😡 生氣 怒 → `mood-angry`
  - 🌿 平靜 發呆 → `mood-calm`
  - 🔥 熱情 → `mood-passion`
  - 💖 愛 心 → `mood-love`
  - otherwise `mood-default`
  - The first match wins. This lets people see what colour their bubble will be before saving.
- **城市稱呼**: optional, up to 10 characters, placeholder 「選填，例如：遊蕩的貓」. When it is empty, the radar shows `#` plus the last 4 characters of the ID in capitals (for example `#7204`).
- **當下心情**: required, up to 20 characters, placeholder 「例如：漫步在微雨中 🌿」. It opens prefilled with the last mood. Saving an empty mood shows 「心情不能為空，給城市留下點微光吧。」
- **Uploading**: the photo is resized to at most 800px, and a thin `aurora-violet` spinner circles the ring. 儲存 is disabled until the upload finishes; a failure shows a `danger` toast.
- **After saving**: 「狀態已更新，城市正感知你的呼吸。」, the bubble updates right away, and blocked words in the nickname or mood are masked as ＊ on the server.
