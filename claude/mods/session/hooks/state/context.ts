// The Context section's state: the context window's breakdown, re-read after each turn and each compaction.
// The atom stays here with its read/update calls, as the validator requires.
import { atom, read, update } from "claude-code";
import type { EngineInterface } from "claude-code";

import type { ContextInfo } from "../../types";
import { cacheReadPercent } from "../lib/format";

const context = atom({ plugin: "session", key: "context" } as const, null);

// the summary breakdown is estimated locally: no API call
export async function refreshContext($: EngineInterface) {
  const { breakdown } = (await $.session.usage({ breakdown: "summary" }))
    .context;
  if (!breakdown) return;
  const contextInfo: ContextInfo = {
    slices: breakdown.categories.map(({ name, tokens, kind }) => ({
      name,
      tokens,
      kind,
    })),
    maxTokens: breakdown.maxTokens,
    compactAt: breakdown.autoCompactThreshold ?? null,
    cacheReadPercent: breakdown.apiUsage
      ? cacheReadPercent(breakdown.apiUsage)
      : null,
  };
  await update($, context, () => contextInfo);
}

export async function readContext($: EngineInterface) {
  return read($, context);
}
