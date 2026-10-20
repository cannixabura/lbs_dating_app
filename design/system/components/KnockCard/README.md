# KnockCard

The incoming knock: who is knocking, three answers (略過, 婉拒, 同意) and a quiet 檢舉 link. It is a glowing GlassCard dialog over a `night-900` 60% scrim.

- **Content**: a 56px avatar ringed in `aurora-violet` with `glow-violet`, the title 「片刻交集」, and 「遊蕩的貓 正在敲門，想與你產生交集…」. No mood, no distance; the name is enough.
- **Buttons**: 同意 uses `cw-btn--warm` (`city-amber`), 婉拒 uses `cw-btn--ghost`, 略過 uses `cw-btn--text`. There is no filled button, because the choice belongs to the person, not the app.
  - 同意 opens ChatScreen.
  - 婉拒 tells the knocker 「這次沒有交集…」 and starts their cooldown.
  - 略過, or tapping outside the card, quietly removes the knock.
- **檢舉這個人**: a 44px-tall caption link that also declines the knock, then opens ReportSheet. It is required by App Store guideline 1.2; never remove it.
- **Arrival**: the knock sound plays once along with the heartbeat haptic: two double beats (Core Haptics on iPhone, a vibration pattern on Android). The card never appears in the background; a push notification is used there instead.
- **Knocker's toasts**:
  - sent: 「敲門聲已送出，等待回音…」
  - cooldown after a decline (5 min, then 10 min, then 24 h): 「對方目前不想被打擾，請給彼此一點空間 (10 分鐘)。」
  - right after a chat: 「你們才剛結束交集，讓回憶沉澱一下吧。」
  - too many knocks: 「敲門太頻繁，請感受一下城市的呼吸...」
  - the other person left: 「對方已沒入城市，悄悄收回敲門聲…」
  - failure: in `danger`
  - While waiting, see KnockRitual.
- **Block confirmation** uses the same card style: a 36px `danger` block icon, 「確認封鎖」, 「確定要將 … 沒入黑暗嗎？封鎖後，雙方將從彼此的城市中消失。」, then 取消 (ghost) and 確定封鎖 (danger).
