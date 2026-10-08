import type { Elements } from "claude-code";

import type { PaletteTheme } from "palette";

// the elements a section draws with: what $.ui.resolve gives, on every surface
export type Ui = Pick<Elements[keyof Elements], "Box" | "Text">;

// the colors this pane paints with, from the terminal theme the palette mod shares
export const colors = (paletteTheme: PaletteTheme) => ({
  ...paletteTheme.ansi,
  yellowBright: paletteTheme.brights.yellow,
  gray: paletteTheme.comment,
});
export type Role = keyof ReturnType<typeof colors>;
// empty while palette has not loaded: the terminal's default colors then
export type Colors = Partial<Record<Role, string>>;

// thresholds of statusline-command.sh: green < 50 <= yellow < 80 <= red
export const band = (percent: number): Role =>
  percent >= 80 ? "red" : percent >= 50 ? "yellow" : "green";
