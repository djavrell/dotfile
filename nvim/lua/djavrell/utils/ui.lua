local M = {}

M.border_chars_outer_thin = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
M.border_chars_inner_thin = { ' ', '▁', ' ', '▏', ' ', '▔', ' ', '▕' }
M.border_chars_outer_thin_telescope = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' }
M.border_rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

M.kind_icons = {
  Class = "󰠱",
  Color = "󰏘",
  Constant = "󰏿",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰇽",
  File = "󰈙",
  Folder = "󰉋",
  Function = "󰊕",
  Interface = "",
  Keyword = "󰌋",
  Method = "󰆧",
  Module = ' ',
  Operator = "󰆕",
  Property = "󰜢",
  Reference = "",
  Snippet = "",
  Struct = "󰙅",
  Text = "󰉿",
  TypeParameter = ' ',
  Unit = "",
  Value = "󰎠",
  Variable = "󰀫",
}

return M
