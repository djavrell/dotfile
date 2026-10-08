// One agent of the session as this mod publishes it. Consumers list "agents" under `dependencies`
// in their plugin.json, import this type from "agents", and read the list with
//   read($, atom({ plugin: "agents", key: "list" } as const, []))
export type AgentEntry = {
  id: string
  // the agent that spawned it; absent when the main conversation did
  parentId?: string
  // the agent type it was spawned as (general-purpose, Explore, ...)
  type: string
  description: string
  // pending, running, waiting, idle, completed, failed, killed
  status: string
  // the model it runs on, as the engine resolved it (claude-haiku-4-5-..., or an alias)
  model?: string
  background?: boolean
  // $.clock.now() milliseconds
  startedAt?: number
  endedAt?: number
  // why its last turn ended: answer, aborted, refusal, error
  endReason?: string
  // model requests (turn.step) it started, and the ones that came back
  stepsStarted: number
  stepsDone: number
}

declare module 'claude-code' {
  interface PluginState {
    agents: {
      // spawn order, oldest first; finished agents are kept (the engine's own list drops them)
      list: AgentEntry[]
    }
  }
}
