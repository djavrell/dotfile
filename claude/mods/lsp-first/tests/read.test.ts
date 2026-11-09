import { expect, test } from 'claude-code/testing'

import { shellReadTarget } from '../hooks/lib/read'

test('cat, head, tail and sed -n on a source file are refused', () => {
  expect(shellReadTarget('cat src/app.ts')).toBe('src/app.ts')
  expect(shellReadTarget("sed -n '120,180p' src/app.tsx")).toBe('src/app.tsx')
  expect(shellReadTarget('sed -ne "1,20p" db/schema.sql')).toBe('db/schema.sql')
  expect(shellReadTarget('head -n 40 zsh/init.zsh')).toBe('zsh/init.zsh')
  expect(shellReadTarget('tail -20 nvim/init.lua')).toBe('nvim/init.lua')
  expect(shellReadTarget('cat src/app.ts | head -30')).toBe('src/app.ts')
})

test('after a cd or a semicolon, and among several files, the first source file is named', () => {
  expect(shellReadTarget("cd packages/api && sed -n '120,180p' src/x.ts")).toBe('packages/api/src/x.ts')
  expect(shellReadTarget('echo start; cat notes.md src/a.py src/b.py')).toBe('src/a.py')
})

test('the receiving end of a pipe reads stdin and passes', () => {
  expect(shellReadTarget('git log --oneline | head')).toBe(null)
  expect(shellReadTarget('npm run build 2>&1 | tail -30')).toBe(null)
  expect(shellReadTarget('git show HEAD:src/app.ts | head -50')).toBe(null)
})

test('non-source files, typings and scratch paths pass', () => {
  expect(shellReadTarget('tail -100 logs/server.log')).toBe(null)
  expect(shellReadTarget('cat package.json README.md .env.local pnpm-lock.yaml')).toBe(null)
  expect(shellReadTarget('head -40 types/claude-code/index.d.ts')).toBe(null)
  expect(shellReadTarget('cat /tmp/scratch.ts')).toBe(null)
  expect(shellReadTarget('cd /tmp/x/scratchpad && cat v1/register.ts')).toBe(null)
})

test('other programs and other sed uses pass', () => {
  expect(shellReadTarget('git diff src/app.ts')).toBe(null)
  expect(shellReadTarget('wc -l src/app.ts')).toBe(null)
  expect(shellReadTarget('generate | sed "s/a/b/"')).toBe(null)
  expect(shellReadTarget("cat > notes.md <<'MD'\ncat src/app.ts\nMD")).toBe(null)
  expect(shellReadTarget('npx eslint src/app.ts > report.txt')).toBe(null)
})
