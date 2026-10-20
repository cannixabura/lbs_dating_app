# GlassToast

A short notice at the top of the screen, replacing the old full-width green SnackBar.

- Provide an icon, one line of text (bold the person's name), and a duration (3 seconds; 4 for a message preview).
- Slides down under the status bar, never covers the compose field or the dock.
- Use `cw-toast--danger` only for failures (「敲門沒有送出，請稍後再試。」).
- While the app is in the foreground this replaces system notifications.
