-- vim.cmd [[ packadd packer.nvim ]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'kyazdani42/nvim-tree.lua'

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  use 'rebelot/kanagawa.nvim'
  use 'sainnhe/gruvbox-material'
  -- Handle and update colorscheme tamplate
  use 'lifepillar/vim-colortemplate'

  use 'hsanson/vim-openapi'

  use 'benknoble/vimpbcopy'
  use 'psliwka/vim-smoothie'
  use 'liuchengxu/eleline.vim'
  use 'ntpeters/vim-better-whitespace'
  use 'junegunn/goyo.vim'
  use 'junegunn/limelight.vim'
  use 'JMcKiern/vim-venter'
  use 'pedrohdz/vim-yaml-folds'
  use 'scr1pt0r/crease.vim'
  use 'vim-utils/vim-troll-stopper'
  use 'MTDL9/vim-log-highlighting'
  use 'tpope/vim-surround'
  use 'jiangmiao/auto-pairs'
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

  use 'derekwyatt/vim-scala'
  use 'alx741/vim-hindent'
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'
  use 'kristijanhusak/vim-dadbod-completion'
  use 'puremourning/vimspector'
  use 'SidOfc/mkdx'

  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'  }
  use {'rhysd/vim-fixjson', ft = { 'json' } }
  use 'chrisbra/csv.vim'
  use 'dhruvasagar/vim-table-mode'
  use 'AndrewRadev/tagalong.vim'
  use 'jamessan/vim-gnupg'
  use 'diepm/vim-rest-console'

  use 'numToStr/Comment.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use 'matbme/JABS.nvim'

  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use 'sindrets/diffview.nvim'

  use 'rhysd/committia.vim'
  use 'rbong/vim-flog'
  use 'APZelos/blamer.nvim'
  use 'rhysd/git-messenger.vim'
  use 'airblade/vim-gitgutter'
  use 'TimUntersberger/neogit'
  use 'mhinz/vim-signify'

  use 'L3MON4D3/LuaSnip'
  use 'neovim/nvim-lspconfig'
  use 'wbthomason/lsp-status.nvim'

  use 'j-hui/fidget.nvim'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'

  use 'onsails/lspkind-nvim'
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'

  use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons' -- for file icons

  use 'folke/trouble.nvim'
  use 'folke/todo-comments.nvim'

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use { 'nvim-treesitter/playground' }
  use { 'RRethy/nvim-treesitter-textsubjects' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }

  use {'kevinhwang91/nvim-bqf', ft = 'qf'}
  use {'junegunn/fzf', run = function()
      vim.fn['fzf#install']()
  end
  }

end)
