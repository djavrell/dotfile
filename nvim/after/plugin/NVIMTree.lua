local map = vim.api.nvim_set_keymap

require('nvim-tree').setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  -- update_focused_file = {
  --   enable = true,
  -- },
  hijack_cursor       = true,
  update_cwd          = false,
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  git = {
    enable = true
  }
}

map('n', '<leader>w', ':NvimTreeToggle<cr>', { silent = true, noremap = true })
map('n', '<leader>x', ':NvimTreeFindFile<cr>', { silent = true, noremap = true })

vim.cmd[[ let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache', 'target', '.metals' ] ]]
-- vim.cmd[[ highlight NvimTreeFolderIcon guibg=blue ]]
