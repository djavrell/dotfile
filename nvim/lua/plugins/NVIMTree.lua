local autocmd = vim.api.nvim_create_autocmd
local augroups = require('djavrell.augroups.utils')

return {
  'kyazdani42/nvim-tree.lua',
  config = function()
    local map = vim.keymap.set

    require('nvim-tree').setup {
      disable_netrw       = true,
      hijack_netrw        = true,
      update_focused_file = {
        enable = false,
      },
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

    autocmd("BufEnter", {
      group = augroups["nvimTree"],
      nested = true,
      callback = function()
        if #vim.api.nvim_tabpage_list_wins(0) == 1 and vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil then
          vim.cmd "quit"
        end
      end,
    })
  end
}
