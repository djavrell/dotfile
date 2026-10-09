import type { AgentEntry } from "agents";

import { Meter } from "../components/meter";
import { FINISHED, buildAgentTree } from "../lib/agentTree";
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
      {buildAgentTree(agentList).map(({ guide, underGuide, agent }) => {
        const agentStatus = AGENT_STATUS[agent.status] ?? UNKNOWN_STATUS;
        const model = modelIcon(agent.model);
        const counter = ` ${agent.stepsDone}/${agent.stepsStarted}`;
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
                {/* one cell per step; the empty one left is the step running */}
                {Meter({
                  ui: { Box, Text },
                  filled: agent.stepsDone,
                  total: agent.stepsStarted,
                  maxWidth: bodyColumns - underGuide.length - counter.length,
                  filledColor: FINISHED.has(agent.status)
                    ? color.green
                    : color.blue,
                  emptyColor: color.yellow,
                })}
                <Text dimColor>{counter}</Text>
              </Text>
            )}
          </Box>
        );
      })}
    </Box>
  );
}
