# MoodBubble

A person on the radar: their one line of mood text in a glass bubble, a pin, a ground ripple and a caption of name · distance. No mood icon.

- Provide the mood text, its `mood-*` colour as `--m` (picked from the text by the keyword table in the README), the caption, and the state.
- States: active (breathing halo), 休息中 (`cw-bubble--resting`, `resting` opacity, no breathing, a 休息中 tag), 歷史殘影 (`cw-bubble--shadow`, `shadow-ink`, dashed border, no name, fades from `shadow-start` to `shadow-end`), 敲門中 (`cw-bubble--knocking`, `knock-pink` pulse).
- Captions use `caption` in `ink-faint`; a shadow's caption shows only the distance.
- Don't blur behind bubbles; the halo is a shadow, not a backdrop filter.
