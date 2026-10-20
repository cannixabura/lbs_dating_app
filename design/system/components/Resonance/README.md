# Resonance

A lighter touch than knocking: send someone a glint of light that says "I feel it too", without starting a chat.

- **Sending**: double-tap a bubble, or long-press it and choose 「送出一道微光 (共鳴)」 (the `i-spark` icon in the bubble's mood colour; it is the first item in the menu). History shadows can also receive a glint, but they can't be knocked.
- **Sparkle**: on send, particles in the *receiver's* mood colour burst upward from their bubble (1s, ease-out), with a light selection haptic and the toast 「你送出了一道微光。」 With Reduce Motion, only the toast.
- **Limit**: one glint per person every 24 hours, enforced by database rules. A second try shows 「今天已經送過微光給對方了，明天再來吧。」 Blocked or hidden accounts are rejected the same way, so the sender can't tell which.
- **Receiving**: a light haptic, the toast 「有人送你一道微光，與你的心情共鳴。」, and the dock caption switches to 「今晚 N 道微光與你共鳴」 in `knock-pink`. Only the count of the last 24 hours, never who sent it.
