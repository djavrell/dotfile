import type { Role } from "./theme";

// Nerd Font glyphs and colors after nvim-web-devicons, so the tree reads like neo-tree
export const FOLDER_ICON = ""; // nf-custom-folder_open
const DEFAULT_FILE_ICON = { glyph: "", color: "white" } as const; // nf-fa-file
const FILE_ICONS: Record<string, { glyph: string; color: Role }> = {
  ts: { glyph: "", color: "blue" }, // nf-seti-typescript
  tsx: { glyph: "", color: "cyan" }, // nf-dev-react
  js: { glyph: "", color: "yellow" }, // nf-dev-javascript
  jsx: { glyph: "", color: "cyan" },
  json: { glyph: "", color: "yellow" }, // nf-seti-json
  md: { glyph: "", color: "white" }, // nf-oct-markdown
  lua: { glyph: "", color: "blue" }, // nf-seti-lua
  sh: { glyph: "", color: "green" }, // nf-dev-terminal
  bash: { glyph: "", color: "green" },
  zsh: { glyph: "", color: "green" },
  py: { glyph: "", color: "yellow" }, // nf-seti-python
  toml: { glyph: "", color: "gray" }, // nf-seti-toml
  yml: { glyph: "", color: "magenta" }, // nf-seti-yml
  yaml: { glyph: "", color: "magenta" },
  html: { glyph: "", color: "red" }, // nf-dev-html5
  css: { glyph: "", color: "blue" }, // nf-dev-css3
  rs: { glyph: "", color: "red" }, // nf-dev-rust
  go: { glyph: "", color: "cyan" }, // nf-seti-go
  vim: { glyph: "", color: "green" }, // nf-seti-vim
  gitignore: { glyph: "", color: "red" }, // nf-dev-git
  lock: { glyph: "", color: "gray" }, // nf-fa-lock
};

// by extension, or by the whole name for dotfiles such as .gitignore
export const fileIcon = (fileName: string) => {
  const extension = fileName.includes(".")
    ? fileName.slice(fileName.lastIndexOf(".") + 1).toLowerCase()
    : "";
  return FILE_ICONS[extension] ?? DEFAULT_FILE_ICON;
};

// a model family by a Nerd Font glyph: the magnum opus, a sonnet's note, a haiku's leaf, a fable's book
const MODEL_ICONS: { family: string; glyph: string; color: Role }[] = [
  { family: "opus", glyph: "", color: "magenta" }, // nf-fa-star
  { family: "sonnet", glyph: "", color: "blue" }, // nf-fa-music
  { family: "haiku", glyph: "", color: "green" }, // nf-fa-leaf
  { family: "fable", glyph: "", color: "yellow" }, // nf-fa-book
];
const UNKNOWN_MODEL_ICON = { glyph: "", color: "gray" } as const; // nf-fa-question

// from an id (claude-haiku-4-5-...) or an alias (haiku)
export const modelIcon = (model: string | undefined) =>
  MODEL_ICONS.find((icon) => model?.toLowerCase().includes(icon.family)) ??
  UNKNOWN_MODEL_ICON;

// end-of-line marks telling an edited file from one only read
export const EDITED_MARK = "●";
export const READ_MARK = "○";
