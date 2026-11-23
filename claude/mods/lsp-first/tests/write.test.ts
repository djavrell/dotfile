import { expect, test } from 'claude-code/testing';

import { shellWriteTarget } from '../hooks/lib/write';

test('redirects, tee and sed -i into a source file are refused', () => {
  expect(shellWriteTarget("cat > src/app.ts <<'TS'\nexport const x = 1\nTS")).toBe('src/app.ts');
  expect(shellWriteTarget('echo x >> src/app.ts')).toBe('src/app.ts');
  expect(shellWriteTarget('generate | tee src/app.ts')).toBe('src/app.ts');
  expect(shellWriteTarget('sed -i "s/a/b/" src/app.ts')).toBe('src/app.ts');
});

test('authored text, tee and in-place edits are refused for any project file, whatever its extension', () => {
  expect(shellWriteTarget("cat > notes.md <<'MD'\nconst f = () => import('./x.ts')\nMD")).toBe('notes.md');
  expect(shellWriteTarget("printf '%s\\n' '- item' >> CLAUDE.md")).toBe('CLAUDE.md');
  expect(shellWriteTarget('echo x > "my notes.md"')).toBe('my notes.md');
  expect(shellWriteTarget('echo x > data.csv')).toBe('data.csv');
  expect(shellWriteTarget('generate | tee -a zsh/function.d/nf_range')).toBe('zsh/function.d/nf_range');
  expect(shellWriteTarget("sed -i 's/^status: .*/status: done/' tickets/a.md tickets/b.md")).toBe('tickets/a.md');
  expect(shellWriteTarget("perl -pi -e 's/a/b/' README.md")).toBe('README.md');
});

test("a script's write call is judged by the path it names or the variable holding it", () => {
  expect(shellWriteTarget("python3 - <<'PY'\nopen('src/app.tsx', 'w').write(x)\nPY")).toBe('src/app.tsx');
  expect(shellWriteTarget("python3 - <<'PY'\nPath('src/app.ts').write_text(x)\nPY")).toBe('src/app.ts');
  const viaVariable = "python3 - <<'PY'\ntarget = Path('/home/me/repo/src/lib.rs')\ntarget.write_text(target.read_text().replace(a, b))\nPY";
  expect(shellWriteTarget(viaVariable)).toBe('/home/me/repo/src/lib.rs');
  // writes scratch while mentioning a .ts
  const toScratch = "python3 - <<'PY'\nsource = 'a.ts'\nout = '/tmp/x/out.json'\nopen(out, 'w').write(source)\nPY";
  expect(shellWriteTarget(toScratch)).toBe(null);
});

test('reads, logs, quoted arrows and scratch paths pass', () => {
  expect(shellWriteTarget('cat src/app.ts')).toBe(null);
  expect(shellWriteTarget('sed -n "1,20p" src/app.ts')).toBe(null);
  expect(shellWriteTarget('npx eslint src/app.ts > report.txt 2>&1')).toBe(null);
  expect(shellWriteTarget('git commit -m "pane -> band, a > b.md"')).toBe(null);
  expect(shellWriteTarget('echo "a > b.md" | wc -c')).toBe(null);
  expect(shellWriteTarget('echo x > /dev/null')).toBe(null);
  expect(shellWriteTarget('echo x > /tmp/scratch.ts')).toBe(null);
  expect(shellWriteTarget("cat > /tmp/x/scratchpad/notes.md <<'MD'\n# n\nMD")).toBe(null);
});

test('a target relative to a cd, or behind a variable set in the command, is judged where it lands', () => {
  expect(shellWriteTarget('cd /tmp/x/scratchpad && sed -i "s/a/b/" v1/hooks/register.ts')).toBe(null);
  expect(shellWriteTarget('variant=/tmp/x/scratchpad/v1; sed -i "s/a/b/" $variant/hooks/register.ts')).toBe(null);
  expect(shellWriteTarget('cd src && sed -i "s/a/b/" app.ts')).toBe('src/app.ts');
  // stays strict: an absolute target after a scratch cd, an unknown variable after one
  expect(shellWriteTarget('cd /tmp/x/scratchpad && sed -i "s/a/b/" /home/me/src/a.ts')).toBe('/home/me/src/a.ts');
  expect(shellWriteTarget('cd /tmp/x/scratchpad && sed -i "s/a/b/" $loop/a.ts')).toBe('$loop/a.ts');
});
