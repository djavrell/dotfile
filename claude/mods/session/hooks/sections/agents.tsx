import type { AgentEntry } from "agents";
import type { PaletteColorPath, PaletteTheme } from "palette";

import { Meter } from "../components/meter";
import { FINISHED, buildAgentTree } from "../lib/agentTree";
import { modelIcon } from "../lib/icons";
import { paint } from "../lib/theme";
import type { Ui } from "../lib/theme";

const AGENT_STATUS: Record<string, { icon: string; color: PaletteColorPath }> = {
  pending: { icon: "●", color: "ansi.yellow" },
  running: { icon: "●", color: "ansi.yellow" },
  waiting: { icon: "●", color: "ansi.yellow" },
  idle: { icon: "○", color: "comment" },
  completed: { icon: "✓", color: "ansi.green" },
  failed: { icon: "✗", color: "ansi.red" },
  killed: { icon: "✗", color: "ansi.red" },
};
const UNKNOWN_STATUS = { icon: "?", color: "comment" } as const;

export function AgentsSection({
  ui: { Box, Text },
  theme,
  agentList,
  bodyColumns,
}: {
  ui: Ui;
  theme?: PaletteTheme;
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
              <Text color={paint(theme, agentStatus.color)}>{agentStatus.icon} </Text>
              <Text color={paint(theme, model.color)}>{model.glyph} </Text>
              <Text color={theme?.ansi.cyan}>{agent.type} </Text>
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
                    ? theme?.ansi.green
                    : theme?.ansi.blue,
                  emptyColor: theme?.ansi.yellow,
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
