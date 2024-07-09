return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require("null-ls")
    require("null-ls").setup {
      source = {
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.sqlformat,
      }
    }
  end
}
