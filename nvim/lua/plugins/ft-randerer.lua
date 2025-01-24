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
        filetypes = { 'markdown', 'Avante' },
        injections = {
          languages = {
            markdown = {
              overwrite = true,
              query = [[
                  (section
                      (atx_headng) @injections.mkv.fold
                      (#set! @fold))
              ]],
            },
          },
        },
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
