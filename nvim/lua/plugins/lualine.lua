return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'pnx/lualine-lsp-status',
    },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'nordic',
        },
        sections = {
          lualine_b = { 'branch', 'diagnostics' },
          lualine_x = {
            'lsp-status',
            'filetype',
          },
        },
      })
    end,
  },
}
