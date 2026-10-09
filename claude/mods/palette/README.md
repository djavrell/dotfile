# palette

Shares the terminal's color scheme with every Claude Code mod. Mods cannot import code from one another's folders, so the
scheme lives in one shared service on `$`, and each pane or band paints with the same colors as wezterm.

The colors come from wezterm's nordic scheme, so the Claude Code UI matches the terminal. The mod keeps no state and draws
nothing of its own.

## Example

Another mod lists `palette` under `dependencies` in its `plugin.json`, then reads the theme with `$.palette.get()`:

```ts
const theme = await $.palette.get();
const accent = theme.ansi.blue;
```

Used by `session` (the side pane) and `pr-viewer` (the band above the prompt).
