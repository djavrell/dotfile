# agents

Single source of the session's subagents. The mod collects every agent the session spawns and keeps the list as state
(`agents.list`, oldest first), so other mods can show or react to agents without tracking them on their own.

It draws nothing itself: panes, bands and toasts read that state. Another mod gets it by listing `agents` under its
`dependencies`. The `session` pane is the current consumer.

## Example

One entry of the list:

```json
{ "id": "a1b2c3", "type": "Explore", "description": "find the config loader", "status": "completed" }
```
