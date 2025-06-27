return {
  {
    'OXY2DEV/markview.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    lazy = false,
    config = function()
      require('markview').setup({
        preview = {
          enable = true,
          filetypes = { 'markdown', 'Avante' },
          ignore_buftypes = { 'nofile' },
        },
        markdown = {
          enable = true,
        },
        experimental = { check_rtp_message = false },
      })
    end,
  },
  {
    'OXY2DEV/helpview.nvim',
    ft = 'help',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'hat0uma/csvview.nvim',
    config = function()
      require('csvview').setup({
        delimiter = {
          default = ';',
        },
        view = {
          display_mode = 'border',
        },
      })
    end,
  },
}
