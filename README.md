# .bashrc.d

My terminal and dev environment: zsh, neovim, wezterm, git, claude and the CLI tools around them. Runs on WSL (Arch) and native Linux.

## Bootstrap

```sh
git clone --recursive <repo> ~/.bashrc.d
~/.bashrc.d/bin/dots link     # symlink every module's config into place
dots health                   # what's missing or broken (bin/ is on PATH once the shell is reloaded)
```

`dots link` is idempotent: a real file found where a link should go is renamed `<file>.bak-<date>`, never overwritten.

## Modules

One folder per tool. The list lives in `modules.zsh`:

- `mods`: modules managed by `dots` (link, unlink, health) and loaded by the shell.
- `mods_off`: kept in `mods` for their lifecycle, but not loaded at shell startup.

Tweak both per machine in `local.zsh` (gitignored): `mods+=(x)`, `mods_off+=(x)`. `core` is always loaded and not listed.

A module is any subset of:

| File                       | Role                                                                           |
|----------------------------|--------------------------------------------------------------------------------|
| `init.zsh`                 | sourced at shell startup                                                       |
| `<system>.zsh`             | sourced **before** `init.zsh` on that system (`wsl`, `linux`)                   |
| `function.d/`              | autoloaded functions (`load_func <mod>` from `init.zsh`)                       |
| `module.d/link_<mod>`      | function filling `reply` with `src dst` pairs to symlink                        |
| `module.d/install_<mod>`   | `dots link` only: side effects that aren't a symlink                           |
| `module.d/deps`            | binaries the module needs, one per line, checked by `dots health`              |
| `module.d/health_<mod>`    | extra checks run by `dots health`, reporting with `utils/log.zsh`               |

## Systems

`$SYSTEM` is detected in `zshrc`: `wsl` when `$WSL_DISTRO_NAME` is set, otherwise from `$OSTYPE`.
System-wide config lives in `system/<system>/init.zsh` (e.g. the Windows paths `W_HOME`, `W_XDG_*` on WSL).

## WezTerm on WSL

Windows can't follow a WSL symlink. On WSL, `dots link` writes a stub to `%USERPROFILE%\.config\wezterm\wezterm.lua` (the
path `WEZTERM_CONFIG_FILE` points to) that loads this repo's `wezterm/` through `\\wsl.localhost`. Edit the repo, never the stub.
Reload with `Alt+D` then `r` if the change isn't picked up.

## Color theme

One theme everywhere, nordic, with neovim's plugin `nordic.nvim` as the single source, pinned by `nvim/lazy-lock.json`.

- **Copies fetched, never edited**: `dots link` (`wezterm/module.d/install_wezterm`) downloads `platforms/wezterm/nordic.toml` to
  `wezterm/colors/nordic.toml` (the wezterm scheme) and `lua/nordic/colors/nordic.lua` to `wezterm/colors/palette.lua` (read by
  `wezterm/djavrell/colors.lua`), from GitHub at the locked commit. Each starts with a `nordic.nvim <commit>` stamp: `dots link`
  skips a copy already at the lock's commit, and keeps it when the download fails. They are committed, so a fresh clone works
  offline and without neovim.
- **Checked**: `dots health wezterm` checks the stamps against the lock (no network), and that the Claude `palette` mod's built-in
  fallback (`claude/mods/palette/hooks/register.ts`, `FALLBACK`) has the same colors as `colors/nordic.toml`.
- **Following the terminal**: everything drawn with the 16 ANSI colors follows the wezterm scheme by itself: starship, eza, git,
  zsh-autosuggestions, fzf (`--color=16`, `fzf/init.zsh`), bat (`BAT_THEME=ansi`, `git/init.zsh`), delta (`syntax-theme = ansi`,
  `git/gitconfig`) and opencode (`"theme": "system"`). Prefer that mode for a new tool over another copy of the palette.
- **Claude Code** stays on its `dark` theme. The mods (side pane) paint with the `palette` mod, which parses `colors/nordic.toml`.
- **Updating**: after a `:Lazy update` that moves nordic.nvim, commit `lazy-lock.json`, run `dots link`, and review the colors in
  `git diff`; recopy the toml's colors into the mod's `FALLBACK` if `dots health` asks for it.

## Not versioned

`local.zsh` (machine-specific, secrets), Claude credentials, history, memory and work-specific rules/agents.
