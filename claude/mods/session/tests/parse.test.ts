import { expect, test } from 'claude-code/testing'

import { fmtTokens, parseNumstat, parseUntracked } from '../hooks/register'

test('parses numstat lines, binary as null', () => {
  expect(parseNumstat('12\t3\tsrc/a.ts\n-\t-\timg.png\n')).toEqual([
    { path: 'src/a.ts', added: 12, deleted: 3, isNew: false },
    { path: 'img.png', added: null, deleted: null, isNew: false },
  ])
})

test('abbreviates token counts', () => {
  expect(fmtTokens(950)).toBe('950')
  expect(fmtTokens(123_456)).toBe('123k')
  expect(fmtTokens(1_000_000)).toBe('1M')
  expect(fmtTokens(1_500_000)).toBe('1.5M')
})

test('parses untracked files as new', () => {
  expect(parseUntracked('b.ts\n')).toEqual([{ path: 'b.ts', added: null, deleted: null, isNew: true }])
})
