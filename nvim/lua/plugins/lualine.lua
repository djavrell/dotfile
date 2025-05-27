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
        extensions = { 'neo-tree', 'man', 'nvim-dap-ui' },
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
