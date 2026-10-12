import { expect, test } from 'claude-code/testing'

import { compactDenial, grepDenial } from '../hooks/lib/denials'

test("folds this mod's refusal to its first line", () => {
  expect(compactDenial(grepDenial(['UserService']))).toMatch(/^⛔ LSP-FIRST: grep on code symbol\(s\) UserService/)
  expect(compactDenial(`⛔ ${grepDenial(['UserService'])}`)).toMatch(/^⛔ LSP-FIRST: grep/)
})

test('an error that only quotes the marker further in is left alone', () => {
  expect(compactDenial('exit 1\nhooks/lib/denials.ts: const DENY_MARKER = "LSP-FIRST:"')).toBe(null)
})

test('leaves any other error alone', () => {
  expect(compactDenial('command not found')).toBe(null)
})
