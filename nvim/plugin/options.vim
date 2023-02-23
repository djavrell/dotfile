set shell=/bin/zsh
set encoding=utf8
set listchars=tab:→\ ,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set backspace=indent,eol,start
set nrformats-=octl
set path+=**
set tabstop=2       " size of hard tabstop
set softtabstop=2   " size of tab in insert mode
set shiftwidth=2    " size of an indents
set completeopt=menu,menuone,noselect
" set completeopt=menuone,noinsert,noselect,preview
set inccommand=nosplit " live preview replace with :%s
set scrolloff=5
set shortmess+=c
" disable automatic commenting on newline
set formatoptions-=c, formatoptions-=r, formatoptions-=o
set signcolumn=yes
set cmdheight=1
set spelllang=en_us,fr_fr

set nocompatible
set hidden
set autoread
set nobackup
set noswapfile
set nowritebackup
set relativenumber
set number
set list
set showmatch
set shiftround
set expandtab       " use space instead of tab characters
set smarttab        " "tab" inserts "indents" instead of tab at the beginning of line
set guifont=Hasklug_Nerd_Font:h11

" global status line
set laststatus=3
" set cmdheight=0

set lazyredraw " Do not redraw screen in the middle of a macro. Makes them complete faster.

" Folding {{{
syntax enable
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" set foldmethod=syntax
set foldlevel=1
" }}}
