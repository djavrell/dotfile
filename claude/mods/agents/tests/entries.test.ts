import { expect, test } from 'claude-code/testing'

import { MAX_ENTRIES, mergeListed, newEntry, patchEntry, resumed, statusOfEnd, stepStarted, upsertEntry } from '../hooks/lib/entries'

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
  ], 0)
  expect(merged.map(entry => [entry.id, entry.status])).toEqual([
    ['a1', 'completed'],
    ['gone', 'running'],
    ['fork', 'running'],
  ])
  expect(merged[2]?.parentId).toBe('a1')
})

test('a list refresh keeps the workflow run of an agent', () => {
  const workflow = { runId: 'wf_1', agentIndex: 2 }
  const [entry] = mergeListed([newEntry({ ...explore, workflow })], [
    { id: 'a1', type: 'Explore', description: 'find things', status: 'completed' },
  ], 0)
  expect(entry?.workflow).toEqual(workflow)
})

test('end reason to status', () => {
  expect(statusOfEnd('answer')).toBe('completed')
  expect(statusOfEnd('aborted')).toBe('killed')
  expect(statusOfEnd('error')).toBe('failed')
})

test('a step on a finished agent marks it running again', () => {
  const finished = { ...explore, status: 'completed', endedAt: 5, endReason: 'answer' }
  expect(stepStarted(finished, 'haiku')).toEqual({ stepsStarted: 1, model: 'haiku', status: 'running', endedAt: undefined, endReason: undefined })
  expect(stepStarted(explore, 'haiku')).toEqual({ stepsStarted: 1, model: 'haiku' })
})

test('a resume undoes the end, keeps start and parent', () => {
  const finished = { ...explore, parentId: 'main', startedAt: 1, status: 'completed', endedAt: 5, endReason: 'answer' }
  const [entry] = patchEntry([finished], 'a1', resumed)
  expect(entry).toMatchObject({ parentId: 'main', startedAt: 1, status: 'running' })
  expect(entry?.endedAt).toBeUndefined()
  expect(entry?.endReason).toBeUndefined()
})

test('start of agents born without a spawn: first step seen, else now for a new one only', () => {
  const spawned = newEntry({ ...explore, startedAt: 100 })
  // known from before a reload, already ended, no start: "now" would come after its end
  const ended = newEntry({ ...explore, id: 'ended', status: 'completed', endedAt: 300 })
  const merged = mergeListed([spawned, ended], [
    { id: 'a1', type: 'Explore', description: 'find things', status: 'running', startedAt: 500 },
    { id: 'ended', type: 'general-purpose', description: 'code-review', status: 'completed' },
    { id: 'fork', type: 'general-purpose', description: 'code-review', status: 'running', startedAt: 200 },
    { id: 'unseen', type: 'general-purpose', description: 'code-review', status: 'running' },
  ], 900)
  expect(merged.map(entry => [entry.id, entry.startedAt])).toEqual([['a1', 100], ['ended', undefined], ['fork', 200], ['unseen', 900]])
})
