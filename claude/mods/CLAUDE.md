# Claude Code mods

Mods are plugins of function hooks that run inside Claude Code (panes, bands, status, hooks on tools and prompts). Each folder here is one
mod. The API reference is the `plugin-authoring` skill (load it before writing a mod) and the typings Claude Code lays in each mod's
`.claude-plugin/types/` on load: grep `claude-code/index.d.ts` for the name at hand, never read it whole (~15k lines).

## Loading

- `claude/init.zsh` builds `CLAUDE_CODE_PLUGIN_DIRS` from every folder in `claude/mods/`, so a new mod loads from the next **new shell**;
  the current session keeps the list it started with.
- A loaded mod folder is watched: saving a file reloads the mod in the running session.
- `.claude-plugin/types/` is generated on load and gitignored; `tsconfig.json` is generated too and extends it.

## Mods and how they fit

| Mod         | Role                                                                                                         |
|-------------|--------------------------------------------------------------------------------------------------------------|
| `palette`   | Shares the terminal theme: `$.palette.get()` parses `wezterm/colors/nordic.toml`, built-in copy as fallback. |
| `agents`    | Single source of the session's agents: history (last 30), parent, model, steps, end; `agents.list` state.    |
| `session`   | The side pane (`/session` toggles it, opens on start): main agent and its subagents, Skills, Files, Context. |
|             | `/context-icons` lists what the Context legend's icons stand for. Consumer only.                             |
| `pr-viewer` | The branch's pull request via `gh` (polled each minute and on a branch switch): `pr-viewer.current` state,   |
|             | drawn as one line in the band above the prompt (state, CI, review). No pull request, no band.                |
| `lsp-first` | Refuses a shell grep on code symbols and a shell write to a source file, retries cclsp's "No Project" cold   |
|             | start, folds LSP-first refusals (its own and the classic hooks') to one line. Runs above the classic hooks.  |

Architecture rule: **data sources publish state, consumers draw.** A mod that collects data (agents, later files or status) owns that
state and its types; a consumer lists it under `dependencies` in `plugin.json` and reads it with
`read($, atom({ plugin: "<source>", key: "<key>" } as const, <initial>))`. The consumer redraws when the source writes (verified).
This keeps one source of truth that a pane, a band or a toast can all read. Split a domain out of `session` only once a second consumer
exists, not for its own sake.

Inside `session/hooks/`: `register.tsx` wires state, `$` calls and hooks; `lib/` holds pure helpers (git, tree, format, icons, theme);
`components/` holds reusable drawing bricks (`Meter`, the `▰▱` gauge used by the steps and effort bars: glyphs live there only);
`sections/` assembles them into the pane's sections. A component takes `Box`/`Text` and data, never `$`, and is called as a function.

## API constraints learned the hard way

- **`$` and atoms stay in the hooks module file.** The validator refuses `$` passed to a function imported from another file, and an
  atom imported from another file. Pure code (formatting, parsing, trees, icons) and section components can live in other files; give
  a component `Box`/`Text` (`$.ui.resolve(event)`) and data, never `$`.
- `$` is always spelled `$.noun.method(...)`: no `$?.`, no `$` stored or passed around except to top-level functions of the same file.
- **Imports stay inside the mod's folder**: an import outside it is refused, and so is a symlink to a shared file. Code shared between
  mods has to be a service on `$` (like `palette`).
- **Serving a noun** (`$.palette`): add it in `engine.create` with a bottom implementation, and answer calls with
  `on("<noun>.<method>", async ($) => ({ value }))`. A served hook must return `{ value }`, not the bare value. The `$` that
  `engine.create`'s `next(event)` returns cannot be captured for later calls.
- **Rendering a tree in another mod's pane** works only by faking a render event for `$.ui.resolve`. Undocumented: do not build on it.
- `skill.prompt` never fired in a live session (2.1.291 and 2.1.292): skills are caught via `tool.call` on `Skill` and `command.run`.
- `SessionMode` renders the footer's small labels (`focus`, `memory paused`), not the permission mode. The permission mode is only on
  classic hook inputs (`permission_mode`); it was dropped from the pane anyway, the footer already shows it.
- The classic `Stop` hook's `background_tasks` did not show up in practice; the footer shows background tasks anyway.
- **Panes**: opened from `session.start` (unasked) a pane needs ≥ 144 columns, ≥ 110 if the person opened it before. Docked,
  `scroll.bodyRows` excludes the frame's last row, which Claude Code paints itself: a background color cannot reach it.
- `claude plugin test` cannot call another mod's served noun: tests cover the pure helpers in `lib/` only.

## Working on a mod

- Entry points from any directory: the `mods` skill (`/mods`, `claude/skills/mods/`) loads this file and the workflow into a
  session; the `mod-dev` agent (`claude/agents/mod-dev.md`) takes a delegated task, or a whole session with `claude --agent mod-dev`.
  Both are linked into `~/.claude/`. Knowledge goes here, the procedure in the skill, nothing in the agent.
- Checks: `claude plugin validate <mod>`, `claude plugin test <mod>`, `npx -p typescript tsc -p <mod>`.
- In **auto mode**, the classifier gives no verdict on Edit/Write under `claude/mods/` (hard failure, even with the
  `Edit(~/.bashrc.d/claude/mods/**)` allow rule): edit a copy outside (scratchpad, or `~/.claude/dev-mods/<session>/`), check it, then
  `cp` it back. In manual mode, edits there go through directly.
- Style: descriptive names (no one-letter variables), the formatting already in the file (double quotes and semicolons in `session`),
  colors through `palette` roles rather than raw names, Nerd Font glyphs for icons.

## History (removed, kept for reference)

- The shell status line (`claude/statusline-command.sh`) is disabled in `settings.json`; the script is kept. Its content moved to the
  pane's Status section.
- A `statusbar` band above the prompt was tried and dropped in favour of the pane.
