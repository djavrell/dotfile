// Single source of the session's agents. This mod draws nothing: it collects the agents and publishes
// them as its `list` state; the session pane (and any later band, toast or command) reads that state.
// The atom stays in this file with its update calls (the validator wants them together); the pure
// list operations live in lib/entries.ts.
import { atom, update } from "claude-code";
import type { EngineInterface, Register } from "claude-code";

import { mergeListed, newEntry, patchEntry, resumed, statusOfEnd, stepStarted, upsertEntry } from "./lib/entries";

const list = atom({ plugin: "agents", key: "list" } as const, []);

// bumped by every list refresh: a run that is no longer the latest drops its result
let listGeneration = 0;

// first step of every agent loop, by id: the start of an agent born without a spawn (a forked skill
// such as /code-review), which the list only shows once it spawns a child
// ponytail: never pruned, a few numbers per session (forks for compaction and memory included)
const firstStepAt = new Map<string, number>();

async function refreshFromList($: EngineInterface) {
  const thisGeneration = ++listGeneration;
  const agentInfos = await $.agent.list();
  const nowMs = await $.clock.now();
  if (thisGeneration !== listGeneration) return;
  const listed = agentInfos.map((agentInfo) => ({
    id: agentInfo.id,
    parentId: agentInfo.parentId,
    type: agentInfo.type,
    description: agentInfo.description,
    status: agentInfo.status,
    startedAt: firstStepAt.get(agentInfo.id),
  }));
  await update($, list, (entries) => mergeListed(entries, listed, nowMs));
}

export const register: Register = (on) => {
  on("session.start", async ($, event, next) => {
    void refreshFromList($).catch(() => {});

    return next(event);
  });

  on("agent.spawn", async ($, event, next) => {
    const result = await next(event);
    const agentId = result.agentId;
    // a resume (SendMessage, a teammate back from disk) spawns no new agent: only its end is undone;
    // one unknown here (reloaded from disk) is added by the list refresh
    if (agentId && event.resume) {
      void update($, list, (entries) => patchEntry(entries, agentId, resumed)).catch(() => {});
      void refreshFromList($).catch(() => {});
    } else if (agentId) {
      const startedAt = await $.clock.now();
      const entry = newEntry({
        id: agentId,
        parentId: event.parentAgentId,
        type: event.subagentType,
        description: event.description,
        status: "running",
        model: result.model,
        background: event.background,
        startedAt,
        workflow: event.workflow,
      });
      void update($, list, (entries) => upsertEntry(entries, entry)).catch(() => {});
      void refreshFromList($).catch(() => {});
    }

    return result;
  });

  // one step = one model request; counted before it goes out and once it came back
  on("turn.step", async function* ($, event, next) {
    const agentId = event.agentId;
    if (agentId && !firstStepAt.has(agentId)) firstStepAt.set(agentId, await $.clock.now());
    if (agentId)
      void update($, list, (entries) =>
        patchEntry(entries, agentId, (entry) => stepStarted(entry, event.model)),
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
