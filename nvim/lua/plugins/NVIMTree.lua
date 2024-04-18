local autocmd = vim.api.nvim_create_autocmd
local augroups = require('djavrell.augroups.utils')

return {
  'kyazdani42/nvim-tree.lua',
  keys = {
    { '<leader>w', '<cmd>NvimTreeToggle<CR>', 'n', { silent = true, noremap = true } },
    { '<leader>x', '<cmd>NvimTreeFindFile<CR>', 'n', { silent = true, noremap = true } },
  },
  config = function()
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
      },
      actions = {
        open_file = {
          quit_on_open = true,
          eject = true
        }
      }
    }

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
