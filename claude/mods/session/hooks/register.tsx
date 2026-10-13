// Wiring of the session pane: state, the refreshes that need $, the hooks and the pane's assembly.
// Everything that receives $ or names a $.state atom must live in this file: the validator does not
// follow $ or an atom across an import. Pure helpers sit in lib/, each section's drawing in sections/.
import { atom, read, update } from "claude-code";
import type { EngineInterface, Register } from "claude-code";

import type { ContextInfo, ModelInfo } from "../types";
import { visibleAgents } from "./lib/agentTree";
import { cacheReadPercent } from "./lib/format";
import {
  DIFF_ARGS,
  UNTRACKED_ARGS,
  parseNumstat,
  parseUntracked,
} from "./lib/git";
import { AgentsSection } from "./sections/agents";
import { CONTEXT_LEGEND, ContextSection } from "./sections/context";
import { FilesSection } from "./sections/files";
import { SkillsSection } from "./sections/skills";
import { MainAgentCard } from "./sections/mainAgent";

// ── state ────────────────────────────────────────────────────────────────────

const files = atom({ plugin: "session", key: "files" } as const, []);
// owned by the agents mod (the single source of the session's agents): read here, never written
const agents = atom({ plugin: "agents", key: "list" } as const, []);
const skills = atom({ plugin: "session", key: "skills" } as const, []);
const info = atom({ plugin: "session", key: "info" } as const, null);
// bumped on a timer and on each measure (turn, rate-limit move) so usage, countdown and elapsed time redraw
const tick = atom({ plugin: "session", key: "tick" } as const, 0);
const context = atom({ plugin: "session", key: "context" } as const, null);
const collapsedFolders = atom(
  { plugin: "session", key: "collapsedFolders" } as const,
  [],
);

const PANE = "session";
const PANE_COLUMNS = 70;
const TICK_MS = 10_000;
// a finished agent stays in the pane this long after it ended, then leaves on the next tick
const FINISHED_AGENT_KEEP_MS = 30_000;
const GIT_POLL_MS = 10_000;
const DEBOUNCE_MS = 300;
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
  if (untracked.exitCode === 0)
    changes.push(...parseUntracked(untracked.stdout));
  await update($, files, () => changes);
}

// coalesces bursts of tool calls into one git run, and skips it while the pane is closed
async function scheduleRefresh($: EngineInterface) {
  const thisGeneration = ++refreshGeneration;
  await $.clock.sleep(DEBOUNCE_MS);
  if (thisGeneration !== refreshGeneration || !(await isPaneOpen($))) return;
  await refresh($);
}

// the summary breakdown is estimated locally: no API call
async function refreshContext($: EngineInterface) {
  const { breakdown } = (await $.session.usage({ breakdown: "summary" }))
    .context;
  if (!breakdown) return;
  const contextInfo: ContextInfo = {
    slices: breakdown.categories.map(({ name, tokens, kind }) => ({
      name,
      tokens,
      kind,
    })),
    maxTokens: breakdown.maxTokens,
    compactAt: breakdown.autoCompactThreshold ?? null,
    cacheReadPercent: breakdown.apiUsage
      ? cacheReadPercent(breakdown.apiUsage)
      : null,
  };
  await update($, context, () => contextInfo);
}

async function addSkill($: EngineInterface, name: string) {
  await update($, skills, (skillNames) =>
    skillNames.includes(name) ? skillNames : [...skillNames, name],
  );
}

// ponytail: a folded folder stays listed once its files are committed; harmless, the list stays tiny
async function toggleFolder($: EngineInterface, folderPath: string) {
  await update($, collapsedFolders, (folderPaths) =>
    folderPaths.includes(folderPath)
      ? folderPaths.filter((path) => path !== folderPath)
      : [...folderPaths, folderPath],
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
    await $.command.register({
      name: "context-icons",
      description:
        "What the icons of the session pane's Context legend stand for",
    });
    void refresh($).catch(() => {});
    void refreshContext($).catch(() => {});
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

  on("command.run", { command: "context-icons" }, async () => ({
    text: CONTEXT_LEGEND,
  }));

  on("tool.call", async ($, event, next) => {
    const result = await next(event);
    if (event.tool === "Skill") void addSkill($, event.skill).catch(() => {});
    if (WRITERS.has(event.tool)) void scheduleRefresh($).catch(() => {});

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

  // after each main-thread turn and when a rate-limit window moves: usage, countdown and elapsed time redraw
  on("session.measure", async ($, event, next) => {
    void update($, tick, (tickCount) => tickCount + 1).catch(() => {});
    // the messages grow each turn; the threshold moves with the model (/model) and the settings
    if (event.changed.includes("context"))
      void refreshContext($).catch(() => {});

    return next(event);
  });

  // a compaction is no turn: re-read the shrunk context once it is done
  on("session.compact", async ($, event, next) => {
    const result = await next(event);
    if (!event.agentId) void refreshContext($).catch(() => {});

    return result;
  });

  // skill.prompt did not fire in a live session on 2.1.291: Skill tool calls and typed
  // /name commands are caught above and here instead
  on("skill.prompt", async ($, event, next) => {
    void addSkill($, event.skill).catch(() => {});

    return next(event);
  });

  // ponytail: any user/plugin command outside this mod counts as a skill, the engine does not tell them apart
  on("command.run", async ($, event, next) => {
    const result = await next(event);
    const commandInfo = (await $.command.list()).find(
      (command) => command.name === event.command,
    );
    if (
      commandInfo &&
      commandInfo.plugin !== "session" &&
      (commandInfo.source === "user" || commandInfo.source === "plugin")
    )
      void addSkill($, event.command).catch(() => {});

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
      modelInfo,
      contextInfo,
      foldedFolders,
      usage,
      nowMs,
      theme,
    ] = await Promise.all([
      read($, files),
      read($, agents),
      read($, skills),
      read($, info),
      read($, context),
      read($, collapsedFolders),
      $.session.usage(),
      $.clock.now(),
      getTheme($),
    ]);
    // docked, fill the pane's height so the grown top block pushes Context to the bottom
    const minHeight =
      event.props.placement === "dock"
        ? event.props.scroll.bodyRows
        : undefined;

    return (
      <Box
        flexDirection="column"
        minHeight={minHeight}
        backgroundColor={theme?.background}
      >
        <Box flexDirection="column" flexGrow={1}>
          {MainAgentCard({ ui, theme, modelInfo, contextInfo, usage, nowMs })}
          {AgentsSection({
            ui,
            theme,
            agentList: visibleAgents(agentList, nowMs, FINISHED_AGENT_KEEP_MS),
            bodyColumns: event.props.bodyColumns,
          })}
          <Text> </Text>
          {SkillsSection({ ui, skillList })}
          <Text> </Text>
          {FilesSection({
            ui,
            theme,
            changedFiles,
            collapsedFolders: new Set(foldedFolders),
            onToggleFolder: (folderPath) =>
              void toggleFolder($, folderPath).catch(() => {}),
          })}
          <Text> </Text>
        </Box>
        {ContextSection({
          ui,
          theme,
          contextInfo,
          usage,
          bodyColumns: event.props.bodyColumns,
        })}
      </Box>
    );
  });
};
