import type { AgentEntry } from "agents";

// the agents one Workflow run spawned, in their run order (agentIndex)
export type WorkflowRun = { runId: string; agents: AgentEntry[] };

// one line of the tree, an agent or a Workflow run grouping its agents: `guide` is the "│  ├─ " in
// front of it, `underGuide` what goes in front of a line drawn under it (an agent's steps), carrying
// the tree's lines down to its siblings and children
export type AgentRow = { guide: string; underGuide: string } & (
  | { agent: AgentEntry; run?: undefined }
  | { agent?: undefined; run: WorkflowRun }
);

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

export type ChildCount = { running: number; finished: number };

// the agents each agent spawned itself (not its subagents' own), split running / finished; give it
// the whole list, not the visible one, so children finished long ago still count
export function childCounts(
  agents: readonly AgentEntry[],
): Map<string, ChildCount> {
  const counts = new Map<string, ChildCount>();
  for (const agent of agents) {
    if (!agent.parentId) continue;
    const count = counts.get(agent.parentId) ?? { running: 0, finished: 0 };
    if (FINISHED.has(agent.status)) count.finished++;
    else count.running++;
    counts.set(agent.parentId, count);
  }
  return counts;
}

// one level's agents, a Workflow run's agents folded into one run node where its first one started;
// a run of a single agent still gets its node, so a run always reads the same
function groupRuns(agents: AgentEntry[]): (AgentEntry | WorkflowRun)[] {
  const runs = new Map<string, WorkflowRun>();
  const nodes: (AgentEntry | WorkflowRun)[] = [];
  for (const agent of agents) {
    if (!agent.workflow) {
      nodes.push(agent);
      continue;
    }
    const run = runs.get(agent.workflow.runId);
    if (run) run.agents.push(agent);
    else {
      const newRun = { runId: agent.workflow.runId, agents: [agent] };
      runs.set(newRun.runId, newRun);
      nodes.push(newRun);
    }
  }
  for (const run of runs.values())
    run.agents.sort(
      (agentA, agentB) =>
        (agentA.workflow?.agentIndex ?? 0) - (agentB.workflow?.agentIndex ?? 0),
    );
  return nodes;
}

// agents nested under the agent that spawned them, each level in start order, a Workflow run's
// agents under one run node; an agent whose parent is unknown (the main conversation, or a parent
// dropped from the list) is a root
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
  const pushAgent = (agent: AgentEntry, guide: string, isLast: boolean) => {
    const childGuide = guide + (isLast ? "   " : "│  ");
    const hasChildren = childrenOf(agent.id).length > 0;
    rows.push({
      guide: guide + (isLast ? "└─ " : "├─ "),
      underGuide: childGuide + (hasChildren ? "│ " : "  "),
      agent,
    });
    walk(agent.id, childGuide);
  };
  const walk = (parentId: string | undefined, guide: string) => {
    const nodes = groupRuns(childrenOf(parentId));
    nodes.forEach((node, nodeIndex) => {
      const isLast = nodeIndex === nodes.length - 1;
      if (!("runId" in node)) return pushAgent(node, guide, isLast);
      const runGuide = guide + (isLast ? "   " : "│  ");
      rows.push({
        guide: guide + (isLast ? "└─ " : "├─ "),
        underGuide: runGuide + "│ ",
        run: node,
      });
      node.agents.forEach((agent, agentIndex) =>
        pushAgent(agent, runGuide, agentIndex === node.agents.length - 1),
      );
    });
  };
  walk(undefined, "");
  return rows;
}
