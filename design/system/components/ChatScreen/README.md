# ChatScreen

The room opened when a knock is accepted: a short, quiet conversation that dissolves on its own. Background `night-800`.

- **Glass header** (`glass-fill`, `glass-line`, `radius-lg`, 8px from the edges):
  - a back chevron 「離開對話」
  - a 38px avatar ringed in `aurora-violet`
  - 「與 遊蕩的貓 的交集」 (15px medium, one line)
  - the caption 「倒數 09:42 消散」: the numbers are tabular and `knock-pink`, and turn `danger` in the last minute
  - the 檢舉 flag, which opens ReportSheet (required by App Store guideline 1.2)
- **Countdown**: 10 minutes, and **every new message from either side resets it to 10:00**. A silent room dissolves; a living one stays.
- **Messages**: see ChatBubble. Theirs sit on the left on `night-700` with a `glass-line` border; yours sit on the right on the deep gradient. The corner nearest the speaker is 4px. Max width is 76%, 15px text at 1.6 line height. The other person's name appears only above the first message in a run.
- **Typing line**: 「對方正在輸入中…」, 12px italic `ink-faint`, slides open (24px, 300ms) above the compose row.
- **Compose**: a pill input (radius 28, `night-700`) with 「輕聲說點什麼…」, up to 4 lines and 1000 characters, plus a 48px round gradient send button with `glow-violet`.
- **How it ends**: a full-screen `night-900` overlay at 96% with a moon icon and one line in `ink-muted`, 300 weight, 3px tracking, then back to the radar:
  - 「交集已結束...」: you left
  - 「時間已盡，交集消散...」: the countdown ran out
  - 「對方已沒入城市...」: they left or disconnected
  - 「已封鎖對方，交集結束。」: you reported and blocked
- **Nothing is kept**: the room and its messages are deleted from the server a few seconds after it ends. While you are in a room, notifications from that room don't pop up as toasts.
