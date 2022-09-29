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
  use 'tjdevries/vlog.nvim'

  use 'kyazdani42/nvim-tree.lua'

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  use 'rebelot/kanagawa.nvim'
  use 'sainnhe/gruvbox-material'
  -- Handle and update colorscheme tamplate
  use 'lifepillar/vim-colortemplate'

  use 'hsanson/vim-openapi'

  use 'benknoble/vimpbcopy'
  use { 'psliwka/vim-smoothie', commit = "10fd0aa57d176718bc2c570f121ab523c4429a25" }
  use 'liuchengxu/eleline.vim'
  use 'ntpeters/vim-better-whitespace'
  use 'junegunn/goyo.vim'
  use 'junegunn/limelight.vim'
  use 'JMcKiern/vim-venter'
  use 'pedrohdz/vim-yaml-folds'
  use 'scr1pt0r/crease.vim'
  use 'vim-utils/vim-troll-stopper'
  use 'MTDL9/vim-log-highlighting'
  --[[ use 'tpope/vim-surround' ]]
  use 'kylechui/nvim-surround'
  use 'windwp/nvim-autopairs'
  use 'terryma/vim-expand-region'
  use 'romgrk/equal.operator'
  use 'nacro90/numb.nvim'
  use 'andrewradev/splitjoin.vim'
  use 'christianrondeau/vim-base64'
  use 'kburdett/vim-nuuid'

  use 'phaazon/hop.nvim'

  use 'ianks/vim-tsx'
  use 'maxmellon/vim-jsx-pretty'
  use 'leafgarland/typescript-vim'

  use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }})
  use 'alx741/vim-hindent'
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'
  use 'kristijanhusak/vim-dadbod-completion'
  use 'puremourning/vimspector'
  use 'SidOfc/mkdx'

  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'  }
  use {'rhysd/vim-fixjson', ft = { 'json' } }
  use 'chrisbra/csv.vim'
  use 'AndrewRadev/tagalong.vim'
  use 'jamessan/vim-gnupg'
  use 'diepm/vim-rest-console'

  use 'numToStr/Comment.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use 'matbme/JABS.nvim'

  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-telescope/telescope-hop.nvim'
  use 'nvim-telescope/telescope-ui-select.nvim'
  use 'doums/suit.nvim'

  use { 'anuvyklack/hydra.nvim',
    requires = 'anuvyklack/keymap-layer.nvim' -- needed only for pink hydras
  }

  use 'sindrets/diffview.nvim'

  use 'rhysd/committia.vim'
  use 'rhysd/git-messenger.vim'
  use 'TimUntersberger/neogit'
  use 'lewis6991/gitsigns.nvim'

  use 'L3MON4D3/LuaSnip'
  use 'wbthomason/lsp-status.nvim'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'rcarriga/cmp-dap'

  use 'onsails/lspkind-nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'

  use 'jose-elias-alvarez/null-ls.nvim'
  use 'lukas-reineke/lsp-format.nvim'

  use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons' -- for file icons

  use 'folke/trouble.nvim'
  use 'folke/todo-comments.nvim'

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use { 'nvim-treesitter/playground' }
  use { 'RRethy/nvim-treesitter-textsubjects' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }

  -- DAP
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'nvim-telescope/telescope-dap.nvim'

  use 'kevinhwang91/nvim-bqf'
  use {'junegunn/fzf', run = function()
      vim.fn['fzf#install']()
  end
  }

end)
