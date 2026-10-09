// added/deleted are null for binary files and untracked files
export type Change = { path: string; added: number | null; deleted: number | null; isNew: boolean }
// model/effort as the last main-loop request named them; effort absent for a model without one
export type ModelInfo = { model: string; effort?: string }
// one /context row, slimmed to what the pane draws; kind as ContextCategoryKind (the contract may not import it)
export type ContextSlice = { name: string; tokens: number; kind: 'used' | 'free' | 'buffer' | 'deferred' }
// the /context breakdown: its rows, the window they share, and the token count auto-compaction runs at (null when off)
export type ContextInfo = { slices: ContextSlice[]; maxTokens: number; compactAt: number | null }

declare module 'claude-code' {
  interface PluginState {
    session: {
      files: Change[]
      skills: string[]
      info: ModelInfo | null
      tick: number
      // the /context breakdown, estimated after each turn; null until the first one
      context: ContextInfo | null
    }
  }
}
