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

test('a collapsed folder hides its children and counts its files', () => {
  const items = [{ path: 'a/b/x.ts' }, { path: 'a/b/y.ts' }, { path: 'a/z.ts' }, { path: 'c.md' }]
  const rows = buildTree(items, new Set(['a/b']))
  expect(rows.map(row => row.branch + row.label)).toEqual(['├─ a/', '│  ├─ b/', '│  └─ z.ts', '└─ c.md'])
  expect(rows[1]).toMatchObject({ folderPath: 'a/b', hiddenCount: 2 })
  expect(rows[0]?.hiddenCount).toBeUndefined()
})

test('a merged folder chain folds under its full path', () => {
  const rows = buildTree([{ path: 'claude/mods/session/a.ts' }, { path: 'claude/mods/session/b.ts' }], new Set(['claude/mods/session']))
  expect(rows).toEqual([{ branch: '└─ ', label: 'claude/mods/session/', folderPath: 'claude/mods/session', hiddenCount: 2 }])
})
