// added/deleted are null for binary files and untracked files
export type Change = { path: string; added: number | null; deleted: number | null; isNew: boolean }
export type Agent = { id: string; type: string; description: string; status: string }

declare module 'claude-code' {
  interface PluginState {
    session: { files: Change[]; agents: Agent[]; skills: string[] }
  }
}
