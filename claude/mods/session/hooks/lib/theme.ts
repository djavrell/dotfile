import type { Elements } from "claude-code";

import type { PaletteColorPath, PaletteColors, PaletteSingleColor, PaletteTheme } from "palette";

// the elements a section draws with: what $.ui.resolve gives, on every surface
export type Ui = Pick<Elements[keyof Elements], "Box" | "Text">;

// a color by its palette path ("ansi.blue", "brights.yellow", "comment"); undefined while palette has not loaded,
// which leaves the terminal's default color
// ponytail: palette cannot ship code to another mod (imports stay inside a mod folder), so its lookup lives here
export const paint = (theme: PaletteTheme | undefined, path: PaletteColorPath) => {
  if (!theme) return undefined;
  const [group, slot] = path.split(".");
  return group === "ansi" || group === "brights"
    ? theme[group][slot as keyof PaletteColors]
    : theme[path as PaletteSingleColor];
};

// a Text's `hover` inside a Button: a Button always inverts under the pointer and no prop turns that off,
// so this swaps the part's colors beforehand and the inversion swaps them back (the line looks unchanged).
// Give it a plain color, not dimColor: dim would also dim the swapped colors and the swap would show
export const unInverted = (theme: PaletteTheme | undefined, shownColor?: string) =>
  theme && { color: theme.background, backgroundColor: shownColor };

// thresholds of statusline-command.sh: green < 50 <= yellow < 80 <= red
export const band = (percent: number): PaletteColorPath =>
  percent >= 80 ? "ansi.red" : percent >= 50 ? "ansi.yellow" : "ansi.green";
