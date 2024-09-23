return {
  -- LSP
  {
    'neovim/nvim-lspconfig',
    config = function()
      local nvim_lsp = require('lspconfig')
      local lsp_conf = require('djavrell.lsp')

      -- nvim_lsp.ts_ls.setup(lsp_conf.setup())
      nvim_lsp.vtsls.setup(lsp_conf.setup({
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            }
          },
        }
      }))

      nvim_lsp.eslint.setup(lsp_conf.setup({
        settings = {
          run = "onSave"
        }
      }))

      nvim_lsp.bashls.setup(lsp_conf.setup())
    end
  },
  'onsails/lspkind-nvim',
  'wbthomason/lsp-status.nvim',
  'lukas-reineke/lsp-format.nvim',
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  'ray-x/lsp_signature.nvim',
  'artemave/workspace-diagnostics.nvim',

  -- Wrapper around some LSP for particular language
  'scalameta/nvim-metals',
  'SidOfc/mkdx',

  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-cmdline',
  'saadparwaiz1/cmp_luasnip',
  'rcarriga/cmp-dap',

  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup {}
    end
  },
}
