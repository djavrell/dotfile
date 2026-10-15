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

| Mod               | Role                                                                                                         |
|-------------------|--------------------------------------------------------------------------------------------------------------|
| `palette`         | Shares the terminal theme: `$.palette.get()` parses `wezterm/colors/nordic.toml`, built-in copy as fallback. |
| `agents`          | Single source of the session's agents: history (last 30), parent, model, steps, end; `agents.list` state.    |
| `session`         | The side pane (`/session` toggles it, opens on start): main agent and its subagents, Skills, Files, Context. |
|                   | `/context-icons` lists what the Context legend's icons stand for. Consumer only.                             |
| `pr-viewer`       | The branch's pull request via `gh` (polled each minute and on a branch switch): `pr-viewer.current` state,   |
|                   | drawn as one line in the band above the prompt (state, CI, review). No pull request: the branch.             |
| `lsp-first`       | Refuses a shell grep on code symbols and a shell write to a source file, retries cclsp's "No Project" cold   |
|                   | start, folds its own refusals to one line. Runs above the classic hooks.                                     |
| `fold-transcript` | Folds Bash and Agent results and agents' reports in the transcript to one line, `[+]`/`[−]` to toggle (a     |
|                   | click, fullscreen). Drawing only: the model reads them whole.                                                |
| `diagnostics`     | Cuts the language server's new-diagnostics list before the model reads it: 400 chars a line, 20k in all (a   |
|                   | typera/zod type error once spelled out 5.6M chars).                                                          |

Architecture rule: **data sources publish state, consumers draw.** A mod that collects data (agents, later files or status) owns that
state and its types; a consumer lists it under `dependencies` in `plugin.json` and reads it with
`read($, atom({ plugin: "<source>", key: "<key>" } as const, <initial>))`. The consumer redraws when the source writes (verified).
This keeps one source of truth that a pane, a band or a toast can all read. Split a domain out of `session` only once a second consumer
exists, not for its own sake.

**Colors belong to `palette`.** Every color definition and every computed color (a mix, a dim look as a plain color, a theme
fallback) lives in `palette` and is published on `PaletteTheme`. A consumer only picks which published color paints what (a status's
role, a threshold band); it never hardcodes a hex nor computes a color. A color is named by its palette path (`PaletteColorPath`:
`ansi.blue`, `brights.yellow`, `comment`), never through an alias or a flat copy of the theme. The one exception is `paint(theme, path)`
in `session/hooks/lib/theme.ts`, a lookup only: a mod cannot import another's code, and a `$.palette` call is async, unusable mid-draw.

Inside `session/hooks/`: `register.tsx` wires the hooks and the pane; `state/` holds each domain's atoms with their `$` calls (`pane`,
`files`, `context`), as function declarations that take `$`; `lib/` holds pure helpers (git, tree, format, icons, theme), no `atom`;
`components/` holds reusable drawing bricks (`Meter`, the `▰▱` gauge used by the steps and effort bars: glyphs live there only);
`sections/` assembles them into the pane's sections. A component takes `Box`/`Text` and data, never `$`, and is called as a function.

## API constraints learned the hard way

- **`$` crosses files only into a function declaration** (since 2.1.299, probed with `validate` and `test`): a hook may pass `$` to
  `export async function f($: EngineInterface)` from another file of the mod, and on from there (`lib/a` -> `lib/b`). An imported
  arrow (`const f = async ($) => ...`) is refused.
- **An atom stays in the file that reads and writes it**: `atom(...)` and its `read`/`update` calls must share a file, which may be a
  `lib/` file the hook hands `$` to. An atom imported alone, then updated in `register`, is refused.
- Pure code (formatting, parsing, trees, icons) and section components live in other files freely; give a component `Box`/`Text`
  (`$.ui.resolve(event)`) and data, never `$`.
- `$` is always spelled `$.noun.method(...)`: no `$?.`, never stored (a module variable holding `$` is refused), only passed as an
  argument to a function declaration.
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
- `claude plugin test` cannot call another mod's served noun. It can drive a mod's own hooks: the test's `on` hooks sit beneath the
  plugin, so a fake `tool.call` answer plus `on("mcp.call", () => ({ value }))` let `$.tool.call(...)` run a hook end to end (`lsp-first`).
  A test's `$` has no `$.state`, no `$.env.get`, and not even the mod's own served noun: a noun such as `$.palette` comes from an
  inline plugin that adds it in `engine.create`. `$.ui.mount` renders a pane, so a test can check a redraw (`session/tests/pane.test.ts`).
- `validate` shows a hook's filter as `?` when its value is imported (`requestId=?` for an imported `PANE`): display only, the hook
  still matches.
- **Refresh events**: `session.measure` fires after each main-thread turn and when a rate-limit window moves, with
  `changed: ('context'|'rateLimits'|'cost')[]`; a compaction is no turn, hence a `session.compact` hook (`session`).
- **Timers and cwd**: `$.clock.every(ms, fn)` returns a cancelable `Timer`, use it over a `sleep` loop that outlives its hook.
  `$.process.run` runs in the session's cwd, which `/cd` (a `command.run` with `command: "cd"`) and worktrees move (`pr-viewer`).
- **The `types` contract must be self-contained**: no `import` in `types/index.d.ts`, not even a type from `claude-code`; copy the
  union inline (as `ContextSlice.kind` does).
- **Tool calls** (`tool.call`): plugin hooks run above the classic `PreToolUse` hooks, and fire for subagents' calls too (`agentId`).
  A hook answers `{ deny }`, `{ result }` (in place of the tool) or `next(e)`; `context` on the answer is a reminder the model
  reads. A classic hook's `systemMessage` reaches the user only, never the model. `next(e)` twice replays the first run, it never
  runs the tool again: retry through `$.mcp.call` instead (`lsp-first`). A guard with no `.catch` fails open; `validate` warns.
- This build offers the model no `Grep`/`Glob` tool: searches go through `Bash`, so a guard has to read the shell command.
- **Context**: `$.session.usage({ breakdown: "summary" })` is free, `"full"` calls the token-count API. Its `gridRows` is a fixed
  10x10 (or 20x10) grid: draw your own from `categories`. Branch on a row's `kind`; its `name` (`MCP server instructions`, ...) only
  for cosmetics, with a fallback for an unknown one.
- `ui.render` on `ToolResult` redraws a call's result (the refusal text is `output` when `isErrored`); `AbovePrompt` must pass
  (`next(e)`) while `hasSurvey`. `Box` takes `borderStyle="round"` and `overflow="hidden"`.
- **Tool rows** (seen live, not in the typings): Bash raises no `ToolResult`, its output is drawn inside its `ToolUse` row;
  Agent and Edit do raise one (`fold-transcript`).
- **`UserMessage.isExpanded`** is true in ctrl+o but also for any body short enough to fit under the sender's label. An agent's
  report comes as `origin.kind: "peer"` with `from.name` (the agent type), then a `task-notification` row.
- **Clicks in the transcript**: a `Button` in a transcript row works in fullscreen; its `onPress` updates an atom and the row
  redraws (`fold-transcript`).
- **Switching the main view** (2.1.300): `$.ui.view({ agentId })` from a pane `Button`'s `onPress` shows that agent's transcript,
  `$.ui.view({})` the main one; outside the person's own input it answers `{ deny }`. The pane reads the view in force as
  `e.props.view` (`session`).
- A command's text output is shown prefixed with `<plugin>:`.
- **The language server's new errors** come as a `diagnostics` attachment: `prompt.attachment` with `{ type: "diagnostics" }`
  rewrites what the model reads (`diagnostics`), but no render component draws it (probed live): Claude Code shows it as one line,
  ctrl+o unrolls it, and no mod can fold it.
- A `prompt.attachment` answer seems kept per attachment for the process: after a reload the hook did not fire again on the
  attachments it had already answered.
- Nerd Font glyphs vanish from Claude's own messages and from the copy of a command output Claude reads, yet render for the user:
  do not conclude a glyph is broken from that. A glyph missing from the user's font draws as a box; an unknown category drew one.

## Working on a mod

- Entry points from any directory: the `mods` skill (`/mods`, `claude/skills/mods/`) loads this file and the workflow into a
  session; the `mod-dev` agent (`claude/agents/mod-dev.md`) takes a delegated task, or a whole session with `claude --agent mod-dev`.
  Both are linked into `~/.claude/`. Knowledge goes here, the procedure in the skill, nothing in the agent.
- Checks: `claude plugin validate <mod>`, `claude plugin test <mod>`, `npx -p typescript tsc -p <mod>`.
- **Stale typings**: an older Claude Code session still open rewrites `.claude-plugin/types/` when a mod reloads (`validate` does
  not). Before trusting a `tsc` error on a recent API, read the version on `index.d.ts`'s first line; copy a current mod's file over.
- **Live test without a new shell**: once the `plugin-authoring` skill is loaded, a mod written under `~/.claude/dev-mods/<session>/`
  hot-reloads in the session after one "Enable hot reloading" question. Copy it to `claude/mods/` once it works.
- In **auto mode**, the classifier gives no verdict on Edit/Write under `claude/mods/` (hard failure, even with the
  `Edit(~/.bashrc.d/claude/mods/**)` allow rule): edit a copy outside (scratchpad, or `~/.claude/dev-mods/<session>/`), check it, then
  `cp` it back. In manual mode, edits there go through directly. Go straight to the copy: a `sed` on a mod's source file first
  gets refused by `lsp-first`, and the classifier then reads the copy-back as a way around that refusal and denies it too.
- Edit cannot match a passage holding a Nerd Font glyph (the glyph vanishes from what Claude reads): anchor on glyph-free lines,
  and write a new icon as an escape (`""`) with its name in a comment.
- Style: descriptive names (no one-letter variables), the formatting already in the file (double quotes and semicolons in `session`),
  colors through `palette` roles rather than raw names, Nerd Font glyphs for icons.

## History (removed, kept for reference)

- The shell status line (`claude/statusline-command.sh`) is disabled in `settings.json`; the script is kept. Its content moved to the
  pane's Status section.
- A `statusbar` band above the prompt was tried and dropped in favour of the pane.
