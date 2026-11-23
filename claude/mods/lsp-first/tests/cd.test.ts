import { expect, test } from 'claude-code/testing';

import { leadingCdTarget } from '../hooks/lib/cd';

test('a leading cd followed by && or ; is refused', () => {
  expect(leadingCdTarget('cd x && npm test')).toBe('x');
  expect(leadingCdTarget('cd /home/me/project/x && npm test')).toBe('/home/me/project/x');
  expect(leadingCdTarget('cd crates/foo; cargo test')).toBe('crates/foo');
  expect(leadingCdTarget('cd "my dir" && ls')).toBe('my dir');
});

test('a lone cd, a later cd, a quoted cd and a scratch cd pass', () => {
  expect(leadingCdTarget('cd x')).toBe(null);
  expect(leadingCdTarget('npm test && cd x')).toBe(null);
  expect(leadingCdTarget('git commit -m "cd x && y"')).toBe(null);
  expect(leadingCdTarget('cd /tmp/x/scratchpad && npm test')).toBe(null);
  expect(leadingCdTarget('cd /home/me/scratchpad && npm test')).toBe(null);
});
