" Plugins definition {{{

call plug#begin('~/.local/share/nvim/plugged')

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

Plug 'sainnhe/gruvbox-material'
" Handle and update colorscheme tamplate
Plug 'lifepillar/vim-colortemplate'

Plug 'hsanson/vim-openapi'

Plug 'benknoble/vimpbcopy'
Plug 'psliwka/vim-smoothie'
Plug 'liuchengxu/eleline.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'JMcKiern/vim-venter'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'scr1pt0r/crease.vim'
Plug 'vim-utils/vim-troll-stopper'
Plug 'MTDL9/vim-log-highlighting'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'terryma/vim-expand-region'
Plug 'romgrk/equal.operator'
Plug 'unblevable/quick-scope'
Plug 'nacro90/numb.nvim'
Plug 'andrewradev/splitjoin.vim'
Plug 'christianrondeau/vim-base64'
Plug 'kburdett/vim-nuuid'

Plug 'ianks/vim-tsx'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'

Plug 'derekwyatt/vim-scala'
Plug 'alx741/vim-hindent'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'puremourning/vimspector'
Plug 'SidOfc/mkdx'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'rhysd/vim-fixjson', { 'for': 'json' }
Plug 'chrisbra/csv.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'AndrewRadev/tagalong.vim'
Plug 'jamessan/vim-gnupg'
Plug 'diepm/vim-rest-console'
" Plug 'kyazdani42/nvim-tree.lua'

Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

Plug 'matbme/JABS.nvim'

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Git {{{
Plug 'sindrets/diffview.nvim'

Plug 'rhysd/committia.vim'
Plug 'rbong/vim-flog'
Plug 'APZelos/blamer.nvim'
Plug 'rhysd/git-messenger.vim'
Plug 'airblade/vim-gitgutter'
Plug 'TimUntersberger/neogit'
Plug 'mhinz/vim-signify'
" }}}

Plug 'L3MON4D3/LuaSnip'
Plug 'neovim/nvim-lspconfig'
Plug 'wbthomason/lsp-status.nvim'

" Completion {{{
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'onsails/lspkind-nvim'
" }}}

Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons' " for file icons

Plug 'folke/trouble.nvim'
Plug 'folke/todo-comments.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" }}}

try
  source $XDG_CONFIG_HOME/local_nvim.vim
catch
  let mapleader = '='
endtry

filetype plugin indent on
