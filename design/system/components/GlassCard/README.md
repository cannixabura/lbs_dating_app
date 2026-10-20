# GlassCard

The surface for everything that floats over the map: dialogs, the profile editor, the block list, sheets.

- Provide the content; the card gives `glass-fill`, a 1px `glass-line` border, `radius-lg` and the `lift` shadow.
- Add `cw-glass--glow` only to the one card that needs the person's decision now (KnockCard, EntryCard).
- Use `cw-glass--form` when the card holds inputs.
- Do: dim the map behind an open card. Don't: nest a GlassCard in another, or put one over the bright onboarding art.
- Blur the background only while a card is open and the map is still; never blur behind moving bubbles.
