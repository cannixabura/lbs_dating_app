# CountdownPill

A time limit made visible: the 300-second wait after a knock, and the chat's 10 minutes before it dissolves.

- Provide the remaining time (mm:ss in the `numeral` style, tabular), a short unit label, and the fraction left for the bar.
- The bar is `knock-pink` while waiting; switch to `cw-pill--warn` (`danger`) in the last 60 seconds.
- Don't animate the digits; update them once a second.
