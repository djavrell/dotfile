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
