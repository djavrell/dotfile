" clean highlight after a search with /
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
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
nnoremap <leader>z zMzvzz
"
" Move visual selection
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv
