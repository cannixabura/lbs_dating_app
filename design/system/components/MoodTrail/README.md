# MoodTrail

「我的心情軌跡」: a private diary of where and how the person felt, opened from Settings › 我. It lives only on this phone (local storage) and is never uploaded.

- **App bar**: `night-900`, centred title 「我的心情軌跡」, back chevron. Directly under it the promise 「只存在你的手機上，不會上傳到任何地方。」 as a caption. Always show it.
- **Weekly recap** (GlassCard): 「這週的你」, then 「最常感到『平靜』，共 N 次」 with the mood word in its mood colour and semibold, then 「在 N 個不同的地方，留下了 N 道心情」 (places within about 300m count as one). Empty week: 「這週還沒有心情軌跡。每次寫下心情、或走到新的地方，這裡都會多一道光。」
- **Map**: the same night map style, 300px tall in the app, `radius-lg`. Each entry is a glowing point in its mood colour: a 16px soft halo plus a 5px dot outlined in `night-900`. The camera fits all points. Rotate and tilt are off. Attribution 「© OpenStreetMap © CARTO」 sits below at 10px `ink-faint`.
- **Daily list**: newest first, grouped under 「10 月 15 日」 headers. Each row has a 10px glowing mood dot, the mood (one line, ellipsis) and the time in `ink-faint`.
- **Controls at the end**: a glass row with 「記錄我的心情軌跡」 and its switch (「關閉後不再記錄新的軌跡」), then a danger button 「清除心情軌跡」 behind a confirm dialog (「無法復原」). The clear button is hidden when there is nothing to clear.
- **What gets recorded**: a new point only when the mood changes, the person moves more than 300m, or 3 hours have passed. Coordinates are kept to about 10m, and at most 400 entries.
