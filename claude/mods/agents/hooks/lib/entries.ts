import type { AgentEntry } from "../../types";

// ponytail: keeps the last 30 agents; older ones drop off the list
export const MAX_ENTRIES = 30;

// what $.agent.list() says about one agent
export type ListedAgent = {
  id: string;
  parentId?: string;
  type: string;
  description: string;
  status: string;
};

export const newEntry = (
  fields: Omit<AgentEntry, "stepsStarted" | "stepsDone">,
): AgentEntry => ({ ...fields, stepsStarted: 0, stepsDone: 0 });

// adds an agent, or replaces the fields given on the one already there
export const upsertEntry = (
  entries: readonly AgentEntry[],
  entry: AgentEntry,
): AgentEntry[] => {
  const existing = entries.find((candidate) => candidate.id === entry.id);
  if (!existing) return [...entries, entry].slice(-MAX_ENTRIES);
  return entries.map((candidate) =>
    candidate.id === entry.id ? { ...candidate, ...entry, stepsStarted: candidate.stepsStarted, stepsDone: candidate.stepsDone } : candidate,
  );
};

// changes an agent already known; ids never seen (the engine's own forks: compaction, memory) are ignored
export const patchEntry = (
  entries: readonly AgentEntry[],
  agentId: string,
  patch: (entry: AgentEntry) => Partial<AgentEntry>,
): AgentEntry[] =>
  entries.map((entry) => (entry.id === agentId ? { ...entry, ...patch(entry) } : entry));

// the engine's list brings statuses, and agents born without a spawn (a forked skill);
// agents it has dropped keep their last known state
export const mergeListed = (
  entries: readonly AgentEntry[],
  listed: readonly ListedAgent[],
): AgentEntry[] => {
  let merged = [...entries];
  for (const agent of listed) {
    const existing = merged.find((entry) => entry.id === agent.id);
    merged = existing
      ? patchEntry(merged, agent.id, () => ({
          status: agent.status,
          parentId: agent.parentId ?? existing.parentId,
        }))
      : upsertEntry(merged, newEntry(agent));
  }
  return merged;
};

// a finished turn's reason, as a status, until the engine's list says otherwise
export const statusOfEnd = (reason: string) =>
  reason === "answer" ? "completed" : reason === "aborted" ? "killed" : "failed";
