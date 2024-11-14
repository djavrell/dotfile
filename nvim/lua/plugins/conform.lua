return {{
  'stevearc/conform.nvim',
  config = function ()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'prettier' },
      },
      formatters = {
        lua = {
          command = 'stylua',
          args = { '--config-path', vim.fn.stdpath('config') .. '/stylua.toml' },
        },
      },
      format_after_save = {
        lsp_format = 'fallback',
      }
    }
  end
}}
