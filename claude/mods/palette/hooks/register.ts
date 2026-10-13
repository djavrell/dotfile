import type { EngineInterface, Register } from 'claude-code'

import type { Palette, PaletteColors, PaletteTheme } from '../types'

// relative to $HOME
const SCHEME = '.bashrc.d/wezterm/colors/nordic.toml'
const SLOTS = ['black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white'] as const
const SCALARS = ['foreground', 'background', 'cursor_bg', 'cursor_border', 'cursor_fg', 'selection_fg', 'selection_bg'] as const

// full copy of wezterm/colors/nordic.toml, used field by field where the file is missing or lacks one;
// `comment` is nordic.nvim's comment gray, which the toml has no slot for
export const FALLBACK: PaletteTheme = {
  foreground: '#D8DEE9',
  background: '#242933',
  cursor_bg: '#D8DEE9',
  cursor_border: '#D8DEE9',
  cursor_fg: '#242933',
  selection_fg: '#D8DEE9',
  selection_bg: '#2E3440',
  ansi: {
    black: '#191D24',
    red: '#BF616A',
    green: '#A3BE8C',
    yellow: '#EBCB8B',
    blue: '#81A1C1',
    magenta: '#B48EAD',
    cyan: '#8FBCBB',
    white: '#D8DEE9',
  },
  brights: {
    black: '#3B4252',
    red: '#D06F79',
    green: '#B1D196',
    yellow: '#F0D399',
    blue: '#88C0D0',
    magenta: '#C895BF',
    cyan: '#93CCDC',
    white: '#E5E9F0',
  },
  comment: '#60728A',
  dimmed: '#7e848e',
}

const HEX = /"(#[0-9A-Fa-f]{6})"/g

// the color halfway between two "#rrggbb"
export const mixColors = (firstHex: string, secondHex: string) => {
  const channels = (hex: string) => [1, 3, 5].map(start => parseInt(hex.slice(start, start + 2), 16))
  const secondChannels = channels(secondHex)
  return `#${channels(firstHex)
    .map((value, index) => Math.round((value + secondChannels[index]!) / 2).toString(16).padStart(2, '0'))
    .join('')}`
}

// ponytail: reads only the shapes a wezterm scheme uses (key = "#hex", key = [ "#hex", ... ]), not general TOML
export const parseScheme = (text: string): PaletteTheme => {
  const scalar = (key: string) => text.match(new RegExp(`^\\s*${key}\\s*=\\s*"(#[0-9A-Fa-f]{6})"`, 'm'))?.[1]
  const array = (key: 'ansi' | 'brights'): PaletteColors => {
    const body = text.match(new RegExp(`^\\s*${key}\\s*=\\s*\\[([^\\]]*)\\]`, 'm'))?.[1] ?? ''
    const hex = [...body.matchAll(HEX)].map(match => match[1])
    return Object.fromEntries(
      SLOTS.map((slot, slotIndex) => [slot, hex[slotIndex] ?? FALLBACK[key][slot]]),
    ) as PaletteColors
  }
  const theme = { ...FALLBACK, ansi: array('ansi'), brights: array('brights') }
  for (const key of SCALARS) theme[key] = scalar(key) ?? FALLBACK[key]
  theme.dimmed = mixColors(theme.foreground, theme.background)
  return theme
}

// rejects when HOME is unset or the file cannot be read (missing, or the calling turn was stopped)
async function load($: EngineInterface): Promise<PaletteTheme> {
  const home = await $.env.get('HOME')
  if (!home) throw new Error('HOME is unset')
  return parseScheme(await $.fs.read(`${home}/${SCHEME}`))
}

export const register: Register = on => {
  let cached: Promise<PaletteTheme> | undefined

  // the noun's own body is the bottom of its chain: the built-in copy
  on('engine.create', async (_, event, next) => {
    const palette: Palette = { get: async () => FALLBACK }

    return { ...(await next(event)), palette }
  })

  // a call on $.palette.get runs this first, with a full $ to read the scheme file
  // only a successful read is kept: a failed one (a stopped turn rejects it) is retried by the next call
  // ponytail: a missing scheme file is re-read on every call, cache the miss if that ever shows in a profile
  on('palette.get', async $ => {
    cached ??= load($)
    try {
      return { value: await cached }
    } catch {
      cached = undefined
      return { value: FALLBACK }
    }
  })
}
