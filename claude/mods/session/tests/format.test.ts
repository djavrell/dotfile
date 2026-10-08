import { expect, test } from 'claude-code/testing'

import { fmtTokens } from '../hooks/lib/format'

test('abbreviates token counts', () => {
  expect(fmtTokens(950)).toBe('950')
  expect(fmtTokens(123_456)).toBe('123k')
  expect(fmtTokens(1_000_000)).toBe('1M')
  expect(fmtTokens(1_500_000)).toBe('1.5M')
})
