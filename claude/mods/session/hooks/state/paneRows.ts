// Rows other mods add to the pane's Tracking section. A mod cannot write another's state and an atom needs a literal plugin
// name, so the session's state.set hook copies each mod's `paneRows` write here: any mod that publishes it shows up, unnamed.
// The atom stays here with its read/update calls, as the validator requires.
import { atom, read, update } from 'claude-code';
import type { EngineInterface } from 'claude-code';

import type { PaneRow } from '../../types';

const providedRows = atom({ plugin: 'session', key: 'providedRows' } as const, {});

// the key other mods publish their rows under
export const PANE_ROWS_KEY = 'paneRows';

// a value that is not a list (a mod with another `paneRows`) clears that mod's rows rather than breaking the pane
export async function storePaneRows($: EngineInterface, plugin: string, value: unknown) {
  const rows = Array.isArray(value) ? (value as PaneRow[]) : [];
  await update($, providedRows, (known) => ({ ...known, [plugin]: rows }));
}

export async function readPaneRows($: EngineInterface) {
  return Object.values(await read($, providedRows)).flat();
}
