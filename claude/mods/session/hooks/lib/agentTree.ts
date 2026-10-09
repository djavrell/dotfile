import type { AgentEntry } from "agents";

// one agent of the tree: `guide` is the "│  ├─ " in front of it, `underGuide` what goes in front of
// a line drawn under it (its steps), carrying the tree's lines down to its siblings and children
export type AgentRow = { guide: string; underGuide: string; agent: AgentEntry };

export const FINISHED = new Set(["completed", "failed", "killed"]);

// drops agents finished more than `keepMs` ago (no endedAt counts as long ago), but keeps a finished
// agent while one of its descendants is still shown, so a running child stays nested under it
export function visibleAgents(
  agents: readonly AgentEntry[],
  nowMs: number,
  keepMs: number,
): AgentEntry[] {
  const isRecent = (agent: AgentEntry) =>
    !FINISHED.has(agent.status) ||
    (agent.endedAt !== undefined && nowMs - agent.endedAt < keepMs);
  // ponytail: rescans the list per agent, fine for a session's few dozen agents
  const isVisible = (agent: AgentEntry): boolean =>
    isRecent(agent) ||
    agents.some((child) => child.parentId === agent.id && isVisible(child));
  return agents.filter(isVisible);
}

// agents nested under the agent that spawned them, each level in start order;
// an agent whose parent is unknown (the main conversation, or a parent dropped from the list) is a root
export function buildAgentTree(agents: readonly AgentEntry[]): AgentRow[] {
  const knownIds = new Set(agents.map((agent) => agent.id));
  const byStart = [...agents].sort(
    (agentA, agentB) => (agentA.startedAt ?? 0) - (agentB.startedAt ?? 0),
  );
  const childrenOf = (parentId: string | undefined) =>
    byStart.filter((agent) =>
      parentId === undefined
        ? !agent.parentId || !knownIds.has(agent.parentId)
        : agent.parentId === parentId,
    );

  const rows: AgentRow[] = [];
  const walk = (parentId: string | undefined, guide: string) => {
    const children = childrenOf(parentId);
    children.forEach((agent, childIndex) => {
      const isLast = childIndex === children.length - 1;
      const childGuide = guide + (isLast ? "   " : "│  ");
      const hasChildren = childrenOf(agent.id).length > 0;
      rows.push({
        guide: guide + (isLast ? "└─ " : "├─ "),
        underGuide: childGuide + (hasChildren ? "│ " : "  "),
        agent,
      });
      walk(agent.id, childGuide);
    });
  };
  walk(undefined, "");
  return rows;
}
