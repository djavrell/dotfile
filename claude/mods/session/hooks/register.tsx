// Wiring of the session pane: the small state left here (skills, model, tick), the hooks and the pane's assembly.
// Each domain's atoms live in state/ with their read/update calls (the validator wants them in one file), reached
// through function declarations that take $. Pure helpers sit in lib/, each section's drawing in sections/.
import { atom, read, update } from "claude-code";
import type { EngineInterface, Register, Timer } from "claude-code";

import type { ModelInfo } from "../types";
import { childCounts, visibleAgents } from "./lib/agentTree";
import { AgentsSection } from "./sections/agents";
import { BranchSection } from "./sections/branch";
import { CONTEXT_LEGEND, ContextSection } from "./sections/context";
import { FilesSection } from "./sections/files";
import { McpSection } from "./sections/mcp";
import { SkillsSection } from "./sections/skills";
import { MainAgentCard } from "./sections/mainAgent";
import { readContext, refreshContext } from "./state/context";
import {
  GIT_POLL_MS,
  WRITERS,
  pollGit,
  readFiles,
  refresh,
  scheduleRefresh,
  toggleFolder,
} from "./state/files";
import { PANE, isPaneOpen, openPane } from "./state/pane";

// ── state ────────────────────────────────────────────────────────────────────

// owned by the agents mod (the single source of the session's agents): read here, never written
const agents = atom({ plugin: "agents", key: "list" } as const, []);
// owned by git-provider (it polls gh): read here, never written
const pullRequestState = atom({ plugin: "git-provider", key: "current" } as const, null);
const branchState = atom({ plugin: "git-provider", key: "branch" } as const, null);
// owned by mcp-status (it checks the servers and follows their calls): read here, never written
const mcpServers = atom({ plugin: "mcp-status", key: "servers" } as const, []);
const skills = atom({ plugin: "session", key: "skills" } as const, []);
const info = atom({ plugin: "session", key: "info" } as const, null);
// bumped on a timer and on each measure (turn, rate-limit move) so usage, countdown and elapsed time redraw
const tick = atom({ plugin: "session", key: "tick" } as const, 0);

const TICK_MS = 10_000;
// the tick and git poll timers, cancelled when a new session.start starts others
let tickTimer: Timer | undefined;
let gitPollTimer: Timer | undefined;
// a finished agent stays in the pane this long after it ended, then leaves on the next tick
const FINISHED_AGENT_KEEP_MS = 30_000;

// ── refreshes ────────────────────────────────────────────────────────────────

async function addSkill($: EngineInterface, name: string) {
  await update($, skills, (skillNames) =>
    skillNames.includes(name) ? skillNames : [...skillNames, name],
  );
}

async function bumpTick($: EngineInterface) {
  await update($, tick, (tickCount) => tickCount + 1);
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
    tickTimer?.cancel();
    tickTimer = $.clock.every(
      TICK_MS,
      () => void bumpTick($).catch(() => {}),
    );
    gitPollTimer?.cancel();
    gitPollTimer = $.clock.every(
      GIT_POLL_MS,
      () => void pollGit($).catch(() => {}),
    );
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
      [changedFiles, foldedFolders],
      agentList,
      skillList,
      modelInfo,
      contextInfo,
      usage,
      nowMs,
      theme,
      pullRequest,
      branchName,
      serverList,
    ] = await Promise.all([
      readFiles($),
      read($, agents),
      read($, skills),
      read($, info),
      readContext($),
      $.session.usage(),
      $.clock.now(),
      getTheme($),
      read($, pullRequestState),
      read($, branchState),
      read($, mcpServers),
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
          {MainAgentCard({
            ui,
            theme,
            modelInfo,
            contextInfo,
            usage,
            nowMs,
            // a refused switch ({ deny }) changes nothing: ignored
            onViewMain: () => void $.ui.view({}).catch(() => {}),
          })}
          {AgentsSection({
            ui,
            theme,
            agentList: visibleAgents(agentList, nowMs, FINISHED_AGENT_KEEP_MS),
            subagentCounts: childCounts(agentList),
            nowMs,
            bodyColumns: event.props.bodyColumns,
            viewedAgentId: event.props.view?.agentId,
            onViewAgent: (agentId) =>
              void $.ui.view({ agentId }).catch(() => {}),
          })}
          <Text> </Text>
          {SkillsSection({ ui, skillList })}
          <Text> </Text>
          {McpSection({ ui, theme, serverList })}
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
        {BranchSection({ ui, theme, branchName, pullRequest })}
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
