Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'roxma/nvim-yarp'
Plugin 'fszymanski/deoplete-emoji'

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

call deoplete#custom#source('emoji', 'filetypes', ['gitcommit', 'markdown', 'typescript', 'scala', 'html', 'rust', 'javascript'])

let g:deoplete#sources={}
let g:deoplete#sources._=['buffer', 'member', 'tag', 'file', 'omni', 'utilsnips']

let g:deoplete#sources.scala = ['buffer', 'tags', 'omni']
let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.scala = ['[^. *\t0-9]\.\w*',': [A-Z]\w', '[\[\t\( ][A-Za-z]\w*']
