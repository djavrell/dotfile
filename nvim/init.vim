" vim: set fdm=marker fmr={{{,}}} fdl=0 :
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
set foldmethod=syntax
set foldlevel=1
" }}}

try
  source $XDG_CONFIG_HOME/local_nvim.vim
catch
  let mapleader = '='
endtry
" }}}
" Plugins {{{

call plug#begin('~/.local/share/nvim/plugged')

" UI {{{
" Smoothie {{{
Plug 'psliwka/vim-smoothie'
" }}}
" Status Line {{{
Plug 'liuchengxu/eleline.vim'
set laststatus=2
let g:eleline_powerline_fonts=1
" }}}
" Vim Better Whitespace {{{
Plug 'ntpeters/vim-better-whitespace'

let g:better_whitespace_filetypes_blacklist=['<filetype1>', '<filetype2>', '<etc>', 'diff', 'gitcommit', 'unite', 'qf', 'help', 'dashboard']
let g:better_whitespace_operator=''

nmap <silent> <C-Space> :StripWhitespace<CR>
" }}}
" ColorScheme {{{
Plug 'hardcoreplayers/gruvbox9'
" Handle and update colorscheme tamplate
Plug 'lifepillar/vim-colortemplate'
" }}}
" Goyo {{{
Plug 'junegunn/goyo.vim'

let g:goyo_linenr = 1
let g:goyo_width = 150

" Goyo on enter {{{
function! s:goyo_enter()
  " tmux {{{
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux setw window-status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  " }}}
  " proper quit {{{
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
  " }}}

  setlocal go-=r
  setlocal statusline=
  set shortmess+=F
  set scrolloff=999
  set noshowmode
  set noshowcmd
  set nonumber norelativenumber
  set laststatus=0

  Limelight
endfunction
" }}}
" Goyo on leave {{{
function! s:goyo_leave()
  " tmux {{{
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux setw window-status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  " }}}
  " proper quit {{{
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
  " }}}

  setlocal go+=r
  set shortmess-=F
  set scrolloff=5
  set showmode
  set showcmd
  set number relativenumber
  set laststatus=2

  Limelight!
endfunction
" }}}
" augroup {{{
augroup Goyo
  autocmd!

  autocmd User GoyoEnter nested call <SID>goyo_enter()
  autocmd User GoyoLeave nested call <SID>goyo_leave()
  autocmd BufLeave goyo_pad setlocal norelativenumber
augroup END
" }}}
" }}}
" Limelight {{{
Plug 'junegunn/limelight.vim'
" }}}

" Venter - Center your buffer {{{
Plug 'JMcKiern/vim-venter'

" let g:venter_disable_vertsplit = v:true
let g:venter_width = &columns/6
" }}}

" }}}

" Fold {{{
Plug 'scr1pt0r/crease.vim'

set fillchars=fold:\    " space
let g:crease_foldtext = { 'default': '%{repeat("-", v:foldlevel)} %l lines: %t ' }
" }}}
" QuickScope {{{
Plug 'unblevable/quick-scope'

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_buftype_blacklist = ['terminal', 'nofile']

" Change default color of the hint letter
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#b57614' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#427b58' gui=underline ctermfg=81 cterm=underline
augroup END
" }}}

" Languages {{{
" Global {{{
Plug 'https://github.com/andrewradev/splitjoin.vim'
" }}}
" Typescript {{{
Plug 'ianks/vim-tsx'
" Vim jsx/tsx {{{
Plug 'maxmellon/vim-jsx-pretty'

let g:vim_jsx_pretty_template_tags = ['html', 'jsx', 'tsx']
" }}}
Plug 'leafgarland/typescript-vim'
" }}}
" Scala {{{
" Vim-scala {{{
Plug 'derekwyatt/vim-scala'

augroup scala
  autocmd BufRead,BufNewFile *.sbt set filetype=scala
  autocmd BufRead *.sc :ALEDisableBuffer
augroup END
" }}}
" }}}
" Haskell {{{

Plug 'neovimhaskell/haskell-vim'

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

Plug 'alx741/vim-hindent'

let g:hindent_on_save = 1
let g:hindent_indent_size = 2

" }}}
" }}}

" Git {{{
" Nerdtree git plugin {{{
Plug 'Xuyuanp/nerdtree-git-plugin' " git in neerdtree
let g:NERDTreeIndicatorMapCustom = { "Modified": "✹", "Staged": "✚", "Untracked": "✭", "Renamed": "➜", "Unmerged": "═", "Deleted": "✖", "Dirty": "✗", "Clean": "✔︎", "Unknown": "?" }

" }}}
" Committia {{{
Plug 'rhysd/committia.vim'

let g:committia_edit_window_width = 120
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Additional settings
    setlocal spell

    " If no commit message, start with insert mode
    if a:info.vcs ==# 'git' && getline(1) ==# ''
        startinsert
    endif

    " Scroll the diff window from insert mode
    " Map <C-n> and <C-p>
    imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    nmap <buffer> ) <Plug>(committia-scroll-diff-down-half)

    imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
    nmap <buffer> ( <Plug>(committia-scroll-diff-up-half)
endfunction
" }}}
" Flog {{{
Plug 'rbong/vim-flog'

" }}}

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'mhinz/vim-signify'
" }}}

" Database {{{
" vim dadbob {{{
Plug 'tpope/vim-dadbod'
" }}}
" vim dadbob UI {{{
Plug 'kristijanhusak/vim-dadbod-ui'

let g:db_ui_execute_on_save = 0
let g:db_ui_show_database_icon = 1
let g:db_ui_use_nerd_fonts = 1

" }}}
" }}}

" Debugger {{{
Plug 'puremourning/vimspector'
" }}}

" Use to easily enter characters composed of 2 (ex: <ctrl-k>12 -> ½ or a5 -> あ)
Plug 'DrCracket/painless-digraph'

Plug 'pedrohdz/vim-yaml-folds'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
" Rest console {{{
Plug 'diepm/vim-rest-console'

let s:vrc_auto_format_response_patterns = {
      \ 'json': 'fx',
      \ 'xml': 'xmllint --format -',
    \}

let g:vrc_curl_opts = { '-sS': '', '-i': '' }
" }}}
" Vim CSV {{{
Plug 'chrisbra/csv.vim'
" }}}
" Vim table {{{
Plug 'dhruvasagar/vim-table-mode'
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'
" }}}
" NerdTree {{{
Plug 'preservim/nerdtree'

let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.metals$[[dir]]',  '\.bloop$[[dir]]','\.sass-cache$']
" Hide the Nerdtree status line to avoid clutter
let g:NERDTreeStatusline = ''
let g:NERDTreeQuitOnOpen = 3

map <silent> <Leader>w :NERDTreeToggle<CR>
map <silent> <Leader>c :NERDTreeFocus<CR>
map <silent> <Leader>x :NERDTreeFind<CR>

" }}}
" Nerdcommenter {{{
Plug 'scrooloose/nerdcommenter'

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
" }}}
Plug 'jiangmiao/auto-pairs'
" Vim Clap {{{

Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }

let g:clap_layout = { 'relative': 'editor' }
let g:clap_multi_selection_warning_silent = 1

nnoremap  <silent>  <leader>c :Clap<CR>
nnoremap  <silent>  <leader>f :Clap files<CR>
nnoremap  <silent>  <leader>ff :Clap files +name-only<CR>
nnoremap  <silent>  <space>f  :Clap filer<CR>
nnoremap  <silent>  <leader>b :Clap buffers<CR>
nnoremap  <silent>  <leader>g :Clap grep2<CR>
vnoremap  <silent>  <leader>g :Clap grep2 ++query=@visual<CR>
nnoremap  <silent>  <leader>G :Clap grep2 ++query=<cword><CR>
nnoremap  <silent>  <space>a  :Clap loclist<CR>
nnoremap  <silent>  <space>t  :Clap tags<CR>
nnoremap  <silent>  <space>T  :Clap proj_tags<CR>

" }}}
" Vista.vim (LSP symbole view & search) {{{
Plug 'liuchengxu/vista.vim' ", { 'on': ['Vista'] }

let g:vista_default_executive = 'coc'
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_echo_cursor_strategy='floating_win'
let g:vista#renderer#enable_icon = 1

augroup Vista
  autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
augroup END
" }}}
" COC {{{
Plug 'neoclide/coc.nvim', { 'branch':  'release' }
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
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

" }}}
" Key mapping {{{
" General {{{
" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" For navigate diagnostics
nmap <silent> <Leader>E <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>e <Plug>(coc-diagnostic-next)

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
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tslint-plugin', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
Plug 'vn-ki/coc-clap'
Plug 'neoclide/coc-git'
" Plug 'weirongxu/coc-explorer'
" }}}

" }}}
" Vim devicons (should always be the last one) {{{
Plug 'ryanoasis/vim-devicons'
" }}}

call plug#end()
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

" }}}
" Key mapping {{{

" clean highlight after a search with /
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
" When in termianl, remap tu use Esc
tnoremap <Esc> <C-\><C-n>

" buffer management
map <silent> <Leader>n :enew<CR>
map <silent> <Leader>j :bnext<CR>
map <silent> <Leader>k :bprev<CR>
map <silent> <Leader>d :bp <BAR> bd #<CR>
map <silent> :BufOnly  :%bd <BAR> e# <BAR> bd #<CR>

" resize pane
nnoremap <silent> <S-Right> :vertical resize +5<CR>
nnoremap <silent> <S-Left> :vertical resize -5<CR>
nnoremap <silent> <S-Up> :resize +5<CR>
nnoremap <silent> <S-Down> :resize -5<CR>

" circle through windows
nnoremap <silent> <C-n> :wincmd w<Cr>
nnoremap <silent> <C-p> :wincmd W<Cr>

" circle through tab
map <silent> <Leader><Right> :tabn<CR>
map <silent> <Leader><Left>  :tabp<CR>

" force write when the sudo was forgotten
cnoremap w!! execute 'silent! write !sudo tee % > /dev/null' <bar>edit!

" set next match at the center of the screen
"   zv -> open needed fold
"   zz -> set cursor at the center of the screnn
nnoremap n nzvzz
nnoremap N Nzvzz

" }}}
" Autocmd {{{
augroup global
  autocmd!
  autocmd BufRead *.tsx set ft=typescript
  autocmd BufRead *.conf set ft=conf
  autocmd BufWritePre * :%s/\s\+$//e
  autocmd FileType log set nowrap
  " Automaticaly close nvim if NERDTree is only thing left open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

augroup JSON
  autocmd!
  autocmd FileType json syntax match Comment +\/\/.\+$+
  autocmd FileType json set foldmethod=syntax
augroup END

augroup QuickfixBuffer
  autocmd!
  autocmd FileType qf setlocal cursorline
  autocmd bufenter * if (winnr('$') == 1 && &buftype ==# 'quickfix') | q | endif
augroup END

augroup HelpFile
  autocmd!
  autocmd bufenter * if &buftype ==# 'help' | nnoremap gd <C-]> | endif
augroup END

" }}}
" ColorScheme (keep this section after the plugin on, in case some plugins requires you to set your own highlight) {{{
set termguicolors
set background=dark
colorscheme gruvbox9_hard

let g:gruvbox_filetype_hi_groups=1
let g:gruvbox_plugin_hi_groups=1

" Remove the colored background for all git status sign in the left gutter
" (smoother to the eyes)
augroup hg_gruvbox
  hi SignifySignAdd     guifg=#b8bb26 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
  hi SignifySignChange  guifg=#8ec07c guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
  hi SignifySignDelete  guifg=#fb4934 guibg=#3c3836 guisp=NONE gui=NONE cterm=NONE
augroup END
" }}}

filetype plugin indent on
