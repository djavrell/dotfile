import type { AgentEntry } from "agents";
import type { Elements } from "claude-code";
import type { PaletteColorPath, PaletteTheme } from "palette";

import { Meter } from "../components/meter";
import { FINISHED, buildAgentTree } from "../lib/agentTree";
import type { ChildCount } from "../lib/agentTree";
import { fmtElapsed } from "../lib/format";
import { modelIcon } from "../lib/icons";
import { paint, unInverted } from "../lib/theme";
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
const NO_CHILDREN: ChildCount = { running: 0, finished: 0 };

export function AgentsSection({
  ui: { Box, Button, Text },
  theme,
  agentList,
  subagentCounts,
  nowMs,
  bodyColumns,
  viewedAgentId,
  onViewAgent,
}: {
  // an agent's line is a button: this section needs Button on top of Box and Text
  ui: Ui & Pick<Elements[keyof Elements], "Button">;
  theme?: PaletteTheme;
  agentList: readonly AgentEntry[];
  // by agent id, from `childCounts` over the whole list
  subagentCounts: ReadonlyMap<string, ChildCount>;
  nowMs: number;
  // the pane's inner width, which the step strips fill
  bodyColumns: number;
  // the agent whose transcript the main view shows (`e.props.view`), underlined
  viewedAgentId?: string;
  onViewAgent: (agentId: string) => void;
}) {
  return (
    <Box flexDirection="column">
      {buildAgentTree(agentList).map((row) => {
        if (row.run) {
          const runAgents = row.run.agents;
          // running while one agent runs, then failed if one failed
          const runStatusName = runAgents.some((agent) => !FINISHED.has(agent.status))
            ? "running"
            : runAgents.some((agent) => agent.status !== "completed")
              ? "failed"
              : "completed";
          const runStatus = AGENT_STATUS[runStatusName] ?? UNKNOWN_STATUS;
          return (
            <Text key={row.run.runId} wrap="truncate-end">
              <Text dimColor>{row.guide}</Text>
              <Text color={paint(theme, runStatus.color)}>{runStatus.icon} </Text>
              {/* nf-md-sitemap */}
              <Text color={theme?.ansi.blue}>{"\u{f0491}"} workflow</Text>{" "}
              <Text dimColor>
                {row.run.runId.slice(-6)} · {runAgents.length} agent{runAgents.length > 1 ? "s" : ""}
              </Text>
            </Text>
          );
        }
        const { guide, underGuide, agent } = row;
        const agentStatus = AGENT_STATUS[agent.status] ?? UNKNOWN_STATUS;
        const model = modelIcon(agent.model);
        const counter = ` ${agent.stepsDone}/${agent.stepsStarted}`;
        // still running: counts up to now, the pane's 10s redraw moves it
        const elapsedSeconds =
          agent.startedAt === undefined
            ? undefined
            : Math.floor(((agent.endedAt ?? nowMs) - agent.startedAt) / 1000);
        const children = subagentCounts.get(agent.id) ?? NO_CHILDREN;
        return (
          <Box key={agent.id} flexDirection="column">
            {/* a click shows this agent's transcript in the main view; `hover` keeps the line unchanged
                under the pointer (see unInverted): every part, spaces included, carries its own colors,
                gray rather than dimColor; the keyed Box is the area that hovers, this line alone */}
            <Box key={`row-${agent.id}`} flexDirection="row">
              <Button key={`view-${agent.id}`} plain onPress={() => onViewAgent(agent.id)}>
                <Text wrap="truncate-end">
                  <Text color={theme?.dimmed} hover={unInverted(theme, theme?.dimmed)}>{guide}</Text>
                  <Text
                    color={paint(theme, agentStatus.color)}
                    hover={unInverted(theme, paint(theme, agentStatus.color))}
                  >
                    {agentStatus.icon}{" "}
                  </Text>
                  <Text
                    color={paint(theme, model.color)}
                    hover={unInverted(theme, paint(theme, model.color))}
                  >
                    {model.glyph}{" "}
                  </Text>
                  <Text
                    color={theme?.ansi.cyan}
                    hover={unInverted(theme, theme?.ansi.cyan)}
                    underline={agent.id === viewedAgentId}
                  >
                    {agent.type}
                  </Text>
                  <Text color={theme?.dimmed} hover={unInverted(theme, theme?.dimmed)}>{" "}</Text>
                  {elapsedSeconds !== undefined && (
                    <Text color={theme?.ansi.magenta} hover={unInverted(theme, theme?.ansi.magenta)}>
                      ⏱ {fmtElapsed(elapsedSeconds)}{" "}
                    </Text>
                  )}
                  {/* running children stand out, finished ones gray: ⑂2 +3 */}
                  {children.running > 0 && (
                    <Text color={theme?.ansi.blue} hover={unInverted(theme, theme?.ansi.blue)}>
                      ⑂{children.running}{" "}
                    </Text>
                  )}
                  {children.finished > 0 && (
                    <Text color={theme?.dimmed} hover={unInverted(theme, theme?.dimmed)}>
                      {children.running > 0 ? "+" : "⑂"}
                      {children.finished}{" "}
                    </Text>
                  )}
                  <Text color={theme?.dimmed} hover={unInverted(theme, theme?.dimmed)}>
                    {agent.description}
                  </Text>
                </Text>
              </Button>
            </Box>
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
