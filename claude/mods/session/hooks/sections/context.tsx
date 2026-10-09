import type { SessionUsage } from "claude-code";

import type { ContextInfo, ContextSlice } from "../../types";
import { contextCells, sliceRuns } from "../lib/contextGrid";
import { fmtTokens } from "../lib/format";
import type { Colors, Role, Ui } from "../lib/theme";

// share of the auto-compaction threshold past which the context line warns
const COMPACT_WARN = 0.9;
const GRID_ROWS = 4;
// the grid's cells; the legend keeps the plain square for a category it has no icon for
const USED_CELL = "▰";
const FREE_CELL = "▱";
const UNKNOWN_ICON = "■";
// by /context's row names: the rows have no stable id, only a kind; a row not listed takes the next spare color
// and the plain cell as its legend icon
const SLICE_STYLE: Record<string, { role: Role; icon: string }> = {
  "System prompt": { role: "blue", icon: "" }, // nf-fa-cog
  "System tools": { role: "cyan", icon: "" }, // nf-fa-wrench
  "MCP tools": { role: "magenta", icon: "" }, // nf-fa-plug
  "MCP server instructions": { role: "magenta", icon: "" }, // nf-fa-info_circle
  "Custom agents": { role: "white", icon: "" }, // nf-fa-users
  "Memory files": { role: "yellow", icon: "" }, // nf-fa-database
  Skills: { role: "yellowBright", icon: "" }, // nf-fa-bolt
  Messages: { role: "green", icon: "" }, // nf-fa-comments
};
const SPARE_COLORS: Role[] = ["cyan", "magenta", "yellow", "blue"];

// what /context-icons prints: each icon of the legend and the grid's other cells, by name
export const CONTEXT_LEGEND = [
  ...Object.entries(SLICE_STYLE).map(([name, style]) => `${style.icon}  ${name}`),
  `${UNKNOWN_ICON}  another category, its name beside it`,
  `${FREE_CELL}  free space (grid)`,
  `${USED_CELL}  autocompact buffer (grid, red)`,
].join("\n");

export function ContextSection({
  ui: { Box, Text },
  color,
  contextInfo,
  usage,
  bodyColumns,
}: {
  ui: Ui;
  color: Colors;
  contextInfo: ContextInfo | null;
  usage: SessionUsage;
  // the pane's inner width, which the grid fills
  bodyColumns: number;
}) {
  const contextPercent = usage.context.percent ?? 0;
  const contextTokens = usage.context.tokens;
  const compactTokens = contextInfo?.compactAt;
  // close to the auto-compaction threshold, which can sit well below the model's window
  const nearCompact =
    !!contextTokens &&
    !!compactTokens &&
    contextTokens >= compactTokens * COMPACT_WARN;
  const usedSlices =
    contextInfo?.slices.filter(
      (slice) => slice.kind === "used" && slice.tokens > 0,
    ) ?? [];
  const sliceColor = (slice: ContextSlice) => {
    if (slice.kind === "buffer") return color.red;
    if (slice.kind !== "used") return color.gray;
    const spareIndex = usedSlices.indexOf(slice) % SPARE_COLORS.length;
    return color[
      SLICE_STYLE[slice.name]?.role ?? SPARE_COLORS[spareIndex] ?? "gray"
    ];
  };
  const cells = contextInfo
    ? contextCells(contextInfo.slices, contextInfo.maxTokens, GRID_ROWS * bodyColumns)
    : [];
  const gridRows = Array.from({ length: cells.length ? GRID_ROWS : 0 }, (_, rowIndex) =>
    sliceRuns(cells.slice(rowIndex * bodyColumns, (rowIndex + 1) * bodyColumns)),
  );

  return (
    <Box flexDirection="column">
      <Text bold>Context</Text>
      {gridRows.map((runs, rowIndex) => (
        <Text key={`row${rowIndex}`} wrap="truncate-end">
          {runs.map((run, runIndex) => (
            <Text
              key={`run${runIndex}`}
              color={sliceColor(run.slice)}
              dimColor={run.slice.kind !== "used"}
            >
              {(run.slice.kind === "free" ? FREE_CELL : USED_CELL).repeat(run.length)}
            </Text>
          ))}
        </Text>
      ))}
      <Box flexDirection="row" flexWrap="wrap" columnGap={2}>
        {usedSlices.map((slice) => (
          <Text key={slice.name} color={sliceColor(slice)}>
            {SLICE_STYLE[slice.name]?.icon ?? `${UNKNOWN_ICON} ${slice.name}`}{" "}
            {fmtTokens(slice.tokens)}
          </Text>
        ))}
      </Box>
      <Text color={nearCompact ? color.red : color.yellow} wrap="truncate-end">
        {Math.round(contextPercent)}%  📊{" "}
        {contextTokens
          ? `${fmtTokens(contextTokens)}/${fmtTokens(usage.context.window)}`
          : "--/--"}
        {nearCompact ? " ⚠" : ""}
      </Text>
    </Box>
  );
}
