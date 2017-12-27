let  g:ctrlp_map    =    '<C-f>'
let  g:ctrlp_cmd    =    'CtrlP'

" ignore some file
set wildignore+=*/tmp/*,*.so,*.swp,*.swt,*.zip,*.pyc,*.o,*.tmp,*.tar*,.idea/,.git/,.vscode/,node_modules/

" When invoked, unless a starting directory is specified, CtrlP will set its local working directory according to this variable:
" c' - the directory of the current file.
" 'r' - the nearest ancestor that contains one of these directories or files: .git .hg .svn .bzr _darcs
" 'a' - like c, but only if the current working directory outside of CtrlP is not a direct ancestor of the directory of the current file.
" 0 or '' (empty string) - disable this feature.

let g:ctrlp_working_path_mode = 'a'

" let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](node_modules|target|dist)|\.(git|hg|svn|idea)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
