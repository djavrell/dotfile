setlocal cursorline
augroup QF
  autocmd!
  autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix') | q | endif
augroup END
