// The session pane's id and width, and the $ calls that open it or ask whether it is open.
import type { EngineInterface } from "claude-code";

export const PANE = "session";
export const PANE_COLUMNS = 70;

export async function isPaneOpen($: EngineInterface) {
  return (await $.ui.panes()).some((pane) => pane.id === PANE);
}

export async function openPane($: EngineInterface) {
  await $.ui.open({ id: PANE, title: "Session", columns: PANE_COLUMNS });
}
