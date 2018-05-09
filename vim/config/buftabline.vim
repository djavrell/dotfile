Plugin 'ap/vim-buftabline'

set hidden

" new buffer
map <Leader>n   :enew<CR>
" next/prev buffer
map <Leader>j   :bnext<CR>
map <Leader>k   :bprev<CR>
" close the current buffer
map <Leader>d   :bp <BAR> bd #<CR>
" list all buffer
map <Leader>ls  :ls<CR>
