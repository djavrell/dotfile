# mcp-status

Publishes the MCP servers' health as state, for other mods to draw: the `session` pane shows them in its MCP section, a dot
colored by status. It runs `claude mcp list` at session start and on `/mcp-health`, then follows the session's own MCP calls
(subagents' included). It draws nothing itself.

| Status    | Means                                                                  |
|-----------|------------------------------------------------------------------------|
| `idle`    | connected, not called yet this session                                 |
| `ok`      | its last call answered                                                 |
| `warning` | a call returned an error, or the server needs sign-in                  |
| `error`   | the health check could not connect, or a call found the server down    |

No mod API lists the session's servers: the CLI's check stands in, so the list can differ from the session's (claude.ai
connectors turned off by another auth source, servers added since start). A server it misses joins on its first call.

## Example

```
/mcp-health    check the servers again, list their state and the errors seen this session
```

A consumer lists `mcp-status` under `dependencies` in its `plugin.json`, then reads:

```tsx
const servers = await read($, atom({ plugin: "mcp-status", key: "servers" } as const, []));
```
