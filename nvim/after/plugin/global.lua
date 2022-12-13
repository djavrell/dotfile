require("todo-comments").setup {}
require('neoscroll').setup({
  mappings = {
    '<C-u>',
    '<C-d>',
    'zz',
  }
})

-- nuuid.vim
vim.g.nuuid_no_mappings = 1

-- fix json
vim.g.fixjson_fix_on_save = 0

-- Eleline
vim.g.eleline_powerline_fonts = 1
