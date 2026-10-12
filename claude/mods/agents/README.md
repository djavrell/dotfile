# agents

Single source of the session's agents. The mod collects every agent the session spawns and keeps the list as state
(`agents.list`, oldest first), so other mods can show or react to agents without tracking them on their own.

It draws nothing itself: panes, bands and toasts read that state. Another mod gets it by listing `agents` under its
`dependencies`. The `session` pane is the current consumer.

## Example

One agent of the list (`AgentEntry` in `types/index.d.ts`; `parentId`, `model`, `background`, the times and `endReason` are optional):

```json
{
  "id": "a1b2c3", "type": "Explore", "description": "find the config loader", "status": "completed",
  "model": "claude-haiku-4-5", "background": false, "stepsStarted": 4, "stepsDone": 4,
  "startedAt": 1760000000000, "endedAt": 1760000042000, "endReason": "answer"
}
```
