import { expect, test } from 'claude-code/testing'

import { cacheReadPercent, fmtTokens } from '../hooks/lib/format'

test('abbreviates token counts', () => {
  expect(fmtTokens(950)).toBe('950')
  expect(fmtTokens(123_456)).toBe('123k')
  expect(fmtTokens(1_000_000)).toBe('1M')
  expect(fmtTokens(1_500_000)).toBe('1.5M')
})

test('cache read share of the input', () => {
  expect(cacheReadPercent({ input_tokens: 10, cache_read_input_tokens: 90, cache_creation_input_tokens: 0 })).toBe(90)
  expect(cacheReadPercent({ input_tokens: 0, cache_read_input_tokens: 0, cache_creation_input_tokens: 0 })).toBe(null)
})
