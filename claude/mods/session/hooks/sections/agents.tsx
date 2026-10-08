import type { AgentEntry } from "agents";

import type { Colors, Role, Ui } from "../lib/theme";

const AGENT_STATUS: Record<string, { icon: string; color: Role }> = {
  pending: { icon: "●", color: "yellow" },
  running: { icon: "●", color: "yellow" },
  waiting: { icon: "●", color: "yellow" },
  idle: { icon: "○", color: "gray" },
  completed: { icon: "✓", color: "green" },
  failed: { icon: "✗", color: "red" },
  killed: { icon: "✗", color: "red" },
};
const UNKNOWN_STATUS = { icon: "?", color: "gray" } as const;

export function AgentsSection({
  ui: { Box, Text },
  color,
  agentList,
}: {
  ui: Ui;
  color: Colors;
  agentList: readonly AgentEntry[];
}) {
  return (
    <Box flexDirection="column">
      <Text bold>Agents</Text>
      {agentList.length === 0 && <Text dimColor>None.</Text>}
      {agentList.map((agent) => {
        const agentStatus = AGENT_STATUS[agent.status] ?? UNKNOWN_STATUS;
        return (
          <Box key={agent.id} flexDirection="row" gap={1}>
            <Text color={color[agentStatus.color]}>{agentStatus.icon}</Text>
            <Text color={color.cyan}>{agent.type}</Text>
            <Text wrap="truncate-end" dimColor>
              {agent.description}
            </Text>
          </Box>
        );
      })}
    </Box>
  );
}
