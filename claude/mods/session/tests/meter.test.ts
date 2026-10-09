import { expect, test } from 'claude-code/testing'

import { meterCells } from '../hooks/components/meter'

const drawn = (cells: { overflow: string; filled: string; empty: string }) => cells.overflow + cells.filled + cells.empty

test('fills up to the value, out of the total', () => {
  expect(drawn(meterCells(3, 5))).toBe('▰▰▰▱▱')
  expect(drawn(meterCells(0, 4))).toBe('▱▱▱▱')
  expect(drawn(meterCells(5, 5))).toBe('▰▰▰▰▰')
})

test('clamps and rounds what it is given', () => {
  expect(drawn(meterCells(9, 3))).toBe('▰▰▰')
  expect(drawn(meterCells(-2, 3))).toBe('▱▱▱')
  expect(drawn(meterCells(2.6, 4))).toBe('▰▰▰▱')
})

test('past the width, keeps the last cells after an ellipsis', () => {
  expect(meterCells(30, 31, 6)).toEqual({ overflow: '…', filled: '▰▰▰▰', empty: '▱' })
  expect(drawn(meterCells(3, 4, 20))).toBe('▰▰▰▱')
})
