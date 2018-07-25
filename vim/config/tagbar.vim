Plugin 'majutsushi/tagbar'

nmap <C-t> :TagbarToggle<CR>

let g:tagbar_map_nexttag = 'n'
let g:tagbar_map_prevtag = 'p'

let g:tagbar_autofocus = 1
let g:tagbar_sort = 0

"--------------
" Scala
"--------------

function! SCTags()
  if executable("sctags")
    let g:tagbar_ctags_bin = "sctags"
    let g:tagbar_type_scala = {
      \ 'ctagstype' : 'scala',
      \ 'sro'       : '.',
      \ 'kinds'     : [
          \ 'p:packages',
          \ 'V:values',
          \ 'v:variables',
          \ 'T:types',
          \ 't:traits',
          \ 'o:objects',
          \ 'O:case objects',
          \ 'c:classes',
          \ 'C:case classes',
          \ 'm:methods:1'
      \ ],
      \ 'kind2scope'  : {
          \ 'p' : 'package',
          \ 'T' : 'type',
          \ 't' : 'trait',
          \ 'o' : 'object',
          \ 'O' : 'case_object',
          \ 'c' : 'class',
          \ 'C' : 'case_class',
          \ 'm' : 'method'
      \ },
      \ 'scope2kind'  : {
          \ 'package' : 'p',
          \ 'type' : 'T',
          \ 'trait' : 't',
          \ 'object' : 'o',
          \ 'case_object' : 'O',
          \ 'class' : 'c',
          \ 'case_class' : 'C',
          \ 'method' : 'm'
        \ }
      \ }
  endif
endfunction

if has("autocmd")
  " autocmd FileType scala call SCTags()
endif
