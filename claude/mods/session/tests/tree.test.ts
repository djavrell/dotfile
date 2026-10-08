import { expect, test } from 'claude-code/testing'

import { buildTree, displayPath } from '../hooks/lib/tree'

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

test('shows paths from the repo root, else from ~', () => {
  const pathRoots = { repo: '/home/me/repo', home: '/home/me' }
  expect(displayPath('/home/me/repo/src/a.ts', pathRoots)).toBe('src/a.ts')
  expect(displayPath('/home/me/notes/b.md', pathRoots)).toBe('~/notes/b.md')
  expect(displayPath('/etc/hosts', pathRoots)).toBe('/etc/hosts')
  expect(displayPath('/etc/hosts', null)).toBe('/etc/hosts')
})
