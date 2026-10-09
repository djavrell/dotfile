import { expect, test } from 'claude-code/testing'

import { compactDenial, grepDenial } from '../hooks/lib/denials'

test("folds this mod's refusal to its first line", () => {
  expect(compactDenial(grepDenial(['UserService']))).toMatch(/^⛔ LSP-FIRST: grep on code symbol\(s\) UserService/)
})

test("folds a classic hook's refusal, its prefix dropped", () => {
  const classic =
    'PreToolUse:Bash hook error: [node ~/.claude/hooks/bash-file-read-block.js]: \n⛔ TOOL-CHOICE: reading a source file through the shell is blocked.\n  target: a.ts'
  expect(compactDenial(classic)).toBe('⛔ TOOL-CHOICE: reading a source file through the shell is blocked.')
})

test('leaves any other error alone', () => {
  expect(compactDenial('command not found')).toBe(null)
})
