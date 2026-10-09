import type { AgentEntry } from "agents";

// one agent of the tree: `guide` is the "│  ├─ " in front of it, `underGuide` what goes in front of
// a line drawn under it (its steps), carrying the tree's lines down to its siblings and children
export type AgentRow = { guide: string; underGuide: string; agent: AgentEntry };

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
