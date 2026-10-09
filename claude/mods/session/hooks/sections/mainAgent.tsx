import type { SessionUsage } from "claude-code";

import type { ContextInfo, ModelInfo } from "../../types";
import { Meter } from "../components/meter";
import { fmtElapsed, fmtLeft } from "../lib/format";
import { modelIcon } from "../lib/icons";
import { band } from "../lib/theme";
import type { Colors, Role, Ui } from "../lib/theme";

// the effort scale, one meter cell per level; a level outside it (a number) shows as text only
const EFFORT_LEVELS = ["low", "medium", "high", "xhigh", "max"];
// low and medium are drawn gray
const EFFORT_COLOR: Record<string, Role> = {
  max: "magenta",
  xhigh: "magenta",
  high: "cyan",
};

// nf-md-cached, as an escape: Nerd Font glyphs vanish from Claude's own output
const CACHE_GLYPH = "\u{F00E8}";

// the main conversation's card, the root the subagents' tree hangs from: model, effort, cost, limits, cache, time
export function MainAgentCard({
  ui: { Box, Text },
  color,
  modelInfo,
  contextInfo,
  usage,
  nowMs,
}: {
  ui: Ui;
  color: Colors;
  modelInfo: ModelInfo | null;
  contextInfo: ContextInfo | null;
  usage: SessionUsage;
  nowMs: number;
}) {
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
  const effort = modelInfo?.effort;
  const effortLevel = effort ? EFFORT_LEVELS.indexOf(effort) + 1 : 0;
  const effortColor = color[(effort && EFFORT_COLOR[effort]) || "gray"];
  const model = modelIcon(modelInfo?.model);
  const cacheRead = contextInfo?.cacheReadPercent ?? null;

  return (
    <Box
      flexDirection="column"
      borderStyle="round"
      borderColor={color.gray}
      paddingX={1}
    >
      <Box flexDirection="row" gap={2}>
        <Text bold>
          <Text color={color[model.color]}>{model.glyph} </Text>
          <Text color={color.cyan}>{modelInfo?.model ?? "Claude"}</Text>
        </Text>
        {effort && (
          <Text color={effortColor}>
            🧠{" "}
            {effortLevel > 0 && (
              <Text>
                {Meter({
                  ui: { Box, Text },
                  filled: effortLevel,
                  total: EFFORT_LEVELS.length,
                  filledColor: effortColor,
                })}{" "}
              </Text>
            )}
            {effort}
          </Text>
        )}
        {usage.cost && usage.cost.usd > 0 && (
          <Text color={color.red}>💰 ${usage.cost.usd.toFixed(4)}</Text>
        )}
      </Box>
      <Box flexDirection="row" gap={2}>
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
        {cacheRead !== null && (
          // high is good: a drop means the cache lapsed and the prefix was billed again
          <Text color={color[band(100 - cacheRead)]}>
            {CACHE_GLYPH} {Math.round(cacheRead)}%
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
    </Box>
  );
}
