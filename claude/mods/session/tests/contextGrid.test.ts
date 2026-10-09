import { expect, test } from 'claude-code/testing'

import { contextCells, sliceRuns } from '../hooks/lib/contextGrid'

const slice = (name: string, tokens: number, kind: 'used' | 'free' | 'buffer' | 'deferred' = 'used') => ({ name, tokens, kind })
const names = (cells: ReturnType<typeof contextCells>) => sliceRuns(cells).map(run => `${run.slice.name}${run.length}`).join(' ')

test('used slices first, then free space, the buffer last', () => {
  const slices = [slice('prompt', 20), slice('messages', 30), slice('free', 30, 'free'), slice('buffer', 20, 'buffer')]
  expect(names(contextCells(slices, 100, 10))).toBe('prompt2 messages3 free3 buffer2')
})

test('a tiny slice keeps one cell, deferred tools take none', () => {
  const slices = [slice('prompt', 1), slice('tools', 50, 'deferred'), slice('messages', 40)]
  expect(names(contextCells(slices, 100, 10))).toBe('prompt1 messages3 Free space6')
})

test('an overfull window stays within the cells', () => {
  expect(contextCells([slice('messages', 500), slice('buffer', 20, 'buffer')], 100, 4)).toHaveLength(4)
})
