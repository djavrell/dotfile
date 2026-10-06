import { atom, read, update } from "claude-code";
import type { EngineInterface, Register } from "claude-code";

import type { PaletteTheme } from "palette";

import type { Agent, Change, ModelInfo } from "../types";

const PANE = "session";
const files = atom({ plugin: "session", key: "files" } as const, []);
const agents = atom({ plugin: "session", key: "agents" } as const, []);
const skills = atom({ plugin: "session", key: "skills" } as const, []);
const info = atom({ plugin: "session", key: "info" } as const, null);
const branch = atom({ plugin: "session", key: "branch" } as const, "");
// bumped on a timer and after each turn so usage, countdown and elapsed time redraw
const tick = atom({ plugin: "session", key: "tick" } as const, 0);
const compactAt = atom({ plugin: "session", key: "compactAt" } as const, null);
// share of the auto-compaction threshold past which the context line warns
const COMPACT_WARN = 0.9;
const TICK_MS = 30_000;
const MIN_BAR = 4;
const MAX_BAR = 16;
// the colors this pane paints with, from the terminal theme the palette mod shares
const colors = (paletteTheme: PaletteTheme) => ({
  ...paletteTheme.ansi,
  yellowBright: paletteTheme.brights.yellow,
  gray: paletteTheme.comment,
});
type Role = keyof ReturnType<typeof colors>;
const EFFORT_COLOR: Record<string, Role> = {
  max: "magenta",
  xhigh: "magenta",
  high: "cyan",
};

// thresholds of statusline-command.sh: green < 50 <= yellow < 80 <= red
const band = (percent: number): Role =>
  percent >= 80 ? "red" : percent >= 50 ? "yellow" : "green";

// countdown scaled to the window: days for 7d, bare minutes when imminent
const fmtLeft = (seconds: number) => {
  if (seconds >= 86400)
    return `${Math.floor(seconds / 86400)}d${Math.floor((seconds % 86400) / 3600)}h`;
  if (seconds >= 3600)
    return `${Math.floor(seconds / 3600)}h${String(Math.floor((seconds % 3600) / 60)).padStart(2, "0")}m`;
  return `${Math.floor(seconds / 60)}m`;
};

// 950, 123k, 1M, 1.5M
export const fmtTokens = (tokenCount: number) =>
  tokenCount < 1000
    ? String(tokenCount)
    : tokenCount < 1e6
      ? `${Math.round(tokenCount / 1000)}k`
      : `${(tokenCount / 1e6).toFixed(1).replace(/\.0$/, "")}M`;

const fmtElapsed = (seconds: number) =>
  seconds >= 3600
    ? `${Math.floor(seconds / 3600)}h${String(Math.floor((seconds % 3600) / 60)).padStart(2, "0")}m`
    : `${Math.floor(seconds / 60)}m${String(seconds % 60).padStart(2, "0")}s`;
const WRITERS = new Set(["Edit", "MultiEdit", "Write", "NotebookEdit", "Bash"]);
const DEBOUNCE_MS = 300;
// quotePath off: accented paths come out as-is instead of "caf\303\251.ts"
const GIT = ["git", "-c", "core.quotePath=false"];

const STATUS: Record<string, { icon: string; color: Role }> = {
  pending: { icon: "●", color: "yellow" },
  running: { icon: "●", color: "yellow" },
  waiting: { icon: "●", color: "yellow" },
  idle: { icon: "○", color: "gray" },
  completed: { icon: "✓", color: "green" },
  failed: { icon: "✗", color: "red" },
  killed: { icon: "✗", color: "red" },
};

// bumped by every refresh request: a run that is no longer the latest drops its result
let refreshGeneration = 0;

// `git diff --numstat` line: "<added>\t<deleted>\t<path>", "-" for binary
export const parseNumstat = (gitOutput: string): Change[] =>
  gitOutput
    .split("\n")
    .filter(Boolean)
    .map((line) => {
      const [addedField = "", deletedField = "", ...pathParts] = line.split("\t");
      return {
        path: pathParts.join("\t"),
        added: addedField === "-" ? null : Number(addedField),
        deleted: deletedField === "-" ? null : Number(deletedField),
        isNew: false,
      };
    });

export const parseUntracked = (gitOutput: string): Change[] =>
  gitOutput
    .split("\n")
    .filter(Boolean)
    .map((path) => ({ path, added: null, deleted: null, isNew: true }));

async function isPaneOpen($: EngineInterface) {
  return (await $.ui.panes()).some((pane) => pane.id === PANE);
}

async function refresh($: EngineInterface) {
  const thisGeneration = ++refreshGeneration;
  // ponytail: HEAD fails in a repo without commits; untracked files still show there
  // both lists are repo-root relative and cover the whole repo, whatever the cwd
  const [diff, untracked] = await Promise.all([
    $.process.run([...GIT, "diff", "--numstat", "--no-renames", "HEAD"]),
    $.process.run([
      ...GIT,
      "ls-files",
      "--others",
      "--exclude-standard",
      "--full-name",
      ":/",
    ]),
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

// ponytail: the engine drops finished agents from its list shortly after; no history kept
async function refreshAgents($: EngineInterface) {
  const agentInfos = await $.agent.list();
  const agentRows: Agent[] = agentInfos.map((agentInfo) => ({
    id: agentInfo.id,
    type: agentInfo.type,
    description: agentInfo.description,
    status: agentInfo.status,
  }));
  await update($, agents, () => agentRows);
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

async function ticker($: EngineInterface) {
  for (;;) {
    await $.clock.sleep(TICK_MS);
    await update($, tick, (tickCount) => tickCount + 1);
  }
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

// $.palette is absent for a moment when this mod draws before palette has loaded: default colors then
async function getTheme($: EngineInterface) {
  try {
    return await $.palette.get();
  } catch {
    return undefined;
  }
}

async function addSkill($: EngineInterface, name: string) {
  await update($, skills, (skillNames) =>
    skillNames.includes(name) ? skillNames : [...skillNames, name],
  );
}

export const register: Register = (on) => {
  on("session.start", async ($, event, next) => {
    await $.command.register({
      name: "session",
      description: "Toggle the session pane: agents, skills, changed files",
    });
    void refresh($).catch(() => {});
    void refreshBranch($).catch(() => {});
    void refreshCompactAt($).catch(() => {});
    void ticker($).catch(() => {});
    void $.ui.open({ id: PANE, title: "Session", columns: 50 });

    return next(event);
  });

  on("command.run", { command: "session" }, async ($) => {
    if (await isPaneOpen($)) {
      await $.ui.close({ id: PANE });

      return { text: "Session pane closed." };
    }
    await Promise.all([refresh($), refreshAgents($)]).catch(() => {});
    await $.ui.open({ id: PANE, title: "Session", columns: 50 });

    return { text: "Session pane opened." };
  });

  on("tool.call", async ($, event, next) => {
    const result = await next(event);
    if (event.tool === "Skill" && typeof event.skill === "string")
      void addSkill($, event.skill).catch(() => {});
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

  on("agent.spawn", async ($, event, next) => {
    const result = await next(event);
    void refreshAgents($).catch(() => {});

    return result;
  });

  on("turn.complete", async ($, event, next) => {
    const result = await next(event);
    if (event.agentId) void refreshAgents($).catch(() => {});
    else {
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

  on("ui.render", { component: "Pane", requestId: PANE }, async ($, event) => {
    const { Box, Text } = $.ui.resolve(event);
    const changedFiles = await read($, files);
    const agentList = await read($, agents);
    const skillList = await read($, skills);
    const addedTotal = changedFiles.reduce(
      (total, file) => total + (file.added ?? 0),
      0,
    );
    const deletedTotal = changedFiles.reduce(
      (total, file) => total + (file.deleted ?? 0),
      0,
    );

    await read($, tick);
    const [modelInfo, branchName, usage, nowMs, theme, compactTokens] =
      await Promise.all([
        read($, info),
        read($, branch),
        $.session.usage(),
        $.clock.now(),
        getTheme($),
        read($, compactAt),
      ]);
    const color: Partial<Record<Role, string>> = theme ? colors(theme) : {};
    const contextPercent = usage.context.percent ?? 0;
    const fiveHourLimit = usage.rateLimits.find(
      (rateLimit) => rateLimit.kind === "five_hour",
    );
    const sevenDayLimit = usage.rateLimits.find(
      (rateLimit) => rateLimit.kind === "seven_day",
    );
    const spendLimit = usage.rateLimits.find(
      (rateLimit) => rateLimit.kind === "spend_limit",
    );
    // one countdown, for the 7d window once it is under pressure, else the 5h one
    const countdownLimit =
      sevenDayLimit &&
      fiveHourLimit &&
      sevenDayLimit.percentUsed > fiveHourLimit.percentUsed &&
      sevenDayLimit.percentUsed >= 50
        ? sevenDayLimit
        : fiveHourLimit;
    const secondsUntilReset = countdownLimit?.resetsAt
      ? Math.floor((Date.parse(countdownLimit.resetsAt) - nowMs) / 1000)
      : 0;
    const elapsedSeconds = Math.floor((nowMs - usage.startedAt) / 1000);
    const contextTokens = usage.context.tokens;
    // close to the auto-compaction threshold, which can sit well below the model's window
    const nearCompact =
      !!contextTokens &&
      !!compactTokens &&
      contextTokens >= compactTokens * COMPACT_WARN;
    // the bar takes what the line leaves after "[", "] ", the percentage and the token count, up to MAX_BAR
    const contextTail =
      ` ${Math.round(contextPercent)}%  📊 ${contextTokens ? `${fmtTokens(contextTokens)}/${fmtTokens(usage.context.window)}` : "--/--"}` +
      (nearCompact ? " ⚠" : "");
    const barLength = Math.max(
      MIN_BAR,
      Math.min(MAX_BAR, event.props.bodyColumns - 2 - contextTail.length),
    );
    const filledCells = Math.min(
      barLength,
      Math.max(0, Math.round((contextPercent * barLength) / 100)),
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
          <Text bold>Agents</Text>
          {agentList.length === 0 && <Text dimColor>None.</Text>}
          {agentList.map((agent) => {
            const agentStatus = STATUS[agent.status] ?? {
              icon: "?",
              color: "gray",
            };
            return (
              <Box key={agent.id} flexDirection="row" gap={1}>
                <Text color={color[agentStatus.color]}>{agentStatus.icon}</Text>
                <Text color={color.cyan}>{agent.type}</Text>
                <Text wrap="truncate-end" dimColor>
                  {agent.description}
                </Text>
              </Box>
            );
          })}
          <Text> </Text>
          <Text bold>Skills</Text>
          {skillList.length === 0 && <Text dimColor>None.</Text>}
          {skillList.length > 0 && (
            <Text wrap="wrap">{skillList.join(", ")}</Text>
          )}
          <Text> </Text>
          <Text bold>Changes</Text>
          {changedFiles.length === 0 && <Text dimColor>No changes.</Text>}
          {changedFiles.map((file) => (
            <Box key={file.path} flexDirection="row" gap={1}>
              {file.isNew && <Text color={color.green}>new</Text>}
              {file.added === null && !file.isNew && <Text dimColor>bin</Text>}
              {file.added !== null && (
                <Text color={color.green}>+{file.added}</Text>
              )}
              {file.deleted !== null && (
                <Text color={color.red}>-{file.deleted}</Text>
              )}
              <Text wrap="truncate-start">{file.path}</Text>
            </Box>
          ))}
          {changedFiles.length > 0 && (
            <Text dimColor>
              {changedFiles.length} files, +{addedTotal} -{deletedTotal}
            </Text>
          )}
          <Text> </Text>
        </Box>
        <Text bold>Status</Text>
        <Box flexDirection="row" gap={2}>
          <Text color={color.cyan}>🤖 {modelInfo?.model ?? "Claude"}</Text>
          {modelInfo?.effort && (
            <Text
              color={color[EFFORT_COLOR[modelInfo.effort] ?? "white"]}
              dimColor={!EFFORT_COLOR[modelInfo.effort]}
            >
              🧠 {modelInfo.effort}
            </Text>
          )}
          {usage.cost && usage.cost.usd > 0 && (
            <Text color={color.red}>💰 ${usage.cost.usd.toFixed(4)}</Text>
          )}
        </Box>
        <Box flexDirection="row" gap={2}>
          {branchName && (
            <Text color={branchName.startsWith("@") ? color.yellow : color.green}>
              ⎇ {branchName.replace(/^@/, "")}
            </Text>
          )}
          {fiveHourLimit && sevenDayLimit && (
            <Text>
              <Text color={color.yellow}>⚡ </Text>
              <Text color={color[band(fiveHourLimit.percentUsed)]}>
                {Math.round(fiveHourLimit.percentUsed)}%
              </Text>
              <Text dimColor>/</Text>
              <Text color={color[band(sevenDayLimit.percentUsed)]}>
                {Math.round(sevenDayLimit.percentUsed)}%
              </Text>
              {secondsUntilReset > 0 && (
                <Text color={color.blue}> ↺ {fmtLeft(secondsUntilReset)}</Text>
              )}
            </Text>
          )}
          {spendLimit && (
            <Text color={color[band(spendLimit.percentUsed)]}>
              💳 {Math.round(spendLimit.percentUsed)}%
            </Text>
          )}
          {elapsedSeconds > 0 && (
            <Text color={color.magenta}>⏱ {fmtElapsed(elapsedSeconds)}</Text>
          )}
        </Box>
        <Text color={nearCompact ? color.red : color.yellow} wrap="truncate-end">
          [
          <Text color={nearCompact ? color.red : color.yellowBright}>
            {"█".repeat(filledCells)}
          </Text>
          {"░".repeat(barLength - filledCells)}]{contextTail}
        </Text>
      </Box>
    );
  });
};
