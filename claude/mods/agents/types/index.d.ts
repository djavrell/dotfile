// One agent of the session as this mod publishes it. Consumers list "agents" under `dependencies`
// in their plugin.json, import this type from "agents", and read the list with
//   read($, atom({ plugin: "agents", key: "list" } as const, []))
export type AgentEntry = {
  id: string
  // the agent type it was spawned as (general-purpose, Explore, ...)
  type: string
  description: string
  // pending, running, waiting, idle, completed, failed, killed
  status: string
}

declare module 'claude-code' {
  interface PluginState {
    agents: {
      // the engine's current agents; it drops finished ones from its list shortly after they end
      list: AgentEntry[]
    }
  }
}
