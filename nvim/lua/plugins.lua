return {
  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',

  'rebelot/kanagawa.nvim',
  'sainnhe/gruvbox-material',

  'lifepillar/vim-colortemplate',
  'ryanoasis/vim-devicons',
  'kyazdani42/nvim-web-devicons', -- for file icons
  'mortepau/codicons.nvim',

  'hsanson/vim-openapi',

  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup({
        mappings = {
          '<C-u>',
          '<C-d>',
          'zz',
        }
      })
    end
  },

  'vim-utils/vim-troll-stopper',
  {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.cmd[[
        let g:better_whitespace_filetypes_blacklist=['<filetype1>', '<filetype2>', '<etc>', 'diff', 'gitcommit', 'unite', 'qf', 'help', 'dashboard']
        let g:better_whitespace_operator=''

        nmap <silent> <C-Space> :StripWhitespace<CR>
      ]]
    end
  },
  {
    'm4xshen/smartcolumn.nvim',
    config = function()
      require('smartcolumn').setup({
        disabled_filetypes = {
          "help",
          "text",
          "markdown",
          "dbout",
          "man",
          "lazy"
        },
        limit_to_line = true,
      })
    end
  },

  -- utils
  'benknoble/vimpbcopy',
  -- 'andrewradev/splitjoin.vim',
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>s', '<space>j' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup()
    end
  },
  'christianrondeau/vim-base64',
  {
    'kburdett/vim-nuuid',
    config = function()
      vim.g.nuuid_no_mappings = 1
    end
  },

  {
    'kylechui/nvim-surround',
    config = function()
      require("nvim-surround").setup({
        move_cursor = false,
        indent_lines = false,
      })
    end
  },
  'AndrewRadev/tagalong.vim',

  {
    'rhysd/vim-fixjson',
    ft = 'json',
    config = function()
      vim.g.fixjson_fix_on_save = 0
    end
  },
  {
    'chrisbra/csv.vim',
    ft = 'csv',
    config = function()
      vim.cmd[[
        let g:csv_delim=';'
        let g:csv_table_leftalign=1
      ]]
    end
  },
  'jamessan/vim-gnupg',
  {
    'diepm/vim-rest-console',
    ft = 'rest',
    config = function()
      vim.cmd [[
        let s:vrc_auto_format_response_patterns = {
              \ 'json': 'python -m json.tool',
              \ 'xml': 'xmllint --format -',
            \}

        let g:vrc_curl_opts = { '-sS': '', '-i': '' }

        let g:vrc_allow_get_request_body = 1
      ]]
    end
  },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end
  },
  'JoosepAlviste/nvim-ts-context-commentstring',

  {
    'folke/trouble.nvim',
    cmd = {
      'Trouble',
      'TroubleToggle',
      'TodoTrouble'
    },
    config = function()
      require("trouble").setup {
        mode = "workspace_diagnostics",
        height = 20,
        auto_preview = false,
        auto_jump = {"lsp_definitions", "workspace_diagnostics", "document_diagnostics"}
      }
    end
  },
  {
    'folke/todo-comments.nvim',
    config = function()
      require("todo-comments").setup {}
    end,
  },
  {
    'gregorias/coerce.nvim',
    config = function()
      require("coerce").setup {}
    end,
  },


  {
    'anuvyklack/hydra.nvim',
    dependencies = { 'anuvyklack/keymap-layer.nvim' } -- only for pink hydras
  },

  -- LSP
  'neovim/nvim-lspconfig',
  'onsails/lspkind-nvim',
  'wbthomason/lsp-status.nvim',
  'lukas-reineke/lsp-format.nvim',
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  {'artemave/workspace-diagnostics.nvim'},

  -- Wrapper around some LSP for particular language
  'scalameta/nvim-metals',
  'SidOfc/mkdx',
  'mfussenegger/nvim-jdtls',
  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup {}
    end
  },

  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-cmdline',
  'saadparwaiz1/cmp_luasnip',
  'rcarriga/cmp-dap',

  'jose-elias-alvarez/null-ls.nvim',

  {
    'kevinhwang91/nvim-bqf',
    config = function()
      require('bqf').setup({
        auto_enable = true,
        auto_resize_height = true
      })
    end
  },
  {
    'junegunn/fzf',
    build = function()
      vim.fn['fzf#install']()
    end
  },
}
