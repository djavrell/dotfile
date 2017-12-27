let g:user_emmet_mode='n'    "only enable normal mode functions.
let g:user_emmet_mode='inv'  "enable all functions, which is equal to
let g:user_emmet_mode='a'    "enable all function in all mode.

" enable emmet only in html and css file
let g:user_emmet_install_global = 0
autocmd FileType hbs, html,css EmmetInstall
