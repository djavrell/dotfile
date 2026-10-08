import { expect, test } from 'claude-code/testing'

import { MAX_ENTRIES, mergeListed, newEntry, patchEntry, statusOfEnd, upsertEntry } from '../hooks/lib/entries'

const explore = newEntry({ id: 'a1', type: 'Explore', description: 'find things', status: 'running' })

test('upsert adds once, keeps step counters on update', () => {
  const counted = patchEntry(upsertEntry([], explore), 'a1', () => ({ stepsStarted: 3, stepsDone: 2 }))
  const updated = upsertEntry(counted, { ...explore, description: 'renamed' })
  expect(updated).toHaveLength(1)
  expect(updated[0]).toMatchObject({ description: 'renamed', stepsStarted: 3, stepsDone: 2 })
})

test('keeps only the last entries', () => {
  let entries = [explore]
  for (let index = 0; index < MAX_ENTRIES + 5; index++) entries = upsertEntry(entries, newEntry({ ...explore, id: `x${index}` }))
  expect(entries).toHaveLength(MAX_ENTRIES)
  expect(entries.some(entry => entry.id === 'a1')).toBe(false)
})

test('patch ignores ids never seen', () => {
  expect(patchEntry([explore], 'unknown', () => ({ status: 'failed' }))).toEqual([explore])
})

test('merge takes statuses, adds unseen agents, keeps dropped ones', () => {
  const merged = mergeListed([explore, newEntry({ ...explore, id: 'gone' })], [
    { id: 'a1', type: 'Explore', description: 'find things', status: 'completed' },
    { id: 'fork', parentId: 'a1', type: 'general-purpose', description: 'skill', status: 'running' },
  ])
  expect(merged.map(entry => [entry.id, entry.status])).toEqual([
    ['a1', 'completed'],
    ['gone', 'running'],
    ['fork', 'running'],
  ])
  expect(merged[2]?.parentId).toBe('a1')
})

test('end reason to status', () => {
  expect(statusOfEnd('answer')).toBe('completed')
  expect(statusOfEnd('aborted')).toBe('killed')
  expect(statusOfEnd('error')).toBe('failed')
})
