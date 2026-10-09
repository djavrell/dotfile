import { expect, test } from 'claude-code/testing'

import { buildAgentTree } from '../hooks/lib/agentTree'
import { modelIcon } from '../hooks/lib/icons'

test('lines under an agent carry the tree down to siblings and children', () => {
  const rows = buildAgentTree([agent('root', 1), agent('child', 2, 'root'), agent('other', 3)])
  // two columns past the agent's own guide: "│ " down to its children, or "  " for a leaf
  expect(rows.map(row => row.underGuide)).toEqual(['│  │ ', '│       ', '     '])
})

const agent = (id: string, startedAt: number, parentId?: string) => ({
  id, parentId, startedAt, type: 'Explore', description: id, status: 'running', stepsStarted: 0, stepsDone: 0,
})

test('nests agents under their parent, in start order', () => {
  const rows = buildAgentTree([agent('child', 2, 'root'), agent('root', 1), agent('other', 3), agent('grandchild', 4, 'child')])
  expect(rows.map(row => row.guide + row.agent.id)).toEqual([
    '├─ root',
    '│  └─ child',
    '│     └─ grandchild',
    '└─ other',
  ])
})

test('an agent whose parent is unknown is a root', () => {
  expect(buildAgentTree([agent('orphan', 1, 'gone')]).map(row => row.guide + row.agent.id)).toEqual(['└─ orphan'])
})

test('model icon by family, from an id or an alias', () => {
  expect(modelIcon('claude-haiku-4-5-20251001').glyph).toBe('')
  expect(modelIcon('opus').glyph).toBe('')
  expect(modelIcon(undefined).glyph).toBe('')
})
