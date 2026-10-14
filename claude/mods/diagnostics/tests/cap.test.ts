import { expect, test } from 'claude-code/testing'

import { MAX_LINE_CHARS, MAX_TOTAL_CHARS, capDiagnostics } from '../hooks/cap'

test('keeps short diagnostics as they are', () => {
  const text = 'group.router.ts:\n  ✘ [Line 271:32] Cannot find name \'configurations\'. [2552] (typescript)'
  expect(capDiagnostics(text)).toBe(text)
})

test('cuts a spelled-out type to the head of its line', () => {
  const line = `  ✘ [Line 339:60] Argument of type ${'Response<400, X> | '.repeat(1000)}`
  const capped = capDiagnostics(line)
  expect(capped.startsWith('  ✘ [Line 339:60] Argument of type')).toBe(true)
  expect(capped).toContain(`[+${line.length - MAX_LINE_CHARS} chars]`)
})

test('caps the whole text', () => {
  const text = Array.from({ length: 1000 }, (_, index) => `line ${index} ${'x'.repeat(100)}`).join('\n')
  const capped = capDiagnostics(text)
  expect(capped.length).toBeLessThan(MAX_TOTAL_CHARS + 100)
  expect(capped).toContain('[diagnostics cut:')
})
