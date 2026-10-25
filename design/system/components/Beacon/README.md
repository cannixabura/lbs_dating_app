# Beacon

城市燈塔: gender-friendly, accessible and family toilets within 2 km, from the Ministry of Environment's national public toilet data (refreshed monthly). Four parts: the toggle and filters, the markers, the detail sheet, and reporting.

- **Toggle**: a 44px glass pill at the bottom left, above the dock.
  - Off: the toilet icon only, inside the oval outline.
  - On: the icon and the visible count (「· 12」), with an `aurora-blue` border and glow.
  - On/off and the filters are remembered on the phone.
- **Filters**: three 44px round icon-only buttons stacked above the toggle, shown only while it is on: 性別友善, 無障礙, 親子 (the names are their accessibility labels and tooltips). No filter selected shows everything; selected filters show sites that match any of them.
- **Map attribution**: 「© OpenMapTiles © OpenStreetMap」 sits below the dock, out of the way of the map.
- **Markers**: 26px rounded squares (8px radius) in `night-800` with an `aurora-blue` border and icon. They sit on the bottom layer, under time-whisper markers, envelopes and bubbles, and use the same 3D projection. The icon picks the first feature in the order gender-friendly, accessible, family. A site flagged by reports turns `ink-faint`.
- **Detail sheet**:
  - Site name, then distance and address.
  - Feature pills, then the night line: 「晚上可能有開（推估）」 with a moon icon in `city-amber`, or 「可能只在白天開（推估）」.
  - The room list, any flags in `danger` (「有人回報：不是性別友善」), and the primary button 走路過去, which opens the phone's map app.
- **Reporting**: 「資料不對嗎？」 and three text buttons: 不是性別友善 (only on gender-friendly sites), 晚上沒開, 找不到這間廁所. After sending: 「謝謝你，已經收到『…』的回報。」 Three reports of the same problem within 180 days flag the site. Reporters are never shown.
- **Source line, always visible**: 「資料來源：環境部「全國公廁建檔資料」，每月更新。開放時間是依場所推估的。」 Never present the night estimate as fact.
