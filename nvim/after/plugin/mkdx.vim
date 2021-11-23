let g:mkdx#settings = { 'auto_update': { 'enable': 1 },
                        \ 'highlight': { 'enable': 1 },
                        \ 'enter': { 'shift': 1 },
                        \ 'links': { 'external': { 'enable': 1 } },
                        \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
                        \ 'fold': { 'enable': 1, 'components': [ 'toc', 'fence' ] },
                        \ 'map': { 'enable': 1 },
                        \ 'checkbox': { 'update_tree': 2 }
                       \}

nmap <leader>+ <Plug>(mkdx-promote-header)
nmap <leader>- <Plug>(mkdx-demote-header)
