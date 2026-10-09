import { expect, test } from 'claude-code/testing'

import { shellWriteTarget } from '../hooks/lib/write'

test('redirects, tee and sed -i into a source file are refused', () => {
  expect(shellWriteTarget("cat > src/app.ts <<'TS'\nexport const x = 1\nTS")).toBe('src/app.ts')
  expect(shellWriteTarget('echo x >> src/app.ts')).toBe('src/app.ts')
  expect(shellWriteTarget('generate | tee src/app.ts')).toBe('src/app.ts')
  expect(shellWriteTarget('sed -i "s/a/b/" src/app.ts')).toBe('src/app.ts')
})

test("a script's write call is judged by the path it names", () => {
  expect(shellWriteTarget("python3 - <<'PY'\nopen('src/app.tsx', 'w').write(x)\nPY")).toBe('src/app.tsx')
  expect(shellWriteTarget("python3 - <<'PY'\nPath('src/app.ts').write_text(x)\nPY")).toBe('src/app.ts')
  // writes a .json while mentioning a .ts
  expect(shellWriteTarget("python3 - <<'PY'\nsource = 'a.ts'\nopen('out.json', 'w').write(source)\nPY")).toBe(null)
})

test('reads, other targets and scratch paths pass', () => {
  expect(shellWriteTarget('cat src/app.ts')).toBe(null)
  expect(shellWriteTarget('sed -n "1,20p" src/app.ts')).toBe(null)
  expect(shellWriteTarget('npx eslint src/app.ts > report.txt')).toBe(null)
  expect(shellWriteTarget('echo x > data.csv')).toBe(null)
  expect(shellWriteTarget('echo x > /tmp/scratch.ts')).toBe(null)
})

test('the source inside a heredoc body is no redirect', () => {
  expect(shellWriteTarget("cat > notes.md <<'MD'\nconst f = () => import('./x.ts')\nMD")).toBe(null)
})
