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

  'scr1pt0r/crease.vim', -- fold customization
  'vim-utils/vim-troll-stopper',
  'ntpeters/vim-better-whitespace',
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
  'kburdett/vim-nuuid',

  'kyazdani42/nvim-tree.lua',

  {
    'kylechui/nvim-surround',
    config = function()
      require("nvim-surround").setup({
        move_cursor = false,
        indent_lines = false,
      })
    end
  },
  'windwp/nvim-autopairs',
  'AndrewRadev/tagalong.vim',

  'phaazon/hop.nvim',

  {'rhysd/vim-fixjson', ft = 'json' },
  {'chrisbra/csv.vim', ft = 'csv'},
  'jamessan/vim-gnupg',
  {'diepm/vim-rest-console', ft = 'rest'},

  'numToStr/Comment.nvim',
  'JoosepAlviste/nvim-ts-context-commentstring',

  {
    'folke/trouble.nvim',
    cmd = {
      'Trouble',
      'TroubleToggle',
      'TodoTrouble'
    }
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

  'nvim-telescope/telescope.nvim',
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  'nvim-telescope/telescope-hop.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'nvim-telescope/telescope-dap.nvim',
  'molecule-man/telescope-menufacture',
  'doums/suit.nvim',

  'DNLHC/glance.nvim',

  {
    'anuvyklack/hydra.nvim',
    dependencies = { 'anuvyklack/keymap-layer.nvim' } -- only for pink hydras
  },

  {'NeogitOrg/neogit', cmd = 'Neogit'},
  'lewis6991/gitsigns.nvim',
  'sindrets/diffview.nvim',

  'rhysd/committia.vim',
  'rhysd/git-messenger.vim',

  'L3MON4D3/LuaSnip',

  -- LSP
  'neovim/nvim-lspconfig',
  'onsails/lspkind-nvim',
  'wbthomason/lsp-status.nvim',
  'lukas-reineke/lsp-format.nvim',
  'jose-elias-alvarez/nvim-lsp-ts-utils',

  -- Wrapper around some LSP for particular language
  'scalameta/nvim-metals',
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'kristijanhusak/vim-dadbod-completion',
  'SidOfc/mkdx',
  'mfussenegger/nvim-jdtls',

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
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },
  'nvim-treesitter/playground',
  'RRethy/nvim-treesitter-textsubjects',
  'nvim-treesitter/nvim-treesitter-textobjects',

  -- DAP
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'theHamsta/nvim-dap-virtual-text',

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
