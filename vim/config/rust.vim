Plugin 'racer-rust/vim-racer'                " plugin for rust completion
Plugin 'rust-lang/rust.vim'                  " plugin for rust syntax
Plugin 'sebastianmarkow/deoplete-rust'

set hidden

let g:racer_experimental_completion = 1
let g:rustfmt_autosave = 1
let g:racer_cmd = "~/.cargo/bin/racer"

au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)
