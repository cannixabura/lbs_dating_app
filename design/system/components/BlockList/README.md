# BlockList

「沉入黑暗的名單」: everyone this person has blocked, opened from Settings › 我 › 管理封鎖名單. It is a GlassCard dialog; the list scrolls once it is taller than 45% of the screen.

- **Row**: a 36px plain avatar (`night-700`, `glass-line` border, `ink-faint` person icon; never their real photo), then the name, then a text button 「解除放逐」 in `aurora-blue` with a 44px tap target. Rows are separated by `night-600` dividers.
- **Name**: the city name they had when blocked, followed by `(#7204)` in `ink-faint`, where #7204 is the last 4 characters of the ID in capitals. With no city name, just `#4582`. Long names end in an ellipsis.
- **Empty**: a 40px moon in `ink-faint` and 「夜色清朗，你的城市未曾放逐任何人。」
- **Closing**: a ghost 「關閉」 button across the bottom.
- **Blocking is two-way**: both people vanish from each other's radar and knocks and resonance between them are refused. Blocking shows the `danger` toast 「已將此人沒入黑暗。」
- **Unblocking** happens at once with no confirmation: the row disappears and 「已解除封鎖，城市再次產生交集。」 appears. The other person is never told about either action.
- **Wording**: blocking is 「沒入黑暗」 and unblocking is 「解除放逐」. Keep this night vocabulary; never say 「黑名單」.
