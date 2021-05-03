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
" Plugins definition {{{

call plug#begin('~/.local/share/nvim/plugged')

Plug 'hardcoreplayers/gruvbox9'
" Handle and update colorscheme tamplate
Plug 'lifepillar/vim-colortemplate'

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
Plug 'neovimhaskell/haskell-vim'
Plug 'alx741/vim-hindent'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'puremourning/vimspector'
Plug 'DrCracket/painless-digraph'
Plug 'SidOfc/mkdx'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'rhysd/vim-fixjson', { 'for': 'json' }
Plug 'chrisbra/csv.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'AndrewRadev/tagalong.vim'
Plug 'jamessan/vim-gnupg'
Plug 'diepm/vim-rest-console'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

Plug 'scrooloose/nerdcommenter'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'liuchengxu/vista.vim' ", { 'on': ['Vista'] }

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Git {{{
Plug 'sindrets/diffview.nvim'

Plug 'Xuyuanp/nerdtree-git-plugin' " git in neerdtree
Plug 'rhysd/committia.vim'
Plug 'rbong/vim-flog'
Plug 'APZelos/blamer.nvim'
Plug 'rhysd/git-messenger.vim'
Plug 'airblade/vim-gitgutter'
" Plug 'jreybert/vimagit'
" Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-git'
Plug 'mhinz/vim-signify'
" }}}

" COC {{{
Plug 'neoclide/coc.nvim', { 'branch':  'release' }

Plug 'fannheyward/coc-markdownlint'
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tslint-plugin', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
Plug 'vn-ki/coc-clap'
Plug 'neoclide/coc-git'

" }}}
Plug 'ryanoasis/vim-devicons'

" Have to be defined before loading the plugin
let g:polyglot_disabled = ['markdown'] " mkdx: for vim-polyglot users, it loads Plasticboy's markdown
" plugin which unfortunately interferes with mkdx list indentation.
Plug 'sheerun/vim-polyglot'

call plug#end()

" }}}
" Plugins Configuration {{{

" UI {{{
" Eleline {{{
set laststatus=2
let g:eleline_powerline_fonts=1
" }}}
" Vim Better Whitespace {{{
let g:better_whitespace_filetypes_blacklist=['<filetype1>', '<filetype2>', '<etc>', 'diff', 'gitcommit', 'unite', 'qf', 'help', 'dashboard']
let g:better_whitespace_operator=''

nmap <silent> <C-Space> :StripWhitespace<CR>
" }}}
" Goyo {{{

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

" Venter - Center your buffer {{{

" let g:venter_disable_vertsplit = v:true
let g:venter_width = &columns/6
" }}}
" Fold {{{

set fillchars=fold:\    " space
let g:crease_foldtext = { 'default': '%{repeat("-", v:foldlevel)} %l lines: %t ' }
" }}}

" Menu {{{
source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
" }}}

" Show Unicode Char {{{
augroup TrollStopper
  autocmd!
  autocmd ColorScheme * highlight TrollStopper ctermbg=red guibg=#FF0000
augroup END
" }}}
" }}}

" QuickScope {{{

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
" Stylus {{{
augroup Stylus
  autocmd!
  autocmd FileType stylus set foldmarker={,}
  autocmd FileType stylus set foldmethod=marker
augroup END
" }}}

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
" Haskell {{{


let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords


" Hindent
let g:hindent_on_save = 1
let g:hindent_indent_size = 2

" }}}
" }}}

" Git {{{
" Nerdtree git plugin {{{
let g:NERDTreeGitStatusIndicatorMapCustom = { "Modified": "✹", "Staged": "✚", "Untracked": "✭", "Renamed": "➜", "Unmerged": "═", "Deleted": "✖", "Dirty": "✗", "Clean": "✔︎", "Unknown": "?" }

" }}}
" Committia - Better commit window {{{

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
" diffview {{{
lua <<EOF
local cb = require'diffview.config'.diffview_callback

require'diffview'.setup {
  diff_binaries = false,    -- Show diffs for binaries
  file_panel = {
    width = 35,
    use_icons = true        -- Requires nvim-web-devicons
  },
  key_bindings = {
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"]     = cb("select_next_entry"),  -- Open the diff for the next file
      ["<s-tab>"]   = cb("select_prev_entry"),  -- Open the diff for the previous file
      ["<leader>e"] = cb("focus_files"),        -- Bring focus to the files panel
      ["<leader>b"] = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]         = cb("next_entry"),         -- Bring the cursor to the next file entry
      ["<down>"]    = cb("next_entry"),
      ["k"]         = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
      ["<up>"]      = cb("prev_entry"),
      ["<cr>"]      = cb("select_entry"),       -- Open the diff for the selected entry.
      ["o"]         = cb("select_entry"),
      ["R"]         = cb("refresh_files"),      -- Update stats and entries in the file list.
      ["<tab>"]     = cb("select_next_entry"),
      ["<s-tab>"]   = cb("select_prev_entry"),
      ["<leader>e"] = cb("focus_files"),
      ["<leader>b"] = cb("toggle_files"),
    }
  }
}
EOF
" }}}
" Blamer {{{

let g:blamer_delay = 250
:command! -nargs=0 Blame call BlamerToggle()
" }}}
" Git Gutter {{{

nmap <leader>h <Plug>(GitGutterNextHunk)
nmap <leader>H <Plug>(GitGutterPrevHunk)

" }}}

" Vimagit {{{
let g:magit_default_show_all_files=2

augroup VimaGIT
  autocmd!
  autocmd FileType magit set textwidth=80
augroup END

" }}}

" }}}

" Database {{{
" vim dadbob {{{
" }}}
" vim dadbob UI {{{

let g:db_ui_execute_on_save = 0
let g:db_ui_show_database_icon = 1
let g:db_ui_use_nerd_fonts = 1

" }}}
" }}}

" Debugger {{{
" }}}

" Painless diagraph {{{
" Use to easily enter characters composed of 2 (ex: <ctrl-k>12 -> ½ or a5 -> あ)
" }}}

" UUID {{{
let g:nuuid_no_mappings = 1
" }}}

" Markdown {{{
" mkdx {{{

let g:mkdx#settings = { 'auto_update': { 'enable': 1 },
                        \ 'highlight': { 'enable': 1 },
                        \ 'enter': { 'shift': 1 },
                        \ 'links': { 'external': { 'enable': 1 } },
                        \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
                        \ 'fold': { 'enable': 1, 'components': [ 'toc', 'fence' ] },
                        \ 'map': { 'enable': 1 },
                        \ 'checkbox': { 'update_tree': 2 }
                       \}

nmap <leader>+ <Plug>(mkdx-promote-header)
nmap <leader>- <Plug>(mkdx-demote-header)

augroup mkdx
    autocmd!
    " Include dash in 'word'
    autocmd FileType markdown setlocal iskeyword+=-
augroup END

" }}}

augroup Markdown
  autocmd!
  autocmd FileType markdown
        \ set textwidth=80  |
        \ set linebreak     |
        \ set spell
augroup END
" }}}

" Text Format {{{
" JSON {{{
let g:fixjson_fix_on_save = 0

augroup JSON
  autocmd!
  autocmd FileType json syntax match Comment +\/\/.\+$+
  autocmd FileType json set foldmethod=syntax
augroup END
" }}}
" CSV {{{
" Vim table {{{
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
" }}}
" GPG {{{
augroup GPG
  autocmd!
  autocmd User GnuPG setl textwidth=72
augroup END
" }}}
" }}}

" Rest console {{{
let s:vrc_auto_format_response_patterns = {
      \ 'json': 'fx',
      \ 'xml': 'xmllint --format -',
    \}

let g:vrc_curl_opts = { '-sS': '', '-i': '' }
" }}}
" nvim tree {{{
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache', 'target', '.metals' ]
" let g:nvim_tree_hide_dotfiles = 1

map <silent> <Leader>w :NvimTreeToggle<CR>
map <silent> <Leader>x :NvimTreeFindFile<CR>

highlight NvimTreeFolderIcon guibg=blue
" }}}
" Nerdcommenter {{{

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
" Vim Clap {{{

let g:clap_layout = {
  \   'height': '30%',
  \   'row': '10%',
  \ }
let g:clap_multi_selection_warning_silent = 1
let g:clap_preview_size={ '*': 15 }
let g:clap_preview_direction='UD'

nnoremap  <silent>  <leader>c :Clap<CR>
" nnoremap  <silent>  <leader>f :Clap files<CR>
nnoremap  <silent>  <leader>ff :Clap files +name-only<CR>
nnoremap  <silent>  <space>f  :Clap filer<CR>
" nnoremap  <silent>  <leader>b :Clap buffers<CR>
" nnoremap  <silent>  <leader>g :Clap grep2<CR>
vnoremap  <silent>  <leader>g :Clap grep2 ++query=@visual<CR>
nnoremap  <silent>  <leader>G :Clap grep2 ++query=<cword><CR>
nnoremap  <silent>  <space>a  :Clap loclist<CR>
nnoremap  <silent>  <space>t  :Clap tags<CR>
nnoremap  <silent>  <space>T  :Clap proj_tags<CR>
nnoremap  <silent>  <space>d  :Clap coc_diagnostics<CR>
nnoremap  <silent>  <space>q  :Clap quickfix<CR>
nnoremap  <silent>  <space>r  :Clap registers<CR>

" }}}
" numb.nvim {{{
lua <<EOF
require('numb').setup{
  show_number = true,
  show_cursorline = true
}
EOF
" }}}
" Telescope {{{

lua <<EOF
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_position = "bottom",
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    shorten_path = true,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  }
}
EOF

nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({}))<cr>
" }}}
" Vista.vim (LSP symbole view & search) {{{

let g:vista_default_executive = 'coc'
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_echo_cursor_strategy='floating_win'
let g:vista#renderer#enable_icon = 1

augroup Vista
  autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
augroup END
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

function! ToggleRuler()
  if s:ruler == 0
    set cursorline
    set cursorcolumn
    let s:ruler = 1
  else
    set nocursorline
    set nocursorcolumn
    let s:ruler = 0
  endif
endfunction

command -nargs=0 Ruler :call ToggleRuler()
" }}}

" }}}
" Key mapping {{{

" clean highlight after a search with /
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
" When in termianl, remap tu use Esc
tnoremap <Esc> <C-\><C-n>

" buffer management
map <silent> <Leader>d :bp <BAR> bd #<CR>
map <silent> :BufOnly  :%bd <BAR> e# <BAR> bd #<CR>

" resize pane
nnoremap <silent> <S-Right> :vertical resize +5<CR>
nnoremap <silent> <S-Left> :vertical resize -5<CR>
nnoremap <silent> <S-Up> :resize +5<CR>
nnoremap <silent> <S-Down> :resize -5<CR>

" circle through tab
map <silent> <Leader><Right> :tabn<CR>
map <silent> <Leader><Left>  :tabp<CR>

" force write when the sudo was forgotten
cnoremap w!! execute 'silent! write !sudo tee % > /dev/null' <bar>edit!

" set next match at the center of the screen
"   zv -> open needed fold
"   zz -> set cursor at the center of the screnn
nnoremap n nzvzz
nnoremap N Nzvzz

" zM -> fold everything
" zv -> open needed fold
" zz -> set cursor at the center of the screen
nnoremap <leader>z zMzvzz
"
" Move visual selection
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

" }}}
" Autocmd {{{
" Global {{{
augroup Global
  autocmd!
  autocmd BufRead *.conf set ft=conf
  autocmd BufWritePre * :%s/\s\+$//e
augroup END
" }}}
" NeoVim {{{
augroup NeoVim
  autocmd!
  autocmd FileType vim set fdm=marker fmr={{{,}}} fdl=0
augroup END
" }}}
" Zsh Script {{{
augroup ZSH
  autocmd!
  autocmd FileType sh,zsh
        \ set fdm=marker |
        \ set fmr={,}    |
        \ set fdl=0
augroup END
" }}}
" Conf {{{
augroup ConfFile
  autocmd!
  autocmd FileType conf set foldmarker={,}
  autocmd FileType conf set foldmethod=marker
augroup END
" }}}
" Log {{{
augroup Log
  autocmd!
  autocmd FileType log
        \ set nowrap     |
        \ set fdm=marker |
        \ set fmr={,}
augroup END
" }}}
" QuickfixBuffer {{{
augroup QuickfixBuffer
  autocmd!
  autocmd FileType qf setlocal cursorline
  autocmd bufenter * if (winnr('$') == 1 && &buftype ==# 'quickfix') | q | endif
augroup END
" }}}
" HelpFile {{{
augroup HelpFile
  autocmd!
  autocmd bufenter * if &buftype ==# 'help' | nnoremap gd <C-]> | endif
augroup END
" }}}
" envrc files {{{
augroup EnvRC
  autocmd!
  autocmd BufRead .envrc set ft=zsh
augroup END
" }}}
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

highlight! StatusLineNC gui=underline guibg=NONE guifg=#3e4451
" }}}

filetype plugin indent on
