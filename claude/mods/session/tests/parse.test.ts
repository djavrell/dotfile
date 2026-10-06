import { expect, test } from 'claude-code/testing'

import { parseNumstat, parseUntracked } from '../hooks/register'

test('parses numstat lines, binary as null', () => {
  expect(parseNumstat('12\t3\tsrc/a.ts\n-\t-\timg.png\n')).toEqual([
    { path: 'src/a.ts', added: 12, deleted: 3, isNew: false },
    { path: 'img.png', added: null, deleted: null, isNew: false },
  ])
})

test('parses untracked files as new', () => {
  expect(parseUntracked('b.ts\n')).toEqual([{ path: 'b.ts', added: null, deleted: null, isNew: true }])
})
