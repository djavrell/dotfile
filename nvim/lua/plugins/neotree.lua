return {
  {
    'nvim-neo-tree/neo-tree.nvim',
      dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
        'nvim-lua/plenary.nvim',
      },
    cmd = { 'Neotree' },
    config = function()
      require('neo-tree').setup({
        close_if_last_window = true,
        source_selector = {
          winbar = true,
          statusline = false
        }
      })
    end,
  },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    config = function()
        require'window-picker'.setup()
    end,
  }
}
