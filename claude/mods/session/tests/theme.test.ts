import { expect, test } from 'claude-code/testing'
import type { PaletteTheme } from 'palette'

import { band, paint } from '../hooks/lib/theme'

const slots = (hex: string) => ({ black: hex, red: hex, green: hex, yellow: hex, blue: hex, magenta: hex, cyan: hex, white: hex })
const theme = {
  foreground: '#ffffff',
  background: '#000000',
  ansi: { ...slots('#111111'), blue: '#0000aa' },
  brights: { ...slots('#222222'), yellow: '#ffff55' },
  comment: '#777777',
  dimmed: '#808080',
} as PaletteTheme

test('paints a palette path: a slot of ansi or brights, or a single color', () => {
  expect(paint(theme, 'ansi.blue')).toBe('#0000aa')
  expect(paint(theme, 'brights.yellow')).toBe('#ffff55')
  expect(paint(theme, 'comment')).toBe('#777777')
})

test('paints nothing while palette has not loaded', () => {
  expect(paint(undefined, 'ansi.red')).toBeUndefined()
})

test('bands a percent to green, yellow, red', () => {
  expect([band(10), band(50), band(80)]).toEqual(['ansi.green', 'ansi.yellow', 'ansi.red'])
})
