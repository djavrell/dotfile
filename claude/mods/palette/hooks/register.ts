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
}

const HEX = /"(#[0-9A-Fa-f]{6})"/g

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
  return theme
}

async function load($: EngineInterface): Promise<PaletteTheme> {
  try {
    const home = (await $.process.run(['printenv', 'HOME'])).stdout.trim()
    return parseScheme(await $.fs.read(`${home}/${SCHEME}`))
  } catch {
    return FALLBACK
  }
}

export const register: Register = on => {
  let cached: Promise<PaletteTheme> | undefined

  // the noun's own body is the bottom of its chain: the built-in copy
  on('engine.create', async (_, event, next) => {
    const palette: Palette = { get: async () => FALLBACK }

    return { ...(await next(event)), palette }
  })

  // a call on $.palette.get runs this first, with a full $ to read the scheme file
  on('palette.get', async $ => ({ value: await (cached ??= load($)) }))
}
