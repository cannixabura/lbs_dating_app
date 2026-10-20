# KnockRitual

What the person who knocked sees while waiting: a knock-pink dotted arc flowing from their own position to the other bubble, a waiting pill with a countdown, and a particle burst at the other bubble when the knock ends without a chat.

- Provide your own screen position, the target bubble's anchor, the target's name and the seconds left (300 at the start).
- The arc bows upward, up to 120px high; its dots flow toward the target once every 0.9s and get brighter as they near it. It draws under the bubbles.
- The waiting pill sits under the status bar: 「等待 <name> 回音 04:57」 with a 56px bar. In the last 60 seconds the time, icon and bar turn `danger`.
- Every ending except 同意 dissolves the light into knock-pink particles at the target (1.1s, rising and fading) with its own message:
  - 婉拒: 「這次沒有交集，讓彼此保留一點空間。」
  - 略過: 「對方先略過了，敲門聲悄悄消散。」
  - 5 minutes without an answer: 「沒有回音，敲門聲悄悄消散了。」
  - The other person leaves the radar: 「對方已沒入城市，悄悄收回敲門聲…」
- With reduced motion the arc is still, and the burst is skipped (the message still shows).
- The person being knocked feels a heartbeat haptic: two lub-dubs, light then strong (Core Haptics on iPhone).
