# EmptyRadar

When the radar has finished at least one scan and nobody is within 5km, a glass card sits above the dock instead of leaving an empty map. Being first should feel like a role, not a failure.

- Gradient title 「你是今晚第一道光」, then the body copy telling the person their mood is already glowing and suggesting a whisper.
- If CityMoodWeather is not quiet, one caption borrows its top mood: 「今晚城市裡有 N 個人，多半感到『平靜』」. Under 10 people the line is left out, same rule as the chip.
- Two actions: 「邀請朋友點亮街區」 (primary, `i-invite`, opens the share sheet with the `?ref=invite` landing link) and 「分享我的心情卡」 (ghost, `i-share`, opens MoodCard).
- Never show it before the first scan completes, so a slow network doesn't flash "nobody's here". It disappears as soon as one bubble appears.
