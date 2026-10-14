import type { Register } from 'claude-code'

import { capDiagnostics } from './cap'

// the engine keeps a hook's answer per attachment for the process: each list is cut once, history included
export const register: Register = on => {
  on('prompt.attachment', { type: 'diagnostics' }, async (_, event, next) => next({ ...event, text: capDiagnostics(event.text) }))
}
