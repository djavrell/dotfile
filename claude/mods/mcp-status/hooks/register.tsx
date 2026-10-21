// The MCP servers' health: listed by `claude mcp list` (at session start and on /mcp-health), then moved by the
// session's own mcp__* calls; published as the `servers` and `notes` states. Drawing belongs to the consumers (the
// session pane's MCP section). The atoms stay in this file with their read/update calls (the validator wants them
// together); parsing and the status rules live in lib/servers.ts.
import { atom, read, update } from "claude-code";
import type { EngineInterface, Register } from "claude-code";

import {
  callOutcome,
  failedCall,
  formatHealth,
  mergeHealth,
  parseMcpList,
  recordCall,
  serverKeyOfTool,
} from "./lib/servers";
import type { CallOutcome } from "./lib/servers";

const servers = atom({ plugin: "mcp-status", key: "servers" } as const, []);
const notes = atom({ plugin: "mcp-status", key: "notes" } as const, []);

// bumped by every check: a run that is no longer the latest drops its result
let checkGeneration = 0;

// no mod API lists the session's MCP servers or their state: the CLI's health check stands in, run in the session's
// cwd so project servers count. It can differ from the session (another auth source, servers added since)
// ponytail: ~3 s and it starts each stdio server once to probe it; a session-side status API if mods ever get one
async function checkHealth($: EngineInterface) {
  const thisGeneration = ++checkGeneration;
  const listing = await $.process.run(["claude", "mcp", "list"]);
  if (thisGeneration !== checkGeneration) return;
  if (listing.exitCode !== 0) {
    const reason = listing.stderr.trim() || `exit code ${listing.exitCode}`;
    await update($, notes, () => [`claude mcp list failed: ${reason}`]);
    return;
  }
  // the CLI writes its warnings to stderr and the servers to stdout
  const parsed = parseMcpList(`${listing.stderr}\n${listing.stdout}`);
  await update($, servers, (previous) => mergeHealth(previous, parsed.servers));
  await update($, notes, () => parsed.notes);
}

async function recordOutcome(
  $: EngineInterface,
  key: string,
  outcome: CallOutcome,
) {
  if (!outcome) return;
  await update($, servers, (previous) => recordCall(previous, key, outcome));
}

export const register: Register = (on) => {
  on("session.start", async ($, event, next) => {
    await $.command.register({
      name: "mcp-health",
      description:
        "Check the MCP servers again and list their state with the errors seen this session",
    });
    void checkHealth($).catch(() => {});

    return next(event);
  });

  on("command.run", { command: "mcp-health" }, async ($) => {
    await checkHealth($);

    return { text: formatHealth(await read($, servers), await read($, notes)) };
  });

  // subagents' calls count too: the server is the same
  on("tool.call", async ($, event, next) => {
    const key = serverKeyOfTool(event.tool);
    if (!key) return next(event);
    try {
      const result = await next(event);
      void recordOutcome($, key, callOutcome(event.tool, result)).catch(
        () => {},
      );

      return result;
    } catch (error) {
      void recordOutcome($, key, failedCall(event.tool, String(error))).catch(
        () => {},
      );
      throw error;
    }
  });
};
