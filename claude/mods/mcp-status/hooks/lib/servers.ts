import type { McpServer, McpStatus } from "../../types";

// one `claude mcp list` server line: "<name>: <command or url> - <mark> <status words>"; a name may hold
// colons (plugin:playwright:playwright) but never ": ", so the first ": " ends it
const SERVER_LINE = /^(.+?): .* - (\S+)\s+(.+)$/;
const HEALTHY_MARKS = new Set(["✔", "✓"]);
const FAILED_MARKS = new Set(["✗", "✘"]);
// a line of the CLI's own about the listing, such as the claude.ai connectors being disabled
const WARNING_LINE = /^[⚠!]\s*(.+)$/;
// `mcp__<server>__<tool>`
const MCP_TOOL = /^mcp__(.+?)__(.+)$/;
// the words a call's error carries when the server itself is down rather than the call wrong
// ponytail: a word list over the error text, the engine gives no error kind; extend it as new wordings show up
const SERVER_DOWN =
  /not connected|connection closed|ECONNREFUSED|failed to connect|timed out|MCP error -32000/i;
const MAX_ISSUES = 5;
const ISSUE_CHARS = 160;

export type ListedServer = {
  name: string;
  key: string;
  health: string;
  status: McpStatus;
};

// a call's verdict, or null for one that says nothing on the server (the person refused it)
export type CallOutcome = { status: McpStatus; issue?: string } | null;

// how tool names spell a server: what is not a letter, digit, _ or - becomes _ (`claude.ai Asana` -> `claude_ai_Asana`)
export const serverKey = (name: string) => name.replace(/[^A-Za-z0-9_-]/g, "_");

// the server key in an MCP tool's name, undefined for another tool
export const serverKeyOfTool = (toolName: string) =>
  MCP_TOOL.exec(toolName)?.[1];

export function parseMcpList(listing: string): {
  servers: ListedServer[];
  notes: string[];
} {
  const servers: ListedServer[] = [];
  const notes: string[] = [];
  for (const line of listing.split("\n").map((text) => text.trim())) {
    const warning = WARNING_LINE.exec(line);
    if (warning) {
      notes.push(warning[1] ?? line);
      continue;
    }
    const server = SERVER_LINE.exec(line);
    if (!server) continue;
    const [, name = "", mark = "", health = ""] = server;
    servers.push({
      name,
      key: serverKey(name),
      health,
      status: HEALTHY_MARKS.has(mark)
        ? "ok"
        : FAILED_MARKS.has(mark)
          ? "error"
          : "warning",
    });
  }
  return { servers, notes };
}

// the latest word wins: a healthy check reads ok once the server was called this session, idle before;
// a server the check does not list (seen only through its calls) stays as it was
export function mergeHealth(
  previous: readonly McpServer[],
  listed: readonly ListedServer[],
): McpServer[] {
  const merged = listed.map((server): McpServer => {
    const known = previous.find((entry) => entry.key === server.key);
    const wasCalled = known !== undefined && known.status !== "idle";
    return {
      name: server.name,
      key: server.key,
      health: server.health,
      status: server.status === "ok" && !wasCalled ? "idle" : server.status,
      issues: known?.issues ?? [],
    };
  });
  const unlisted = previous.filter(
    (entry) => !listed.some((server) => server.key === entry.key),
  );
  return [...merged, ...unlisted.map((entry) => ({ ...entry, health: null }))];
}

// what a tool.call result says on its server; `toolName` is the full mcp__ name
export function callOutcome(
  toolName: string,
  result: { deny?: string; isError?: boolean; text?: string },
): CallOutcome {
  if (result.deny !== undefined) return null;
  if (!result.isError) return { status: "ok" };
  return failedCall(toolName, result.text ?? "error");
}

// a call that errored, or threw: red when the words say the server is down, yellow when only the call failed
export function failedCall(toolName: string, errorText: string): CallOutcome {
  const shortTool = MCP_TOOL.exec(toolName)?.[2] ?? toolName;
  const firstLine = errorText.split("\n").find(Boolean) ?? errorText;
  return {
    status: SERVER_DOWN.test(errorText) ? "error" : "warning",
    issue: `${shortTool}: ${firstLine.slice(0, ISSUE_CHARS)}`,
  };
}

// a server unknown so far (not listed by the check) joins under its key
export function recordCall(
  servers: readonly McpServer[],
  key: string,
  outcome: NonNullable<CallOutcome>,
): McpServer[] {
  const known = servers.find((server) => server.key === key) ?? {
    name: key,
    key,
    status: "idle",
    health: null,
    issues: [],
  };
  const updated: McpServer = {
    ...known,
    status: outcome.status,
    issues: outcome.issue
      ? [...known.issues, outcome.issue].slice(-MAX_ISSUES)
      : known.issues,
  };
  return servers.some((server) => server.key === key)
    ? servers.map((server) => (server.key === key ? updated : server))
    : [...servers, updated];
}

// /mcp-health's report: one line per server, its issues under it, then the check's notes
export function formatHealth(
  servers: readonly McpServer[],
  notes: readonly string[],
): string {
  if (servers.length === 0 && notes.length === 0) return "No MCP server.";
  const lines = servers.flatMap((server) => [
    `${server.status.padEnd(7)} ${server.name}${server.health ? ` · ${server.health}` : ""}`,
    ...server.issues.map((issue) => `          ${issue}`),
  ]);
  return [...lines, ...notes.map((note) => `⚠ ${note}`)].join("\n");
}
