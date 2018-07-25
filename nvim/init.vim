if &compatible
 set nocompatible
endif

colorscheme darcula

" Plugins --------------------------------------------------------{{{

" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
 call dein#begin('~/.cache/dein')

 call dein#add('~/.cache/dein')
 call dein#add('haya14busa/dein-command.vim')

 call dein#add('Shougo/denite.nvim')
 call dein#add('Shougo/deoplete.nvim')

 call dein#add('mhartington/nvim-typescript', {'build': './install.sh'})
 call dein#add('HerringtonDarkholme/yats.vim')

 call dein#add('jiangmiao/auto-pairs')
 call dein#add('simnalamburt/vim-mundo')
 call dein#add('w0rp/ale')
 call dein#add('scrooloose/nerdtree')
 call dein#add('tpope/vim-fugitive')
 call dein#add('tpope/vim-git')
 call dein#add('neoclide/denite-git')
 call dein#add('airblade/vim-gitgutter')

 call dein#add('vim-airline/vim-airline')

 call dein#end()
 call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif
" }}}
" ------------------------
" CONFIGURATION
" ------------------------

" Use deoplete.
let g:deoplete#enable_at_startup = 1

map	<C-x>	:NERDTreeToggle<CR>
map	<C-c>	:NERDTreeFocus<CR>

" ALE {{{
let g:airline#extensions#ale#enable = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" }}}

" mundo {{{
set undofile
set undodir=~/.vim/undo
" }}}

filetype plugin indent on
syntax enable
