Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'roxma/nvim-yarp'
Plugin 'mhartington/nvim-typescript'
Plugin 'fszymanski/deoplete-emoji'

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

call deoplete#custom#set('emoji', 'filetypes', ['gitcommit', 'markdown', 'typescript', 'scala', 'html', 'rust', 'javascript'])
