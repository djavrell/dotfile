// added/deleted are null for binary files and untracked files
export type Change = { path: string; added: number | null; deleted: number | null; isNew: boolean }
// model/effort as the last main-loop request named them; effort absent for a model without one
export type ModelInfo = { model: string; effort?: string }
// one /context row, slimmed to what the pane draws; kind as ContextCategoryKind (the contract may not import it)
export type ContextSlice = { name: string; tokens: number; kind: 'used' | 'free' | 'buffer' | 'deferred' }
// the /context breakdown: its rows, the window they share, and the token count auto-compaction runs at (null when off);
// cacheReadPercent: the last response's input the prompt cache served, null before the first response
export type ContextInfo = {
  slices: ContextSlice[]
  maxTokens: number
  compactAt: number | null
  cacheReadPercent: number | null
}

// one line another mod adds to the pane's Tracking section (a ticket, an issue): it publishes `paneRows: PaneRow[]` in its own
// state, with no dependency either way, and the pane draws it. key is linked to url when there is one; badge sits on the right
export type PaneRow = {
  icon: string
  key: string
  url: string | null
  label: string
  status: string | null
  badge: string | null
}

declare module 'claude-code' {
  interface PluginState {
    session: {
      // every other mod's last `paneRows` write, by mod name (state/paneRows.ts)
      providedRows: Record<string, PaneRow[]>
      files: Change[]
      skills: string[]
      info: ModelInfo | null
      tick: number
      // the /context breakdown, estimated after each turn; null until the first one
      context: ContextInfo | null
      // folder paths the person folded in the Files tree (a click on the folder's line)
      collapsedFolders: string[]
    }
  }
}
