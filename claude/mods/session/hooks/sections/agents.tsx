import type { AgentEntry } from "agents";

import { buildAgentTree, stepStrip } from "../lib/agentTree";
import { modelIcon } from "../lib/icons";
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
const FINISHED = new Set(["completed", "failed", "killed"]);

export function AgentsSection({
  ui: { Box, Text },
  color,
  agentList,
  bodyColumns,
}: {
  ui: Ui;
  color: Colors;
  agentList: readonly AgentEntry[];
  // the pane's inner width, which the step strips fill
  bodyColumns: number;
}) {
  return (
    <Box flexDirection="column">
      <Text bold>Agents</Text>
      {agentList.length === 0 && <Text dimColor>None.</Text>}
      {buildAgentTree(agentList).map(({ guide, underGuide, agent }) => {
        const agentStatus = AGENT_STATUS[agent.status] ?? UNKNOWN_STATUS;
        const model = modelIcon(agent.model);
        const counter = ` ${agent.stepsDone}/${agent.stepsStarted}`;
        const strip = stepStrip(
          agent.stepsDone,
          agent.stepsStarted,
          bodyColumns - underGuide.length - counter.length,
        );
        return (
          <Box key={agent.id} flexDirection="column">
            <Text wrap="truncate-end">
              <Text dimColor>{guide}</Text>
              <Text color={color[agentStatus.color]}>{agentStatus.icon} </Text>
              <Text color={color[model.color]}>{model.glyph} </Text>
              <Text color={color.cyan}>{agent.type} </Text>
              <Text dimColor>{agent.description}</Text>
            </Text>
            {agent.stepsStarted > 0 && (
              <Text wrap="truncate-end">
                <Text dimColor>{underGuide}</Text>
                <Text color={FINISHED.has(agent.status) ? color.green : color.blue}>
                  {strip.done}
                </Text>
                <Text color={color.yellow}>{strip.running}</Text>
                <Text dimColor>{counter}</Text>
              </Text>
            )}
          </Box>
        );
      })}
    </Box>
  );
}
