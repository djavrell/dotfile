import { expect, test } from 'claude-code/testing'

// no palette plugin: the theme is undefined, as on a first draw before palette has loaded.
// A folder line's hover once got undefined colors, which the engine refuses for the whole pane
const PANE_PROPS = { title: 'Session', isFocused: false, bodyColumns: 70, placement: 'inline', scroll: {} } as never
const USAGE = { rateLimits: [], startedAt: 0, context: { percent: 0, tokens: 0, window: 200_000 } }
const NUMSTAT = '1\t0\tlib/a.ts\n'

test('a folder line is drawn before palette has loaded', async ($, on) => {
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
  await $.tool.call({ tool: 'Edit', file_path: 'lib/a.ts', old_string: 'a', new_string: 'b' } as never)

  expect(await pane.find({ key: 'fold-lib' })).toBeDefined()
  expect(await pane.find({ type: 'Text', text: /a\.ts/ })).toBeDefined()
})
