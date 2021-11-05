  setlocal cursorline
  autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix') | q | endif
