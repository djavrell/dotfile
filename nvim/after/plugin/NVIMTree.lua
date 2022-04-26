local map = vim.api.nvim_set_keymap

require('nvim-tree').setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  hijack_cursor       = false,
  update_cwd          = false,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
}

map('n', '<leader>w', ':NvimTreeToggle<cr>', { silent = true, noremap = true })
map('n', '<leader>x', ':NvimTreeFindFile<cr>', { silent = true, noremap = true })

vim.cmd[[ let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache', 'target', '.metals' ] ]]
-- vim.cmd[[ highlight NvimTreeFolderIcon guibg=blue ]]
