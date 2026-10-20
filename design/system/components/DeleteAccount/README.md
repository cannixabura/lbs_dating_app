# DeleteAccount

In-app account deletion, required by App Store guideline 5.1.1(v) and Google Play's account deletion policy. It must be easy to find, finish in the app, and say plainly what is erased and what is kept.

- **Entry**: the last row of the settings sheet, below a divider: 「刪除帳號與資料」 / 「永久抹除你在城市留下的一切」, with the text and the `i-trash` icon in `danger`. Never hide it behind more menus.
- **Confirmation** (GlassCard dialog): a 36px `danger` trash icon and the title 「刪除帳號與資料」.
  - What is erased: 「你的位置、心情、城市稱呼、大頭貼、留下的低語、微光、封鎖名單與進行中的對話都會被永久刪除，無法復原。」
  - What is kept and why: 「為了防止濫用，檢舉紀錄會依隱私權政策保留 1 年。」
  - Buttons: 取消 (ghost) and 永久刪除 (danger outline). There is no filled red button; the weight comes from the words.
- **While deleting**: the button reads 「刪除中…」, both buttons are disabled, and location, heartbeat and radar stop first so nothing is written back afterwards.
- **Failure**: the app returns to normal (online again), the dialog stays open, and the `danger` toast 「刪除沒有完成，請檢查網路後再試一次。」 appears.
- **Success**: the server erases the account, including the whispers this person left, the glimmers they sent and received, and their reader marks on other whispers (only the anonymous count stays); the phone's local data is cleared (including the mood trail), the user is signed out, and the app returns to the intro screen with no way back.
- **Web route** (`/delete-account` on the landing site, linked from the store listings): steps for people who still have the app, plus an email route (主旨「刪除帳號申請」, handled within 30 days) for people who removed it. It lists the same erased and kept data as the dialog.
