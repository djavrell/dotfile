import type { SessionUsage } from "claude-code";

import type { ModelInfo } from "../../types";
import { fmtElapsed, fmtLeft, fmtTokens } from "../lib/format";
import { band } from "../lib/theme";
import type { Colors, Role, Ui } from "../lib/theme";

// share of the auto-compaction threshold past which the context line warns
const COMPACT_WARN = 0.9;
const MIN_BAR = 4;
const MAX_BAR = 16;
const EFFORT_COLOR: Record<string, Role> = {
  max: "magenta",
  xhigh: "magenta",
  high: "cyan",
};

export function StatusSection({
  ui: { Box, Text },
  color,
  modelInfo,
  branchName,
  usage,
  nowMs,
  compactTokens,
  bodyColumns,
}: {
  ui: Ui;
  color: Colors;
  modelInfo: ModelInfo | null;
  branchName: string;
  usage: SessionUsage;
  nowMs: number;
  // token count auto-compaction runs at; null when it is off or not known yet
  compactTokens: number | null;
  // the pane's inner width, which the context bar fills
  bodyColumns: number;
}) {
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
    Math.min(MAX_BAR, bodyColumns - 2 - contextTail.length),
  );
  const filledCells = Math.min(
    barLength,
    Math.max(0, Math.round((contextPercent * barLength) / 100)),
  );

  return (
    <Box flexDirection="column">
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
}
