// Single source of the session's agents. This mod draws nothing: it collects the agents and publishes
// them as its `list` state; the session pane (and any later band, toast or command) reads that state.
import { atom, update } from "claude-code";
import type { EngineInterface, Register } from "claude-code";

import type { AgentEntry } from "../types";

const list = atom({ plugin: "agents", key: "list" } as const, []);

// ponytail: the engine drops finished agents from its list shortly after; no history kept
async function refreshAgents($: EngineInterface) {
  const agentInfos = await $.agent.list();
  const entries: AgentEntry[] = agentInfos.map((agentInfo) => ({
    id: agentInfo.id,
    type: agentInfo.type,
    description: agentInfo.description,
    status: agentInfo.status,
  }));
  await update($, list, () => entries);
}

export const register: Register = (on) => {
  on("session.start", async ($, event, next) => {
    void refreshAgents($).catch(() => {});

    return next(event);
  });

  on("agent.spawn", async ($, event, next) => {
    const result = await next(event);
    void refreshAgents($).catch(() => {});

    return result;
  });

  // a subagent's turn ending is where its status moves on
  on("turn.complete", async ($, event, next) => {
    const result = await next(event);
    if (event.agentId) void refreshAgents($).catch(() => {});

    return result;
  });
};
