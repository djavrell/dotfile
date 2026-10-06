import { expect, test } from 'claude-code/testing'

import { FALLBACK, parseScheme } from '../hooks/register'

const SCHEME = `
[colors]
foreground    = "#111111"
background    = "#222222"

ansi = [
  "#000001",
  "#000002",
  "#000003",
  "#000004",
  "#000005",
  "#000006",
  "#000007",
  "#000008"
]
`

test('reads scalars and the ansi array by slot', () => {
  const t = parseScheme(SCHEME)
  expect(t.foreground).toBe('#111111')
  expect(t.background).toBe('#222222')
  expect(t.ansi.black).toBe('#000001')
  expect(t.ansi.white).toBe('#000008')
})

test('falls back field by field for what the file lacks', () => {
  const t = parseScheme(SCHEME)
  expect(t.cursor_fg).toBe(FALLBACK.cursor_fg)
  expect(t.brights).toEqual(FALLBACK.brights)
  expect(t.comment).toBe(FALLBACK.comment)
})

test('an empty file is the fallback', () => {
  expect(parseScheme('')).toEqual(FALLBACK)
})
