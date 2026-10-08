// added/deleted are null for binary files and untracked files
export type Change = { path: string; added: number | null; deleted: number | null; isNew: boolean }
// model/effort as the last main-loop request named them; effort absent for a model without one
export type ModelInfo = { model: string; effort?: string }
// where paths are shown from: the repo root (git's paths are relative to it), else the home folder as ~
export type Roots = { repo: string; home: string }

declare module 'claude-code' {
  interface PluginState {
    session: {
      files: Change[]
      skills: string[]
      info: ModelInfo | null
      branch: string
      tick: number
      // token count auto-compaction runs at; null when it is off or not known yet
      compactAt: number | null
      // absolute paths of the files the Read tool opened, oldest first
      readFiles: string[]
      roots: Roots | null
    }
  }
}
