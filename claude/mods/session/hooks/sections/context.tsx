import type { SessionUsage } from "claude-code";
import type { PaletteColorPath, PaletteTheme } from "palette";

import type { ContextInfo, ContextSlice } from "../../types";
import { contextCells, sliceRuns } from "../lib/contextGrid";
import { fmtTokens } from "../lib/format";
import { paint } from "../lib/theme";
import type { Ui } from "../lib/theme";

// share of the auto-compaction threshold past which the context line warns
const COMPACT_WARN = 0.9;
const GRID_ROWS = 4;
// the grid's cells; the legend keeps the plain square for a category it has no icon for
const USED_CELL = "▰";
const FREE_CELL = "▱";
const UNKNOWN_ICON = "■";
// by /context's row names: the rows have no stable id, only a kind; a row not listed takes the next spare color
// and the plain cell as its legend icon
const SLICE_STYLE: Record<string, { role: PaletteColorPath; icon: string }> = {
  "System prompt": { role: "ansi.blue", icon: "" }, // nf-fa-cog
  "System tools": { role: "ansi.cyan", icon: "" }, // nf-fa-wrench
  "MCP tools": { role: "ansi.magenta", icon: "" }, // nf-fa-plug
  "MCP server instructions": { role: "ansi.magenta", icon: "" }, // nf-fa-info_circle
  "Custom agents": { role: "ansi.white", icon: "" }, // nf-fa-users
  "Memory files": { role: "ansi.yellow", icon: "" }, // nf-fa-database
  Skills: { role: "brights.yellow", icon: "" }, // nf-fa-bolt
  Messages: { role: "ansi.green", icon: "" }, // nf-fa-comments
};
const SPARE_COLORS: PaletteColorPath[] = ["ansi.cyan", "ansi.magenta", "ansi.yellow", "ansi.blue"];

// what /context-icons prints: each icon of the legend and the grid's other cells, by name
export const CONTEXT_LEGEND = [
  ...Object.entries(SLICE_STYLE).map(([name, style]) => `${style.icon}  ${name}`),
  `${UNKNOWN_ICON}  another category, its name beside it`,
  `${FREE_CELL}  free space (grid)`,
  `${USED_CELL}  autocompact buffer (grid, red)`,
].join("\n");

export function ContextSection({
  ui: { Box, Text },
  theme,
  contextInfo,
  usage,
  bodyColumns,
}: {
  ui: Ui;
  theme?: PaletteTheme;
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
    if (slice.kind === "buffer") return theme?.ansi.red;
    if (slice.kind !== "used") return theme?.comment;
    const spareIndex = usedSlices.indexOf(slice) % SPARE_COLORS.length;
    return paint(
      theme,
      SLICE_STYLE[slice.name]?.role ?? SPARE_COLORS[spareIndex] ?? "comment",
    );
  };
  const cells = contextInfo
    ? contextCells(contextInfo.slices, contextInfo.maxTokens, GRID_ROWS * bodyColumns)
    : [];
  const gridRows = Array.from({ length: cells.length ? GRID_ROWS : 0 }, (_, rowIndex) =>
    sliceRuns(cells.slice(rowIndex * bodyColumns, (rowIndex + 1) * bodyColumns)),
  );

  return (
    <Box flexDirection="column">
      <Text weight="semibold">Context</Text>
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
      <Text color={nearCompact ? theme?.ansi.red : theme?.ansi.yellow} wrap="truncate-end">
        {Math.round(contextPercent)}%  📊{" "}
        {contextTokens
          ? `${fmtTokens(contextTokens)}/${fmtTokens(usage.context.window)}`
          : "--/--"}
        {nearCompact ? " ⚠" : ""}
      </Text>
    </Box>
  );
}
