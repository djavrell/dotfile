return {
  -- LSP
  {
    'neovim/nvim-lspconfig',
    config = function()
      local nvim_lsp = require('lspconfig')
      local lsp_conf = require('core.lsp')

      -- nvim_lsp.ts_ls.setup(lsp_conf.setup())
      --[[ nvim_lsp.vtsls.setup(lsp_conf.setup({
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = 'all' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      })) ]]
      require('typescript-tools').setup(lsp_conf.setup({
        settings = {
          -- spawn additional tsserver instance to calculate diagnostics on it
          separate_diagnostic_server = true,
          -- "change"|"insert_leave" determine when the client asks the server about diagnostic
          publish_diagnostic_on = 'insert_leave',
          -- CodeLens
          -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
          -- possible values: ("off"|"all"|"implementations_only"|"references_only")
          code_lens = 'implementations_only',
          -- by default code lenses are displayed on all referencable values and for some of you it can
          -- be too much this option reduce count of them by removing member references from lenses
          disable_member_code_lens = false,
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            includeCompletionsForModuleExports = true,
            quotePreference = 'auto',
          },
        },
      }))

      nvim_lsp.eslint.setup(lsp_conf.setup({
        settings = {
          run = 'onSave',
        },
      }))

      nvim_lsp.bashls.setup(lsp_conf.setup())
      nvim_lsp.lua_ls.setup(lsp_conf.setup({
        settings = {
          Lua = {
            format = {
              enable = false,
            },
          },
        },
      }))
    end,
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
      require('fidget').setup({})
    end,
  },
}
