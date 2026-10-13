import type { PaletteColorPath } from "palette";

// Nerd Font glyphs and colors after nvim-web-devicons, so the tree reads like neo-tree
export const FOLDER_ICON = ""; // nf-custom-folder_open
export const FOLDER_CLOSED_ICON = "\ue5ff"; // nf-custom-folder
const DEFAULT_FILE_ICON = { glyph: "", color: "ansi.white" } as const; // nf-fa-file
const FILE_ICONS: Record<string, { glyph: string; color: PaletteColorPath }> = {
  ts: { glyph: "", color: "ansi.blue" }, // nf-seti-typescript
  tsx: { glyph: "", color: "ansi.cyan" }, // nf-dev-react
  js: { glyph: "", color: "ansi.yellow" }, // nf-dev-javascript
  jsx: { glyph: "", color: "ansi.cyan" },
  json: { glyph: "", color: "ansi.yellow" }, // nf-seti-json
  md: { glyph: "", color: "ansi.white" }, // nf-oct-markdown
  lua: { glyph: "", color: "ansi.blue" }, // nf-seti-lua
  sh: { glyph: "", color: "ansi.green" }, // nf-dev-terminal
  bash: { glyph: "", color: "ansi.green" },
  zsh: { glyph: "", color: "ansi.green" },
  py: { glyph: "", color: "ansi.yellow" }, // nf-seti-python
  toml: { glyph: "", color: "comment" }, // nf-seti-toml
  yml: { glyph: "", color: "ansi.magenta" }, // nf-seti-yml
  yaml: { glyph: "", color: "ansi.magenta" },
  html: { glyph: "", color: "ansi.red" }, // nf-dev-html5
  css: { glyph: "", color: "ansi.blue" }, // nf-dev-css3
  rs: { glyph: "", color: "ansi.red" }, // nf-dev-rust
  go: { glyph: "", color: "ansi.cyan" }, // nf-seti-go
  vim: { glyph: "", color: "ansi.green" }, // nf-seti-vim
  gitignore: { glyph: "", color: "ansi.red" }, // nf-dev-git
  lock: { glyph: "", color: "comment" }, // nf-fa-lock
};

// by extension, or by the whole name for dotfiles such as .gitignore
export const fileIcon = (fileName: string) => {
  const extension = fileName.includes(".")
    ? fileName.slice(fileName.lastIndexOf(".") + 1).toLowerCase()
    : "";
  return FILE_ICONS[extension] ?? DEFAULT_FILE_ICON;
};

// a model family by a Nerd Font glyph: the magnum opus' crown, a sonnet's quill, a haiku's leaf, a fable's open book
const MODEL_ICONS: { family: string; glyph: string; color: PaletteColorPath }[] = [
  { family: "opus", glyph: "󰆥", color: "ansi.magenta" }, // nf-md-crown
  { family: "sonnet", glyph: "󰛓", color: "ansi.blue" }, // nf-md-feather
  { family: "haiku", glyph: "󰌪", color: "ansi.green" }, // nf-md-leaf
  { family: "fable", glyph: "󱓷", color: "ansi.yellow" }, // nf-md-book_open_variant
];
const UNKNOWN_MODEL_ICON = { glyph: "", color: "comment" } as const; // nf-fa-robot

// from an id (claude-haiku-4-5-...) or an alias (haiku)
export const modelIcon = (model: string | undefined) =>
  MODEL_ICONS.find((icon) => model?.toLowerCase().includes(icon.family)) ??
  UNKNOWN_MODEL_ICON;

// end-of-line mark of an edited file: yellow, green when new
export const EDITED_MARK = "●";
