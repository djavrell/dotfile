import { expect, test } from 'claude-code/testing'

// the pane reads its atoms through state/ functions: a write made there must still redraw it
const PANE_PROPS = { title: 'Session', isFocused: false, bodyColumns: 70, placement: 'inline', scroll: {} } as never
const USAGE = { rateLimits: [], startedAt: 0, context: { percent: 0, tokens: 0, window: 200_000 } }
const NUMSTAT = '1\t0\tlib/a.ts\n2\t0\tlib/b.ts\n'

// a stand-in palette: the folder lines' hover colors need a theme
const palette = {
  name: 'palette',
  register(on: Parameters<import('claude-code').Register>[0]) {
    const colors = { black: '#000000', red: '#ff0000', green: '#00ff00', yellow: '#ffff00', blue: '#0000ff', magenta: '#ff00ff', cyan: '#00ffff', white: '#ffffff' }
    const theme = { foreground: '#ffffff', background: '#000000', cursor_bg: '#ffffff', cursor_border: '#ffffff', cursor_fg: '#000000', selection_fg: '#000000', selection_bg: '#ffffff', ansi: colors, brights: colors, comment: '#888888', dimmed: '#666666' }
    on('engine.create', async (_hookApi, event, next) => ({ ...(await next(event)), palette: { get: async () => theme } }))
  },
}

test('the pane redraws after an Edit changes files, and on a folder toggle', { plugins: [palette] }, async ($, on) => {
  // beneath the plugin: the session, the clock, the open pane and git
  on('session.usage', () => ({ value: USAGE }) as never)
  on('clock.now', () => ({ value: 0 }) as never)
  on('clock.sleep', () => ({ value: undefined }) as never)
  on('ui.panes', () => ({ value: [{ id: 'session' }] }) as never)
  on('process.run', (_hookApi, event) => {
    const isDiff = JSON.stringify(event).includes('--numstat')
    return { value: { exitCode: 0, stdout: isDiff ? NUMSTAT : '', stderr: '' } } as never
  })
  on('tool.call', { tool: 'Edit' }, () => ({ result: 'ok', text: 'ok' }))

  const pane = await $.ui.mount({ plugin: 'session', surface: 'terminal', component: 'Pane', requestId: 'session', props: PANE_PROPS })
  expect(await pane.find({ key: 'fold-lib' })).toBeUndefined()

  await $.tool.call({ tool: 'Edit', file_path: 'lib/a.ts', old_string: 'a', new_string: 'b' } as never)
  expect(await pane.find({ key: 'fold-lib' })).toBeDefined()
  expect(await pane.find({ type: 'Text', text: /a\.ts/ })).toBeDefined()

  await pane.press({ key: 'fold-lib' })
  expect(await pane.find({ type: 'Text', text: /a\.ts/ })).toBeUndefined()
})
