if &compatible
 set nocompatible
endif

" Global: Vim settings {{{1
set shell=/bin/sh
set encoding=UTF-8
set hidden

set nobackup
set noswapfile
set nowritebackup
set number
set list
set listchars=tab:→\ ,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set backspace=indent,eol,start
set showmatch
set shiftround
set nrformats-=octl
set path+=**
set tabstop=2       " size of hard tabstop
set softtabstop=2   " size of tab in insert mode
set shiftwidth=2    " size of an indents
set expandtab       " use space instead of tab characters
set smarttab        " "tab" inserts "indents" instead of tab at the beginning of line
set completeopt+=preview
set inccommand=nosplit " live preview replace with :%s

let mapleader = '='

autocmd BufWritePre * :%s/\s\+$//e


" Global: Folding {{{1
syntax enable
set foldmethod=syntax
set foldlevel=99
set foldcolumn=1


" Gobal: ColorScheme {{{1
colorscheme gruvbox
set termguicolors

let g:gruvbox_contrast_dark="hard"
let g:gruvbox_improved_warnings=1

" Key mapping: {{{1
nmap <silent> <Esc><Esc> :nohlsearch<CR>
tnoremap <Esc> <C-\><C-n>

map <silent> <Leader>n :enew<CR>
map <silent> <Leader>j :bnext<CR>
map <silent> <Leader>k :bprev<CR>
map <silent> <Leader>d :bp <BAR> bd #<CR>
map <silent> <Leader>ls  :ls<CR>

" circle through tab
map <silent> <Leader><Right> :tabn<CR>
map <silent> <Leader><Left>  :tabp<CR>

" Plugins: declare plugin {{{1

call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-surround'

" Plugin: rest console {{{ 2
Plug 'diepm/vim-rest-console'

let g:vrc_show_command = 1
let s:vrc_auto_format_response_patterns = {
      \ 'json': 'fx',
      \ 'xml': 'xmllint --format -',
    \}

let g:vrc_curl_opts = { '-sS': '', '-i': '' }

" }}}

Plug 'mtth/scratch.vim'

" Plugin: vim table {{{ 2
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

" NerdTree {{{2
Plug 'scrooloose/nerdtree'

let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.metals$[[dir]]',  '\.bloop$[[dir]]','\.sass-cache$']
" Hide the Nerdtree status line to avoid clutter
let g:NERDTreeStatusline = ''

map <silent> <C-x> :NERDTreeToggle<CR>
map <silent> <C-c> :NERDTreeFocus<CR>
map <silent> <Leader>x :NERDTreeFind<CR>

Plug 'Xuyuanp/nerdtree-git-plugin' " git in neerdtree

" Plugin: Nerdcommenter {{{2
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

Plug 'myusuf3/numbers.vim'                 " better line numbers

let g:numbers_exclude = ['tagbar', 'gundo', 'minibufexpl', 'nerdtree']

nnoremap <F3> :NumbersToggle<CR>
nnoremap <F4> :NumbersOnOff<CR>

" Plugin: Utilsnip {{{2
Plug 'SirVer/ultisnips'
" let g:UltiSnipsUsePythonVersion = 3

Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'mhinz/vim-signify'
Plug 'jiangmiao/auto-pairs'

" Plugin: GoldenView {{{2
Plug 'zhaocai/GoldenView.Vim'

map <silent> <Leader>c  :close<CR>

" Plugin: Vim Better Whitespace {{{2
Plug 'ntpeters/vim-better-whitespace'

nmap <silent> <C-Space> :StripWhitespace<CR>

Plug 'liuchengxu/eleline.vim'
set laststatus=2
let g:eleline_powerline_fonts=1

" Plugin: Vim-markdow {{{2
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build release
    else
      !cargo build release no-default-features features json-rpc
    endif
  endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
let g:markdown_composer_open_browser=0

" Plugin: vim-scala {{{2
Plug 'derekwyatt/vim-scala'
au BufRead,BufNewFile *.sbt set filetype=scala

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plugin: COC {{{2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Some server have issues with backup files
set nobackup
set nowritebackup
" Better display for messages
set cmdheight=2

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

" Remap for do codeAction of current line
nmap <leader>ac <Plug>(coc-codeaction)

" Remap for do action format
nnoremap <silent> F :call CocAction('format')<CR>
"nnoremap <silent> <Leader>I :call CocRequestAsync('metals', 'workspace/executeCommand', { 'command': 'build-import' })<CR>

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Show Buffers
nnoremap <silent> <Leader>b :<C-u>CocList buffers<CR>
"Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <Leader>p :<C-u>CocListResume<CR>
nnoremap <silent> <Leader>f :<C-u>CocList files<CR>
nnoremap <silent> <leader>g :<C-u>CocList grep<CR>
nnoremap <silent> <leader>s :<C-u>CocList symbols<CR>
" Coc-yank
nnoremap <silent> <Leader>y :<C-u>CocList -A normal yank<CR>

" COC: Coc-snippets {{{3
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

autocmd CursorHold * silent call CocActionAsync('highlight')

call plug#end()

autocmd FileType json syntax match Comment +\/\/.\+$+

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Move here, (neo)vim seems to have some issue with those unicode caracter :/
let g:NERDTreeIndicatorMapCustom = { "Modified": "✹", "Staged": "✚", "Untracked": "✭", "Renamed": "➜", "Unmerged": "═", "Deleted": "✖", "Dirty": "✗", "Clean": "✔︎", "Unknown": "?" }

filetype plugin indent on
