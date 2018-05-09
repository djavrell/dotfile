Plugin 'leafgarland/typescript-vim'          " typescript
Plugin 'HerringtonDarkholme/yats.vim'

let g:typescript_indent_disable = 1

let g:typescript_compiler_binary = 'tsc'

autocmd FileType typescript :set makeprg=tsc

autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost l* nested lwindow
