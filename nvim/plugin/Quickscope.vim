let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_buftype_blacklist = ['terminal', 'nofile']

" Change default color of the hint letter
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#b57614' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#427b58' gui=underline ctermfg=81 cterm=underline
augroup END
