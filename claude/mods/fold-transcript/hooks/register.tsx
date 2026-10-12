// Folds Agent and Bash results and agents' messages in the transcript to one dim line with a [+] button; [−] folds them back.
// Only the drawing changes: the model reads the whole text.
import { atom, read, update } from "claude-code";
import type { EngineInterface, Register } from "claude-code";

import { foldSummary, reportBody, resultText } from "./lib/fold";

// the user-role rows another party wrote: a background task's notification, a message from an agent
const FOLDED_MESSAGE_ORIGINS = new Set(["task-notification", "peer"]);

// ponytail: grows with every row unfolded in the session, pruned on session.start if it ever matters
const unfolded = atom({ plugin: "fold-transcript", key: "unfolded" } as const, []);

const isUnfolded = async ($: EngineInterface, rowId: string) => (await read($, unfolded)).includes(rowId);

function setUnfolded($: EngineInterface, rowId: string, shouldUnfold: boolean) {
  return update($, unfolded, (ids) => (shouldUnfold ? [...ids, rowId] : ids.filter((id) => id !== rowId)));
}

export const register: Register = (on) => {
  // An Agent's result has its own ToolResult block under the call's row.
  on("ui.render", { component: "ToolResult", props: { tool: "Agent" } }, async ($, event, next) => {
    const { tool_use_id: toolUseId, output, isErrored } = event.props;
    const summary = isErrored ? null : foldSummary(resultText(output));
    if (!summary) return next(event);

    const { Box, Button, Text } = $.ui.resolve(event);
    if (await isUnfolded($, toolUseId)) {
      return (
        <Box flexDirection="column">
          {await next(event)}
          <Button key={`fold-${toolUseId}`} plain onPress={() => setUnfolded($, toolUseId, false)}>
            <Text dimColor>[−] replier</Text>
          </Button>
        </Box>
      );
    }
    return (
      <Button key={`fold-${toolUseId}`} plain onPress={() => setUnfolded($, toolUseId, true)}>
        <Text dimColor wrap="truncate-end">[+] {summary}</Text>
      </Button>
    );
  });

  // Bash raises no ToolResult (seen live): its output is drawn inside the call's ToolUse row, so the row is
  // drawn with an emptied output, the `Bash(...)` line alone, and the fold line under it.
  on("ui.render", { component: "ToolUse", props: { tool: "Bash" } }, async ($, event, next) => {
    const { tool_use_id: toolUseId, output, isRunning, isErrored } = event.props;
    const summary = isRunning || isErrored ? null : foldSummary(resultText(output));
    if (!summary) return next(event);

    const { Box, Button, Text } = $.ui.resolve(event);
    if (await isUnfolded($, toolUseId)) {
      return (
        <Box flexDirection="column">
          {await next(event)}
          <Button key={`fold-${toolUseId}`} plain onPress={() => setUnfolded($, toolUseId, false)}>
            <Text dimColor>[−] replier</Text>
          </Button>
        </Box>
      );
    }
    const emptiedOutput = { ...(output as Record<string, unknown>), stdout: "", stderr: "" };
    return (
      <Box flexDirection="column">
        {await next({ ...event, props: { ...event.props, output: emptiedOutput } })}
        <Button key={`fold-${toolUseId}`} plain onPress={() => setUnfolded($, toolUseId, true)}>
          <Text dimColor wrap="truncate-end">[+] {summary}</Text>
        </Button>
      </Box>
    );
  });

  // An agent's report or a task's notification. Folded even when isExpanded: that is true for ctrl+o but also for
  // any body short enough to fit under the sender's label (seen live), so ctrl+o shows it folded too, [+] still works.
  on("ui.render", { component: "UserMessage" }, async ($, event, next) => {
    const { origin, text, from } = event.props;
    if (!FOLDED_MESSAGE_ORIGINS.has(origin.kind)) return next(event);
    const summary = foldSummary(reportBody(text));
    const rowId = event.requestId;
    if (!summary || !rowId) return next(event);

    const { Box, Button, Text } = $.ui.resolve(event);
    if (await isUnfolded($, rowId)) {
      return (
        <Box flexDirection="column">
          {await next(event)}
          <Button key={`fold-${rowId}`} plain onPress={() => setUnfolded($, rowId, false)}>
            <Text dimColor>[−] replier</Text>
          </Button>
        </Box>
      );
    }
    return (
      <Button key={`fold-${rowId}`} plain onPress={() => setUnfolded($, rowId, true)}>
        <Text dimColor wrap="truncate-end">
          [+] {from ? `${from.name} · ` : ""}
          {summary}
        </Text>
      </Button>
    );
  });
};
