import type { Ui } from "../lib/theme";

// the meter's glyphs, in one place: a style change touches this file only
const FILLED_CELL = "▰";
const EMPTY_CELL = "▱";
const OVERFLOW = "…";

// `filled` cells out of `total`, as text. Past `maxWidth` cells only the last ones show, after "…"
export function meterCells(filled: number, total: number, maxWidth = Infinity) {
  const shownTotal = Math.max(0, Math.round(total));
  const shownFilled = Math.min(shownTotal, Math.max(0, Math.round(filled)));
  const room = Math.max(1, Math.floor(maxWidth));
  const isOverflowing = shownTotal > room;
  // the tail of the row: drop cells from the filled side first
  const kept = isOverflowing ? room - 1 : shownTotal;
  const emptyCount = Math.min(shownTotal - shownFilled, kept);
  return {
    overflow: isOverflowing ? OVERFLOW : "",
    filled: FILLED_CELL.repeat(kept - emptyCount),
    empty: EMPTY_CELL.repeat(emptyCount),
  };
}

// a gauge of cells: the context fill, an agent's steps, the effort level...
// `emptyColor` absent draws the empty cells dim
export function Meter({
  ui: { Text },
  filled,
  total,
  maxWidth,
  filledColor,
  emptyColor,
}: {
  ui: Ui;
  filled: number;
  total: number;
  maxWidth?: number;
  filledColor?: string;
  emptyColor?: string;
}) {
  const cells = meterCells(filled, total, maxWidth);
  return (
    <Text>
      {cells.overflow && <Text dimColor>{cells.overflow}</Text>}
      <Text color={filledColor}>{cells.filled}</Text>
      {emptyColor ? (
        <Text color={emptyColor}>{cells.empty}</Text>
      ) : (
        <Text dimColor>{cells.empty}</Text>
      )}
    </Text>
  );
}
