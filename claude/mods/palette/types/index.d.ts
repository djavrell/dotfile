// the 8 ANSI slots of a wezterm `ansi` or `brights` array, in order
export type PaletteColors = {
  black: string
  red: string
  green: string
  yellow: string
  blue: string
  magenta: string
  cyan: string
  white: string
}

// wezterm's [colors] table, plus `comment`, the theme's gray the toml has no slot for,
// and `dimmed`, halfway between foreground and background: a dim text's look as a plain color
export type PaletteTheme = {
  foreground: string
  background: string
  cursor_bg: string
  cursor_border: string
  cursor_fg: string
  selection_fg: string
  selection_bg: string
  ansi: PaletteColors
  brights: PaletteColors
  comment: string
  dimmed: string
}

// a color as the palette names it, what a consumer's tables hold: `ansi.blue`, `brights.yellow`, `comment`
export type PaletteSingleColor = 'foreground' | 'background' | 'comment' | 'dimmed'
export type PaletteColorPath = `ansi.${keyof PaletteColors}` | `brights.${keyof PaletteColors}` | PaletteSingleColor

export type Palette = {
  // read once per load from the wezterm scheme file, the built-in copy where it cannot be read
  get: () => Promise<PaletteTheme>
}

declare module 'claude-code' {
  interface EngineInterface {
    palette: Palette
  }
}
