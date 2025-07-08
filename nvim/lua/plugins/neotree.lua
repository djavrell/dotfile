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
          commands = {
            avante_add_files = function(state)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local relative_path = require('avante.utils').relative_path(filepath)

              local sidebar = require('avante').get()

              local open = sidebar:is_open()
              -- ensure avante sidebar is open
              if not open then
                require('avante.api').ask()
                sidebar = require('avante').get()
              end

              sidebar.file_selector:add_selected_file(relative_path)

              -- remove neo tree buffer
              if not open then
                sidebar.file_selector:remove_selected_file('neo-tree filesystem [1]')
              end
            end,
          },
          window = {
            width = 30,
            mappings = {
              ['oa'] = 'avante_add_files',
            },
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
