import { expect, test } from 'claude-code/testing';

// another mod's `paneRows` write must show in the Tracking section, with no dependency on that mod and outside git
const PANE_PROPS = { title: 'Session', isFocused: false, bodyColumns: 70, placement: 'inline', scroll: {} } as never;
const USAGE = { rateLimits: [], startedAt: 0, context: { percent: 0, tokens: 0, window: 200_000 } };

// a stand-in that publishes a row on a Read. Its code runs as its own module: it sees no constant of this file
const tracker = {
  name: 'tracker',
  register(on: Parameters<import('claude-code').Register>[0]) {
    on('tool.call', async ($, event, next) => {
      const rows = [{ icon: '#', key: 'ISSUE-1', url: 'https://example.com/1', label: 'Fix the parser', status: 'Open', badge: '2 docs' }];
      await $.state.set({ plugin: 'tracker', key: 'paneRows' } as never, rows as never);
      return next(event);
    });
  },
};

test('a row another mod publishes shows under Tracking', { plugins: [tracker] }, async ($, on) => {
  on('session.usage', () => ({ value: USAGE }) as never);
  on('clock.now', () => ({ value: 0 }) as never);
  on('ui.panes', () => ({ value: [{ id: 'session' }] }) as never);
  on('process.run', () => ({ value: { exitCode: 0, stdout: '', stderr: '' } }) as never);
  on('tool.call', { tool: 'Read' }, () => ({ result: 'ok', text: 'ok' }));

  const pane = await $.ui.mount({ plugin: 'session', surface: 'terminal', component: 'Pane', requestId: 'session', props: PANE_PROPS });
  expect(await pane.find({ type: 'Text', text: /Tracking/ })).toBeUndefined();

  await $.tool.call({ tool: 'Read', file_path: '/tmp/x' } as never);
  expect(await pane.find({ type: 'Text', text: /Tracking/ })).toBeDefined();
  expect(await pane.find({ type: 'Text', text: /Fix the parser/ })).toBeDefined();
  expect(await pane.find({ type: 'Text', text: /2 docs/ })).toBeDefined();
});
