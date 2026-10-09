import { expect, test } from 'claude-code/testing'

import { buildTree } from '../hooks/lib/tree'

test('builds a tree, folders first, single-folder chains merged', () => {
  const rows = buildTree([{ path: 'c.md' }, { path: 'a/b/x.ts' }, { path: 'a/b/y.ts' }, { path: 'a/z.ts' }])
  expect(rows.map(row => row.branch + row.label)).toEqual([
    '├─ a/',
    '│  ├─ b/',
    '│  │  ├─ x.ts',
    '│  │  └─ y.ts',
    '│  └─ z.ts',
    '└─ c.md',
  ])
  expect(rows[2]?.item).toEqual({ path: 'a/b/x.ts' })
  expect(rows[0]?.item).toBeUndefined()
})

test('merges a folder that only holds one folder', () => {
  const rows = buildTree([{ path: 'claude/mods/session/hooks/register.tsx' }, { path: 'claude/mods/session/types/index.d.ts' }])
  expect(rows.map(row => row.branch + row.label)).toEqual([
    '└─ claude/mods/session/',
    '   ├─ hooks/',
    '   │  └─ register.tsx',
    '   └─ types/',
    '      └─ index.d.ts',
  ])
})
