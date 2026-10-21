# MoodBubble

A person on the radar: their one line of mood text in a glass bubble, a pin, a ground ripple and a caption of name · distance. No mood icon.

- Provide the mood text, its `mood-*` colour as `--m` (picked from the text by the keyword table in the README), the caption, and the state.
- States: active (breathing halo), 休息中 (`cw-bubble--resting`, `resting` opacity, no breathing, a 休息中 tag), 歷史殘影 (`cw-bubble--shadow`, `shadow-ink`, dashed border, no name, fades from `shadow-start` to `shadow-end`), 敲門中 (`cw-bubble--knocking`, `knock-pink` pulse).
- Captions use `caption` in `ink-faint`; a shadow's caption shows only the distance.
- Don't blur behind bubbles; the halo is a shadow, not a backdrop filter.
- **Stacking order** (bottom to top): 歷史殘影 → 示範 → 休息中 → active people → people you're involved with (敲門中) → the bubble you just long-pressed or double-tapped (raised for 4 seconds). Within a tier, the nearer bubble (lower on screen) sits on top. Demo bubbles never cover a real person.
- **Clusters**: bubbles that overlap enough to mis-tap merge into one glass orb: the count in tabular numerals, up to five mood-colour dots, a ring and halo in the most common mood colour, and the caption 「這裡有 N 個心情」. Tap it and the bubbles fan out into a ring of petals around it (two rings when there are more than 7; a 「更多 +N」 petal pages through more than 15), joined to the centre by 1px stems; the map behind dims to `night-900` at 72%; petals are fully opaque and unscaled by distance. Every petal keeps its long-press and double-tap. Tap the centre or anywhere empty to fold it back. No menu, list or dialog.
- Positions are already blurred to 100m cells for privacy, so in a crowd zooming alone can't separate people; the cluster is the answer, not more zoom.
