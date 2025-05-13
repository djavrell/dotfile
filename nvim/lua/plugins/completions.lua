return {
  -- LSP
  {
    'neovim/nvim-lspconfig',
    config = function()
      local nvim_lsp = require('lspconfig')
      local lsp_conf = require('core.lsp')

      -- require('typescript-tools').setup(lsp_conf.setup({
      --   settings = {
      --     -- spawn additional tsserver instance to calculate diagnostics on it
      --     separate_diagnostic_server = true,
      --     -- "change"|"insert_leave" determine when the client asks the server about diagnostic
      --     publish_diagnostic_on = 'insert_leave',
      --     -- CodeLens
      --     -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
      --     -- possible values: ("off"|"all"|"implementations_only"|"references_only")
      --     code_lens = 'all',
      --     -- by default code lenses are displayed on all referencable values and for some of you it can
      --     -- be too much this option reduce count of them by removing member references from lenses
      --     disable_member_code_lens = false,
      --     tsserver_file_preferences = {
      --       includeInlayParameterNameHints = 'all',
      --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      --       includeInlayFunctionParameterTypeHints = true,
      --       includeInlayVariableTypeHints = true,
      --       includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      --       includeInlayPropertyDeclarationTypeHints = true,
      --       includeInlayFunctionLikeReturnTypeHints = true,
      --       includeInlayEnumMemberValueHints = true,
      --       includeCompletionsForModuleExports = true,
      --       quotePreference = 'auto',
      --     },
      --   },
      -- }))

      vim.lsp.enable('ts_ls')

      --[[ vim.lsp.enable('eslint')
      vim.lsp.config(
        'eslint',
        lsp_conf.setup({
          settings = {
            run = 'onSave',
          },
        })
      ) ]]
      nvim_lsp.eslint.setup(lsp_conf.setup({
        settings = {
          run = 'onSave',
        },
      }))

      vim.lsp.config('bashls', lsp_conf.setup())
      vim.lsp.enable('bashls')

      vim.lsp.config(
        'lua_ls',
        lsp_conf.setup({
          settings = {
            Lua = {
              format = {
                enable = false,
              },
            },
          },
        })
      )
      vim.lsp.enable('lua_ls')

      vim.lsp.config('pylsp', {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = { 'W391' },
                maxLineLength = 100,
              },
            },
          },
        },
      })
      vim.lsp.enable('pylsp')
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
    'petertriho/cmp-git',
    config = function()
      require('cmp_git').setup({
        filetypes = { 'octo' },
      })
    end,
  },

  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({})
    end,
  },
}
