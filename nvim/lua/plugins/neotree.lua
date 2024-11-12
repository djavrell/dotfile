return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
    },
    cmd = { 'Neotree' },
    keys = {
      { '<leader>w', '<cmd>Neotree toggle<CR>', 'n', { silent = true, noremap = true } },
      { '<leader>x', '<cmd>Neotree focus<CR>', 'n', { silent = true, noremap = true } },
    },
    config = function()
      require('neo-tree').setup({
        close_if_last_window = true,
        source_selector = {
          winbar = true,
          statusline = false,
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
          window = {
            width = 30,
          },
        },
        buffers = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          group_empty_dirs = true,
          show_unloaded = true,
        },
      })
    end,
  },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    config = function()
      require('window-picker').setup()
    end,
  },
}
