// the id of each folded row the person unfolded (a tool_use_id, or a message's id), in click order
export type UnfoldedRows = string[]

declare module 'claude-code' {
  interface PluginState {
    'fold-transcript': {
      unfolded: UnfoldedRows
    }
  }
}
