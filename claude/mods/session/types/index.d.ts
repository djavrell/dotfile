// added/deleted are null for binary files and untracked files
export type Change = { path: string; added: number | null; deleted: number | null; isNew: boolean }
export type Agent = { id: string; type: string; description: string; status: string }
// model/effort as the last main-loop request named them; effort absent for a model without one
export type ModelInfo = { model: string; effort?: string }

declare module 'claude-code' {
  interface PluginState {
    session: {
      files: Change[]
      agents: Agent[]
      skills: string[]
      info: ModelInfo | null
      branch: string
      tick: number
      // token count auto-compaction runs at; null when it is off or not known yet
      compactAt: number | null
    }
  }
}
