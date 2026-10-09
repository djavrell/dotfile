# Dotfiles

Zsh dotfiles for WSL (Arch) and native Linux, organised in modules. `README.md` is the user's guide (bootstrap, the module files
table, systems, WezTerm on WSL): read it for the basics, this file adds what Claude needs to work here safely. The Claude Code mods
in `claude/mods/` have their own guide, `claude/mods/CLAUDE.md`.

## Safety first

- **`local.zsh` holds live secrets** (API keys, a database URL with its password). It is gitignored: never print, quote, `cat`,
  commit or `git add -f` it. Read it only when a task needs its non-secret lines, and never echo a value.
- **The `*work*` and `*private*` gitignore patterns** silently ignore any file whose name contains them (`worktree`, `network`):
  check `git status` after creating such a file.
- **Linked files are live.** `dots link` symlinks repo files into place: editing `claude/settings.json`, `git/gitconfig*` or
  `nvim/` changes the running config at once. Never touch `claude/settings.json` without the user's explicit consent.
- **WezTerm on WSL**: `install_wezterm` writes a generated stub on the Windows side. Edit the repo, never the stub.
- Never delete a file or a feature unasked, never `dots unlink` unasked, never commit unless asked.

## How the shell boots

1. `~/.zshrc` -> `zshrc`: XDG vars, `DOTFILE=$HOME/.bashrc.d`, `SYSTEM` (`wsl` when `$WSL_DISTRO_NAME` is set, else `linux`,
   `darwin`), `SYSFILE=system/$SYSTEM`, history, `path`; then `load_func core` and `module zsh`.
2. `zsh/init.zsh`: `load_func zsh`, options, the 3 zsh submodules, `modules.zsh`, `local.zsh`, `$SYSFILE/init.zsh`,
   `osc-integration.sh`, then `module <mod>` for every module in `mods` minus `mods_off` (zsh excepted), then aliases and bindings.
3. Back in `zshrc`: `compinit` (full rebuild once a day or on a zsh version change, else `compinit -C`).

Startup time matters: tools are evaled through `check_eval` (only when installed) and heavy ones are lazy-loaded (conda in
`python/init.zsh`). Do not add a synchronous external call to a module's `init.zsh` without saying what it costs.

## Modules

A module is a top-level folder named after its tool; every file in it is optional. `modules.zsh` lists them (`mods`, `mods_off`);
`local.zsh` can add or turn some off per machine. `core` is always loaded and is not listed.

- `init.zsh`, sourced at startup; `<system>.zsh` (`wsl.zsh`, `linux.zsh`) sourced just before it.
- `function.d/`: one function per file, autoloaded once `init.zsh` calls `load_func <mod>`.
- `module.d/deps`: binary names, one per line, checked by `dots health`.
- `module.d/link_<mod>`: defines `link_<mod>()`, which sets `reply=(src dst src dst ...)`; it may branch on `$SYSTEM`.
- `module.d/install_<mod>`: defines `install_<mod>()`, run by `dots link` for side effects that are no symlink.
- `module.d/health_<mod>`: defines `health_<mod>()`, reports with the log helpers, returns non-zero on failure.

```zsh
# vim: ft=zsh
function link_lua() {
  reply=(
    "$DOTFILE/lua/stylua.toml" "$XDG_CONFIG_HOME/stylua.toml"
  )
}
```

Helpers from `core/function.d/`: `load <file>` (source if it exists), `module <mod>`, `load_func <dir>`; `check_eval <cmd> <args>`
(from `zsh/function.d/`) evals a tool's init output only when the tool is installed.

### `bin/dots`

- `dots link`: for each module, symlinks its pairs. Already right: skipped (idempotent). Anything else at the destination is moved to
  `<dst>.bak-YYYYmmddHHMMSS` first. Then it runs `install_<mod>`.
- `dots unlink`: removes a destination only when it is a symlink into the repo; backups are not restored.
- `dots health [mod...]`: changes nothing; checks deps, links and `health_<mod>`, returns 1 if anything failed.

## Conventions

- First line of a zsh file without an extension: `# vim: ft=zsh`.
- Comments in English, short, saying why (often with the measured cost). User-facing messages of `dots` and health checks are in
  French, through the helpers of `utils/log.zsh`: `log_header`, `log_topic`, `log_info`, `log_skip`, `log_success`, `log_warn`,
  `log_error`.
- Errors: `log_error` then `return 1`, or a `fail=1` accumulated to the end.
- Zsh idioms over external tools: `(( $+commands[x] ))`, `${path:A}`, `${path:h}`, `${(f)text}`, `local` in functions, `unset`
  after a top-level loop, double-quoted `"$DOTFILE/..."` paths.
- Descriptive names, never one-letter variables, shell included.
- A deliberate shortcut gets a `ponytail:` comment naming its ceiling and the way up.
- Commit messages: `[module] lowercase summary`, several modules as `[zsh][wezterm] ...`.

## Checking a change

No tests, no CI. After a change:

- `zsh -n <file>` on every zsh file touched (syntax only);
- `dots health <mod>` for the module touched;
- `dots link` when a `link_<mod>` changed (it also runs every `install_<mod>`);
- the user reloads the shell (`exec zsh`, alias `s`) to try it: say what to look at.
