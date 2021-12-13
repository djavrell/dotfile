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

augroup TrollStopper
  autocmd!
  autocmd ColorScheme * highlight TrollStopper ctermbg=red guibg=#FF0000
augroup END

augroup GPG
  autocmd!
  autocmd User GnuPG setl textwidth=72
augroup END

augroup Scala
  autocmd BufRead,BufNewFile *.sbt set filetype=scala
augroup END

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
