local map = vim.api.nvim_set_keymap

--[[ require('nvim-tree').setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  auto_close          = true,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  hijack_cursor       = false,
  update_cwd          = false,
  diagnostics         = {
    enable= true
  },
} ]]

map('n', '<leader>w', ':NvimTreeToggle<cr>', { silent = true, noremap = true })
map('n', '<leader>x', ':NvimTreeFindFile<cr>', { silent = true, noremap = true })

vim.cmd[[ let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache', 'target', '.metals' ] ]]
-- vim.cmd[[ highlight NvimTreeFolderIcon guibg=blue ]]
