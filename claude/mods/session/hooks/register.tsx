// Wiring of the session pane: state, the refreshes that need $, the hooks and the pane's assembly.
// Everything that receives $ or names a $.state atom must live in this file: the validator does not
// follow $ or an atom across an import. Pure helpers sit in lib/, each section's drawing in sections/.
import { atom, read, update } from "claude-code";
import type { EngineInterface, Register } from "claude-code";

import type { ModelInfo, Roots } from "../types";
import { DIFF_ARGS, UNTRACKED_ARGS, parseNumstat, parseUntracked } from "./lib/git";
import { colors } from "./lib/theme";
import type { Colors } from "./lib/theme";
import { displayPath } from "./lib/tree";
import { AgentsSection } from "./sections/agents";
import { FilesSection } from "./sections/files";
import { SkillsSection } from "./sections/skills";
import { StatusSection } from "./sections/status";

// ── state ────────────────────────────────────────────────────────────────────

const files = atom({ plugin: "session", key: "files" } as const, []);
// owned by the agents mod (the single source of the session's agents): read here, never written
const agents = atom({ plugin: "agents", key: "list" } as const, []);
const skills = atom({ plugin: "session", key: "skills" } as const, []);
const info = atom({ plugin: "session", key: "info" } as const, null);
const branch = atom({ plugin: "session", key: "branch" } as const, "");
// bumped on a timer and after each turn so usage, countdown and elapsed time redraw
const tick = atom({ plugin: "session", key: "tick" } as const, 0);
const compactAt = atom({ plugin: "session", key: "compactAt" } as const, null);
const readFiles = atom({ plugin: "session", key: "readFiles" } as const, []);
const roots = atom({ plugin: "session", key: "roots" } as const, null);

const PANE = "session";
const PANE_COLUMNS = 50;
const TICK_MS = 30_000;
const GIT_POLL_MS = 10_000;
const DEBOUNCE_MS = 300;
// ponytail: keeps the last 100 reads; older ones drop off the list
const MAX_READ_FILES = 100;
const WRITERS = new Set(["Edit", "MultiEdit", "Write", "NotebookEdit", "Bash"]);

// bumped by every refresh request: a run that is no longer the latest drops its result
let refreshGeneration = 0;

// ── refreshes ────────────────────────────────────────────────────────────────

async function isPaneOpen($: EngineInterface) {
  return (await $.ui.panes()).some((pane) => pane.id === PANE);
}

async function openPane($: EngineInterface) {
  await $.ui.open({ id: PANE, title: "Session", columns: PANE_COLUMNS });
}

async function refresh($: EngineInterface) {
  const thisGeneration = ++refreshGeneration;
  // ponytail: HEAD fails in a repo without commits; untracked files still show there
  const [diff, untracked] = await Promise.all([
    $.process.run(DIFF_ARGS),
    $.process.run(UNTRACKED_ARGS),
  ]);
  if (thisGeneration !== refreshGeneration) return;
  const changes = diff.exitCode === 0 ? parseNumstat(diff.stdout) : [];
  if (untracked.exitCode === 0) changes.push(...parseUntracked(untracked.stdout));
  await update($, files, () => changes);
}

// coalesces bursts of tool calls into one git run, and skips it while the pane is closed
async function scheduleRefresh($: EngineInterface) {
  const thisGeneration = ++refreshGeneration;
  await $.clock.sleep(DEBOUNCE_MS);
  if (thisGeneration !== refreshGeneration || !(await isPaneOpen($))) return;
  await refresh($);
}

async function refreshBranch($: EngineInterface) {
  const symbolicRef = await $.process.run([
    "git",
    "--no-optional-locks",
    "symbolic-ref",
    "--short",
    "HEAD",
  ]);
  if (symbolicRef.exitCode === 0)
    return update($, branch, () => symbolicRef.stdout.trim());
  // detached HEAD: show the commit instead
  const shortSha = await $.process.run([
    "git",
    "--no-optional-locks",
    "rev-parse",
    "--short",
    "HEAD",
  ]);
  await update($, branch, () =>
    shortSha.exitCode === 0 ? `@${shortSha.stdout.trim()}` : "",
  );
}

async function refreshRoots($: EngineInterface) {
  const [toplevel, home] = await Promise.all([
    $.process.run(["git", "rev-parse", "--show-toplevel"]),
    $.process.run(["printenv", "HOME"]),
  ]);
  const pathRoots: Roots = {
    repo: toplevel.exitCode === 0 ? toplevel.stdout.trim() : "",
    home: home.stdout.trim(),
  };
  await update($, roots, () => pathRoots);
}

// the summary breakdown is estimated locally: no API call
async function refreshCompactAt($: EngineInterface) {
  const { context } = await $.session.usage({ breakdown: "summary" });
  await update(
    $,
    compactAt,
    () => context.breakdown?.autoCompactThreshold ?? null,
  );
}

async function addReadFile($: EngineInterface, absolutePath: string) {
  await update($, readFiles, (paths) =>
    paths.includes(absolutePath)
      ? paths
      : [...paths, absolutePath].slice(-MAX_READ_FILES),
  );
}

async function addSkill($: EngineInterface, name: string) {
  await update($, skills, (skillNames) =>
    skillNames.includes(name) ? skillNames : [...skillNames, name],
  );
}

async function ticker($: EngineInterface) {
  for (;;) {
    await $.clock.sleep(TICK_MS);
    await update($, tick, (tickCount) => tickCount + 1);
  }
}

// git changes made outside Claude (a commit, a checkout in another terminal) raise no event:
// re-read them on a timer while the pane is open
// ponytail: polling; a file watcher if git ever gets slow on a big repo
async function gitPoller($: EngineInterface) {
  for (;;) {
    await $.clock.sleep(GIT_POLL_MS);
    if (!(await isPaneOpen($))) continue;
    await refresh($).catch(() => {});
    await refreshBranch($).catch(() => {});
  }
}

// $.palette is absent for a moment when this mod draws before palette has loaded: default colors then
async function getTheme($: EngineInterface) {
  try {
    return await $.palette.get();
  } catch {
    return undefined;
  }
}

// ── hooks ────────────────────────────────────────────────────────────────────

export const register: Register = (on) => {
  on("session.start", async ($, event, next) => {
    await $.command.register({
      name: "session",
      description: "Toggle the session pane: agents, skills, changed files",
    });
    void refresh($).catch(() => {});
    void refreshBranch($).catch(() => {});
    void refreshRoots($).catch(() => {});
    void refreshCompactAt($).catch(() => {});
    void ticker($).catch(() => {});
    void gitPoller($).catch(() => {});
    void openPane($).catch(() => {});

    return next(event);
  });

  on("command.run", { command: "session" }, async ($) => {
    if (await isPaneOpen($)) {
      await $.ui.close({ id: PANE });

      return { text: "Session pane closed." };
    }
    await refresh($).catch(() => {});
    await openPane($);

    return { text: "Session pane opened." };
  });

  on("tool.call", async ($, event, next) => {
    const result = await next(event);
    if (event.tool === "Skill" && typeof event.skill === "string")
      void addSkill($, event.skill).catch(() => {});
    if (event.tool === "Read" && typeof event.file_path === "string")
      void addReadFile($, event.file_path).catch(() => {});
    if (WRITERS.has(event.tool)) void scheduleRefresh($).catch(() => {});
    // a checkout/switch goes through Bash
    if (event.tool === "Bash") void refreshBranch($).catch(() => {});

    return result;
  });

  on("turn.step", async function* ($, event, next) {
    if (!event.agentId) {
      const stepModel: ModelInfo = {
        model: event.model.replace(/^claude-/, ""),
        effort: event.effort === undefined ? undefined : String(event.effort),
      };
      void update($, info, () => stepModel).catch(() => {});
    }

    return yield* next(event);
  });

  on("turn.complete", async ($, event, next) => {
    const result = await next(event);
    if (!event.agentId) {
      void update($, tick, (tickCount) => tickCount + 1).catch(() => {});
      // the threshold moves with the model (/model) and the settings
      void refreshCompactAt($).catch(() => {});
    }

    return result;
  });

  // skill.prompt did not fire in a live session on 2.1.291: Skill tool calls and typed
  // /name commands are caught above and here instead
  on("skill.prompt", async ($, event, next) => {
    void addSkill($, event.skill).catch(() => {});

    return next(event);
  });

  // ponytail: any user/plugin command counts as a skill, the engine does not tell them apart
  on("command.run", async ($, event, next) => {
    const result = await next(event);
    if (event.command !== "session") {
      const commandInfo = (await $.command.list()).find(
        (command) => command.name === event.command,
      );
      if (
        commandInfo &&
        (commandInfo.source === "user" || commandInfo.source === "plugin")
      )
        await addSkill($, event.command).catch(() => {});
    }

    return result;
  });

  // ── pane ───────────────────────────────────────────────────────────────────

  on("ui.render", { component: "Pane", requestId: PANE }, async ($, event) => {
    const ui = $.ui.resolve(event);
    const { Box, Text } = ui;
    await read($, tick);
    const [
      changedFiles,
      agentList,
      skillList,
      readFileList,
      pathRoots,
      modelInfo,
      branchName,
      compactTokens,
      usage,
      nowMs,
      theme,
    ] = await Promise.all([
      read($, files),
      read($, agents),
      read($, skills),
      read($, readFiles),
      read($, roots),
      read($, info),
      read($, branch),
      read($, compactAt),
      $.session.usage(),
      $.clock.now(),
      getTheme($),
    ]);
    const color: Colors = theme ? colors(theme) : {};
    const readPaths = readFileList.map((absolutePath) =>
      displayPath(absolutePath, pathRoots),
    );
    // docked, fill the pane's height so the grown top block pushes Status to the bottom
    const minHeight =
      event.props.placement === "dock" ? event.props.scroll.bodyRows : undefined;

    return (
      <Box
        flexDirection="column"
        minHeight={minHeight}
        backgroundColor={theme?.background}
      >
        <Box flexDirection="column" flexGrow={1}>
          {AgentsSection({
            ui,
            color,
            agentList,
            bodyColumns: event.props.bodyColumns,
          })}
          <Text> </Text>
          {SkillsSection({ ui, skillList })}
          <Text> </Text>
          {FilesSection({ ui, color, changedFiles, readPaths })}
          <Text> </Text>
        </Box>
        {StatusSection({
          ui,
          color,
          modelInfo,
          branchName,
          usage,
          nowMs,
          compactTokens,
          bodyColumns: event.props.bodyColumns,
        })}
      </Box>
    );
  });
};
