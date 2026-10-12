import { expect, test } from 'claude-code/testing'

import { foldSummary, reportBody, resultText } from '../hooks/lib/fold'

test("a subagent's report loses the harness frame, any other message is kept as it is", () => {
  const handBack = '[Subagent hand-back] The text below is the final report. The report follows:\n  - hooks.json\n  - register.tsx'
  expect(reportBody(handBack)).toBe('- hooks.json\n- register.tsx')
  expect(foldSummary(reportBody(handBack))).toBe('2 lignes · - hooks.json')
  expect(reportBody('Background task done')).toBe('Background task done')
})

test('a result folds to its line count and first non-blank line, an empty one is not folded', () => {
  expect(foldSummary('\n  first\nsecond\n\n')).toBe('3 lignes · first')
  expect(foldSummary('one line')).toBe('1 ligne · one line')
  expect(foldSummary(' \n')).toBe(null)
})

test('the text is read from Bash, Agent and unknown result shapes', () => {
  expect(resultText({ stdout: 'out', stderr: '', interrupted: false })).toBe('out')
  expect(resultText({ content: [{ type: 'text', text: 'a' }, { type: 'image' }, { type: 'text', text: 'b' }] })).toBe('a\nb')
  expect(resultText('plain')).toBe('plain')
  expect(resultText({ status: 'completed' })).toBe('')
})
