" Global {{{
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
set completeopt=menuone,noinsert,noselect,preview
set inccommand=nosplit " live preview replace with :%s
set scrolloff=5
set shortmess+=c
" disable automatic commenting on newline
set formatoptions-=c, formatoptions-=r, formatoptions-=o
set signcolumn=yes
set cmdheight=2
set spelllang=en_us,fr_fr

set splitright
set splitbelow
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

" Folding {{{
syntax enable
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" set foldmethod=syntax
set foldlevel=1
" }}}

try
  source $XDG_CONFIG_HOME/local_nvim.vim
catch
  let mapleader = '='
endtry
" }}}
" Plugins definition {{{

call plug#begin('~/.local/share/nvim/plugged')

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
Plug 'puremourning/vimspector'
Plug 'SidOfc/mkdx'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'rhysd/vim-fixjson', { 'for': 'json' }
Plug 'chrisbra/csv.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'AndrewRadev/tagalong.vim'
Plug 'jamessan/vim-gnupg'
Plug 'diepm/vim-rest-console'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
" Plug 'kyazdani42/nvim-tree.lua'

Plug 'numToStr/Comment.nvim'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'matbme/JABS.nvim'
Plug 'liuchengxu/vista.vim' ", { 'on': ['Vista'] }

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
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

" COC {{{
Plug 'neoclide/coc.nvim', { 'branch':  'release' }

Plug 'fannheyward/coc-markdownlint'
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier'
Plug 'neoclide/coc-tslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tslint-plugin', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
Plug 'vn-ki/coc-clap'
Plug 'neoclide/coc-git'
Plug 'josa42/coc-lua'

" }}}
Plug 'ryanoasis/vim-devicons'
Plug 'folke/trouble.nvim'
Plug 'folke/todo-comments.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Have to be defined before loading the plugin
" let g:polyglot_disabled = ['markdown'] " mkdx: for vim-polyglot users, it loads Plasticboy's markdown
" plugin which unfortunately interferes with mkdx list indentation.
" Plug 'sheerun/vim-polyglot'

call plug#end()

" }}}
" Plugins Configuration {{{

" UI {{{
" Vim Better Whitespace {{{
let g:better_whitespace_filetypes_blacklist=['<filetype1>', '<filetype2>', '<etc>', 'diff', 'gitcommit', 'unite', 'qf', 'help', 'dashboard']
let g:better_whitespace_operator=''

nmap <silent> <C-Space> :StripWhitespace<CR>
" }}}
" Fold {{{

set fillchars=fold:\    " space
let g:crease_foldtext = { 'default': '%{repeat("-", v:foldlevel)} %l lines: %t ' }
" }}}

" }}}

" Languages {{{

" Typescript {{{
let g:vim_jsx_pretty_template_tags = ['html', 'jsx', 'tsx']
" }}}
" Scala {{{
" Vim-scala {{{

augroup scala
  autocmd BufRead,BufNewFile *.sbt set filetype=scala
augroup END
" }}}
" }}}
" }}}

" Quickscop
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_buftype_blacklist = ['terminal', 'nofile']

" Change default color of the hint letter
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#b57614' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#427b58' gui=underline ctermfg=81 cterm=underline
augroup END

" Rest console {{{
" let s:vrc_auto_format_response_patterns = {
"       \ 'json': 'fx',
"       \ 'xml': 'xmllint --format -',
"     \}
"
" let g:vrc_curl_opts = { '-sS': '', '-i': '' }
" }}}
" COC {{{
" Set variables {{{
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" }}}
" auto cmd {{{

augroup coc_augroup
  autocmd!
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,typescriptreact,javascriptreact,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

augroup ReactFiletype
  autocmd!
  autocmd BufRead,BufNewFile *.tsx set filetype=typescriptreact
  autocmd BufRead,BufNewFile *.jsx set filetype=javascriptreact
augroup END

" }}}
" Key mapping {{{
" General {{{
" Use <c-space> for trigger completion.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" For navigate diagnostics
nmap <silent> <Leader>E <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>e <Plug>(coc-diagnostic-next)=z

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>F  <Plug>(coc-format-selected)
nmap <leader>F  <Plug>(coc-format-selected)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap for do action format
" nnoremap <silent> F :call CocAction('format')<CR>

" Remap for do codeAction of current line
nmap <leader>ac <Plug>(coc-codeaction)
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <silent> <space>c  :CocCommand<CR>

" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Coc-yank {{{
nnoremap <silent> <Leader>y :<C-u>CocList -A normal yank<CR>
" }}}

" Notify coc.nvim that <enter> has been pressed.
" Currently used for the formatOnType feature.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" }}}
" Metals specifics {{{
nmap <Leader>ws <Plug>(coc-metals-expand-decoration)

" Go to Super method
nnoremap <silent> gm  :<C-u>CocCommand metals.go-to-super-method<CR>
" Show hierarchy
nnoremap <silent> sh  :<C-u>CocCommand metals.super-method-hierarchy<CR>

" Trigger for code actions
" Make sure `"codeLens.enable": true` is set in your coc config
nnoremap <leader>cll :<C-u>call CocActionAsync('codeLensAction')<CR>

" Toggle panel with Tree Views
nnoremap <silent> <space>o :<C-u>CocCommand metals.tvp<CR>
" Toggle Tree View 'metalsBuild'
nnoremap <silent> <space>ob :<C-u>CocCommand metals.tvp metalsBuild<CR>
" Toggle Tree View 'metalsCompile'
nnoremap <silent> <space>oc :<C-u>CocCommand metals.tvp metalsCompile<CR>
" Reveal current current class (trait or object) in Tree View 'metalsBuild'
nnoremap <silent> <space>of :<C-u>CocCommand metals.revealInTreeView metalsBuild<CR>

" Start Metals Doctor
command! -nargs=0 MetalsDoctor :call CocRequestAsync('metals', 'workspace/executeCommand', { 'command': 'doctor-run' })
" Manually start build import
command! -nargs=0 MetalsImport :call CocRequestAsync('metals', 'workspace/executeCommand', { 'command': 'build-import' })
" Manually connect with the build server
command! -nargs=0 MetalsConnect :call CocRequestAsync('metals', 'workspace/executeCommand', { 'command': 'build-connect' })
" }}}
" }}}
" Coc extension {{{
" Plug 'weirongxu/coc-explorer'
" }}}

" }}}

" }}}
" Functions {{{

" Function windows splitting {{{
let s:golden_ration = 1.618
" lockvar s:golden_ration

function! GetSplitMethode()
  let ww = winwidth(winnr())
  let tw = &textwidth

  if tw != 0 && ww > s:golden_ration * tw
    return 'vsplit'
  endif

  if ww > &columns / s:golden_ration
    return 'vsplit'
  endif
  return 'split'
endfunction

function! SplitWindow()
 let spli_cmd = GetSplitMethode()

  try
    exec spli_cmd
  catch /^Vim\%((\a\+)\)\=:E36/
    if spli_cmd == 'split'
      let &winminheight = &winminheight / 2
    else
      let &winminwidth = &winminwidth / 2
    endif
    exec spli_cmd
  endtry
  wincmd p
endfunction

nnoremap <silent> <C-l> :call SplitWindow()<CR>
" }}}

" Handle curser line {{{
let s:ruler = 0
let s:ruler2 = 0

function! ToggleRuler()
  let s:ruler2 = 0

  if s:ruler == 0
    set cursorline
    let s:ruler = 1
  else
    set nocursorline
    let s:ruler = 0
  endif
endfunction

function! ToggleRuler2()
  let s:ruler = 0
  if s:ruler2 == 0
    set cursorline
    set cursorcolumn
    let s:ruler2 = 1
  else
    set nocursorline
    set nocursorcolumn
    let s:ruler2 = 0
  endif
endfunction

command -nargs=0 Ruler :call ToggleRuler()
command -nargs=0 Ruler2 :call ToggleRuler2()
" }}}

" }}}
" Key mapping {{{

" clean highlight after a search with /
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
" When in termianl, remap tu use Esc
tnoremap <Esc> <C-\><C-n>

" resize pane
nnoremap <silent> <S-Right> :vertical resize +5<CR>
nnoremap <silent> <S-Left> :vertical resize -5<CR>
nnoremap <silent> <S-Up> :resize +5<CR>
nnoremap <silent> <S-Down> :resize -5<CR>

" circle through tab
map <silent> <Leader><Right> :tabn<CR>
map <silent> <Leader><Left>  :tabp<CR>

" set next match at the center of the screen
"   zv -> open needed fold
"   zz -> set cursor at the center of the screnn
nnoremap n nzvzz
nnoremap N Nzvzz

nnoremap <S-L> Lzz
nnoremap <S-M> Mzz
nnoremap <S-H> Hzz

" zM -> fold everything
" zv -> open needed fold
" zz -> set cursor at the center of the screen
nnoremap <leader>z zMzvzz
"
" Move visual selection
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

" }}}
" ColorScheme (keep this section after the plugin on, in case some plugins requires you to set your own highlight) {{{
if has('termguicolors')
  set termguicolors
endif

set background=dark

let g:gruvbox_material_palette = 'mix'
let g:gruvbox_material_background = 'hard'

let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_enable_italic = 1

colorscheme gruvbox-material
" }}}

filetype plugin indent on
