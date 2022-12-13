return require('packer').startup(function(use)

  local local_use = function(plug, github, opts)
    opts = opts or {}

    if vim.fn.isdirectory(vim.fn.expand("~/nvimPlugins/" .. plug)) then
      opts[1] = "~/nvimPlugins/" .. plug
    else
      opts[1] = vim.fn.expand("%s/%s", github, plug)
    end

    use(opts)
  end

  use 'wbthomason/packer.nvim'

  -- Plugin for plugins
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'rcarriga/nvim-notify'

  -- styling
  use 'rebelot/kanagawa.nvim'
  use 'sainnhe/gruvbox-material'
  use 'lifepillar/vim-colortemplate'
  use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons' -- for file icons
  use 'mortepau/codicons.nvim'

  -- detect openapi 3
  use 'hsanson/vim-openapi'
  -- use 'pedrohdz/vim-yaml-folds'

  -- use { 'psliwka/vim-smoothie', commit = "10fd0aa57d176718bc2c570f121ab523c4429a25" }
  use 'karb94/neoscroll.nvim'
  use 'liuchengxu/eleline.vim'
  -- use 'rebelot/heirline.nvim'

  use 'scr1pt0r/crease.vim' -- fold customization
  use 'vim-utils/vim-troll-stopper'
  use 'ntpeters/vim-better-whitespace'

  -- utils
  use 'benknoble/vimpbcopy'
  use 'andrewradev/splitjoin.vim'
  use 'christianrondeau/vim-base64'
  use 'kburdett/vim-nuuid'

  use 'kyazdani42/nvim-tree.lua'

  use 'kylechui/nvim-surround'
  use 'windwp/nvim-autopairs'
  use 'AndrewRadev/tagalong.vim'

  use 'nacro90/numb.nvim'
  use 'phaazon/hop.nvim'

  -- Typescript
  use 'ianks/vim-tsx'
  use 'maxmellon/vim-jsx-pretty'
  use 'leafgarland/typescript-vim'

  use {'rhysd/vim-fixjson', ft = { 'json' } }
  use 'chrisbra/csv.vim'
  use 'jamessan/vim-gnupg'
  use 'diepm/vim-rest-console'

  use 'numToStr/Comment.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use 'folke/trouble.nvim'
  use 'folke/todo-comments.nvim'

  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-telescope/telescope-hop.nvim'
  use 'nvim-telescope/telescope-ui-select.nvim'
  use 'nvim-telescope/telescope-live-grep-args.nvim'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'doums/suit.nvim'

  use { 'anuvyklack/hydra.nvim',
    requires = 'anuvyklack/keymap-layer.nvim' -- needed only for pink hydras
  }

  use 'TimUntersberger/neogit'
  use 'lewis6991/gitsigns.nvim'
  use 'sindrets/diffview.nvim'

  use 'pwntester/octo.nvim'
  use 'rhysd/committia.vim'
  use 'rhysd/git-messenger.vim'

  use 'L3MON4D3/LuaSnip'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind-nvim'
  use 'wbthomason/lsp-status.nvim'
  use 'lukas-reineke/lsp-format.nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  -- use 'Issafalcon/lsp-overloads.nvim'
  -- use 'folke/neodev.nvim'

  -- Wrapper around some LSP for particular language
  use 'scalameta/nvim-metals'
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'
  use 'kristijanhusak/vim-dadbod-completion'
  use 'SidOfc/mkdx'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rcarriga/cmp-dap'

  use 'jose-elias-alvarez/null-ls.nvim'

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use { 'nvim-treesitter/playground' }
  use { 'RRethy/nvim-treesitter-textsubjects' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }

  -- DAP
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'

  use 'kevinhwang91/nvim-bqf'
  use {'junegunn/fzf', run = function()
      vim.fn['fzf#install']()
  end
  }

end)
