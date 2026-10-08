// Single source of the session's agents. This mod draws nothing: it collects the agents and publishes
// them as its `list` state; the session pane (and any later band, toast or command) reads that state.
// $ and the atom stay in this file (the validator does not follow them across an import); the pure
// list operations live in lib/entries.ts.
import { atom, update } from "claude-code";
import type { EngineInterface, Register } from "claude-code";

import { mergeListed, newEntry, patchEntry, statusOfEnd, upsertEntry } from "./lib/entries";

const list = atom({ plugin: "agents", key: "list" } as const, []);

// bumped by every list refresh: a run that is no longer the latest drops its result
let listGeneration = 0;

async function refreshFromList($: EngineInterface) {
  const thisGeneration = ++listGeneration;
  const agentInfos = await $.agent.list();
  if (thisGeneration !== listGeneration) return;
  const listed = agentInfos.map((agentInfo) => ({
    id: agentInfo.id,
    parentId: agentInfo.parentId,
    type: agentInfo.type,
    description: agentInfo.description,
    status: agentInfo.status,
  }));
  await update($, list, (entries) => mergeListed(entries, listed));
}

export const register: Register = (on) => {
  on("session.start", async ($, event, next) => {
    void refreshFromList($).catch(() => {});

    return next(event);
  });

  on("agent.spawn", async ($, event, next) => {
    const result = await next(event);
    const agentId = "agentId" in result ? result.agentId : undefined;
    if (agentId) {
      const startedAt = await $.clock.now();
      const entry = newEntry({
        id: agentId,
        parentId: event.parentAgentId,
        type: event.subagentType,
        description: event.description,
        status: "running",
        model: "model" in result ? result.model : event.model,
        background: event.background,
        startedAt,
      });
      void update($, list, (entries) => upsertEntry(entries, entry)).catch(() => {});
      void refreshFromList($).catch(() => {});
    }

    return result;
  });

  // one step = one model request; counted before it goes out and once it came back
  on("turn.step", async function* ($, event, next) {
    const agentId = event.agentId;
    if (agentId)
      void update($, list, (entries) =>
        patchEntry(entries, agentId, (entry) => ({
          stepsStarted: entry.stepsStarted + 1,
          model: event.model,
        })),
      ).catch(() => {});

    const result = yield* next(event);

    if (agentId)
      void update($, list, (entries) =>
        patchEntry(entries, agentId, (entry) => ({ stepsDone: entry.stepsDone + 1 })),
      ).catch(() => {});

    return result;
  });

  // a subagent's run is one turn: its end is the agent's end
  on("turn.complete", async ($, event, next) => {
    const result = await next(event);
    const agentId = event.agentId;
    if (agentId) {
      const endedAt = await $.clock.now();
      void update($, list, (entries) =>
        patchEntry(entries, agentId, () => ({
          endedAt,
          endReason: event.reason,
          status: statusOfEnd(event.reason),
        })),
      ).catch(() => {});
      void refreshFromList($).catch(() => {});
    }

    return result;
  });
};
