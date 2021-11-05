augroup EnvRC
  autocmd!
  autocmd BufRead .envrc set ft=sh
  autocmd BufRead .env.* set ft=sh
augroup END

augroup HelpFile
  autocmd!
  autocmd BufEnter * if &buftype ==# 'help' | nnoremap gd <C-]> | endif
augroup END

augroup Global
  autocmd!
  autocmd BufRead *.conf set ft=conf
  autocmd BufWritePre * :%s/\s\+$//e
augroup END
