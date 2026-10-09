// LSP-first guards, as a mod. Four hooks:
//   1. a Bash command that greps for a code symbol, or writes a source file, is refused (lib/grep.ts, lib/write.ts);
//   2. Read calls are noted, so cclsp can be primed on a file the session already opened;
//   3. a cclsp call that hit the server's cold start ("No Project") is primed and run again, transparently;
//   4. every LSP-first refusal, this mod's and the classic hooks', is drawn as one dim line in the transcript.
// Plugin hooks run above the classic PreToolUse hooks, so this mod judges a call first.
// $ stays in this file (the validator does not follow it across an import); the judging is pure, in lib/.
import type { EngineInterface, McpToolResult, Register } from "claude-code";

import { compactDenial, grepDenial, writeDenial } from "./lib/denials";
import { grepSymbols } from "./lib/grep";
import { shellWriteTarget } from "./lib/write";

const CCLSP_SERVER = "cclsp";
const CCLSP_TOOL_PREFIX = `mcp__${CCLSP_SERVER}__`;
// what cclsp answers until a file-scoped call has primed its project (ktnyt/cclsp#43)
const COLD_START_ERROR = /No Project\.|ThrowNoProject|Server not initialized|Project not loaded|LSP server.*not ready/i;
const SOURCE_FILE = /\.(?:ts|tsx|js|jsx|mjs|cjs|py)$/i;
// the fields of a tool.call event that are no argument of the MCP tool itself
const EVENT_ENVELOPE_FIELDS = new Set(["tool", "tool_use_id", "agentId", "requestMeta"]);

// the last source file Read opened: cclsp is primed on it when the failed call names no file of its own
let lastSourceFileRead = "";

const textOf = (mcpResult: McpToolResult) =>
  mcpResult.content.map((block) => ("text" in block && typeof block.text === "string" ? block.text : "")).join("\n");

// Primes cclsp with a file-scoped call (get_diagnostics), then makes the failed call again.
// Resolves the new result, or null when there is no file to prime with or the call still fails.
async function primeAndRetry($: EngineInterface, toolName: string, toolArguments: Record<string, unknown>) {
  const primingFile = typeof toolArguments.file_path === "string" ? toolArguments.file_path : lastSourceFileRead;
  if (!primingFile) return null;
  await $.mcp.call(CCLSP_SERVER, "get_diagnostics", { file_path: primingFile });
  const retried = await $.mcp.call(CCLSP_SERVER, toolName, toolArguments);
  return retried.isError || COLD_START_ERROR.test(textOf(retried)) ? null : retried;
}

export const register: Register = (on) => {
  // 1. No .catch on purpose: a guard that throws lets the command through (the engine says so in a dim line),
  //    rather than refusing every shell command until the bug is fixed.
  on("tool.call", { tool: "Bash" }, ($, event, next) => {
    const symbols = grepSymbols(event.command);
    if (symbols.length > 0) return { deny: grepDenial(symbols) };

    const writtenSourceFile = shellWriteTarget(event.command);
    if (writtenSourceFile) return { deny: writeDenial(writtenSourceFile) };

    return next(event);
  });

  // 2.
  on("tool.call", { tool: "Read" }, ($, event, next) => {
    if (SOURCE_FILE.test(event.file_path)) lastSourceFileRead = event.file_path;

    return next(event);
  });

  // 3.
  on("tool.call", async ($, event, next) => {
    const ran = await next(event);
    const isCclspCall = event.tool.startsWith(CCLSP_TOOL_PREFIX);
    if (!isCclspCall || ran.deny !== undefined || !COLD_START_ERROR.test(ran.text ?? "")) return ran;

    const toolArguments = Object.fromEntries(
      Object.entries(event).filter(([field]) => !EVENT_ENVELOPE_FIELDS.has(field)),
    );
    const toolName = event.tool.slice(CCLSP_TOOL_PREFIX.length);
    const retried = await primeAndRetry($, toolName, toolArguments).catch(() => null);
    // ponytail: answers with the retry's content blocks; check live how the transcript draws such an MCP result
    return retried ? { result: retried.content } : ran;
  });

  // 4.
  on("ui.render", { component: "ToolResult" }, ($, event, next) => {
    const { isErrored, output } = event.props;
    const denialLine = isErrored && typeof output === "string" ? compactDenial(output) : null;
    if (!denialLine) return next(event);
    const { Text } = $.ui.resolve(event);

    return (
      <Text dimColor wrap="truncate-end">
        {denialLine}
      </Text>
    );
  });
};
