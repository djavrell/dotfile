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

// wezterm's [colors] table, plus `comment`, the theme's gray the toml has no slot for
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
}

export type Palette = {
  // read once per load from the wezterm scheme file, the built-in copy where it cannot be read
  get: () => Promise<PaletteTheme>
}

declare module 'claude-code' {
  interface EngineInterface {
    palette: Palette
  }
}
