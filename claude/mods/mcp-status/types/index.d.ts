// The MCP servers as this mod publishes them. Consumers list "mcp-status" under `dependencies` in their plugin.json,
// import these types from "mcp-status", and read them with
//   read($, atom({ plugin: "mcp-status", key: "servers" } as const, []))
// idle: connected, not called yet this session; ok: answered; warning: a call errored or it needs sign-in;
// error: the health check failed or a call found it down
export type McpStatus = 'idle' | 'ok' | 'warning' | 'error'

export type McpServer = {
  // the name /mcp and `claude mcp list` show; a server only seen through its calls keeps its tool-name spelling
  name: string
  // the name as tool names spell it (`plugin_playwright_playwright`), how calls find their server
  key: string
  status: McpStatus
  // the health check's own words (`Connected`, `Failed to connect`); null when it did not list the server
  health: string | null
  // the last errors and warnings seen this session, oldest first
  issues: string[]
}

declare module 'claude-code' {
  interface PluginState {
    'mcp-status': {
      servers: McpServer[]
      // what the health check said beside the servers (a warning line, its own failure)
      notes: string[]
    }
  }
}
