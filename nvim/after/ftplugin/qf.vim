setlocal cursorline

autocmd bufenter * if (winnr('$') == 1 && &buftype ==# 'quickfix') | q | endif
