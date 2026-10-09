import type { ContextSlice } from "../../types";

const FREE: ContextSlice = { name: "Free space", tokens: 0, kind: "free" };

// lays the window out over cellCount cells, one slice per cell: what is used first in /context's order,
// then the free space, the compaction buffer last; a used slice too small for a cell still gets one
export function contextCells(
  slices: readonly ContextSlice[],
  maxTokens: number,
  cellCount: number,
): ContextSlice[] {
  const tokensPerCell = maxTokens / cellCount;
  const cells: ContextSlice[] = [];
  let usedTokens = 0;
  for (const slice of slices) {
    if (slice.kind !== "used" || slice.tokens <= 0) continue;
    usedTokens += slice.tokens;
    const lastCell = Math.min(
      cellCount,
      Math.max(Math.round(usedTokens / tokensPerCell), cells.length + 1),
    );
    while (cells.length < lastCell) cells.push(slice);
  }
  const buffer = slices.find((slice) => slice.kind === "buffer");
  const bufferCount = buffer
    ? Math.min(cellCount - cells.length, Math.round(buffer.tokens / tokensPerCell))
    : 0;
  const free = slices.find((slice) => slice.kind === "free") ?? FREE;
  while (cells.length < cellCount - bufferCount) cells.push(free);
  while (buffer && cells.length < cellCount) cells.push(buffer);

  return cells;
}

// consecutive cells of one slice, so a row draws as a few colored runs
export function sliceRuns(cells: readonly ContextSlice[]) {
  const runs: { slice: ContextSlice; length: number }[] = [];
  for (const cell of cells) {
    const lastRun = runs[runs.length - 1];
    if (lastRun?.slice === cell) lastRun.length++;
    else runs.push({ slice: cell, length: 1 });
  }

  return runs;
}
