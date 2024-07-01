return {
  'folke/trouble.nvim',
  cmd = {
    'Trouble',
  },
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
  },
  config = function()
    require("trouble").setup {
      -- mode = "workspace_diagnostics",
      -- height = 20,
      -- auto_preview = false,
      -- auto_jump = {"lsp_definitions", "workspace_diagnostics", "document_diagnostics"}
      modes = {
        refs = {
          mode = 'lsp_references',
          focus = true,
          preview = {
            type = 'split',
            relative = "win",
            position = "right",
            size = 0.6,
          }
        }
      }
    }
  end
}
