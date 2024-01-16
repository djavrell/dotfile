" clean highlight after a search with /
nnoremap <silent> <leader><leader> :nohlsearch<CR>
" When in termianl, remap tu use Esc
tnoremap <Esc> <C-\><C-n>

" resize pane
nnoremap <silent> <S-Right> :vertical resize +5<CR>
nnoremap <silent> <S-Left> :vertical resize -5<CR>
nnoremap <silent> <S-Up> :resize +5<CR>
nnoremap <silent> <S-Down> :resize -5<CR>

" circle through tab
map <silent> <Leader><Right> :tabn<CR>
map <silent> <Leader><Left>  :tabp<CR>

" set next match at the center of the screen
"   zv -> open needed fold
"   zz -> set cursor at the center of the screnn
nnoremap n nzvzz
nnoremap N Nzvzz

nnoremap <S-L> Lzz
nnoremap <S-M> Mzz
nnoremap <S-H> Hzz

" zM -> fold everything
" zv -> open needed fold
" zz -> set cursor at the center of the screen
nnoremap <leader>zz zMzvzz
"
" Move visual selection
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

nnoremap <silent> <c-n> :cnext<cr>zvzz
nnoremap <silent> <c-p> :cprev<cr>zvzz
nnoremap <silent> <c-c> :cclose<cr>
nnoremap <silent> <c-q> :copen<cr>

noremap <leader>r :%s/\<<C-r><C-w>\>/
