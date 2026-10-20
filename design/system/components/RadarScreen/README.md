# RadarScreen

The main screen put together: the night map, bubbles in every state, the viewer's own position with its blue ripple, a toast, and the glass dock that replaces the lone settings gear.

- The map is the MapLibre night style (ground `night-800`, buildings `map-building-low` to `map-building-high`, streets in muted teal `map-road-*` with a soft same-colour glow, water `map-water`); this preview stands it in with CSS.
- The dock shows the viewer's own mood with whisper, share and settings buttons; see Dock.
- Name · distance captions are `ink-faint` on a soft `night-900` text shadow so they stay legible over the road glow.
