let s:ruler = 0
let s:ruler2 = 0

function! ToggleRuler()
  let s:ruler2 = 0

  if s:ruler == 0
    set cursorline
    let s:ruler = 1
  else
    set nocursorline
    let s:ruler = 0
  endif
endfunction

function! ToggleRuler2()
  let s:ruler = 0
  if s:ruler2 == 0
    set cursorline
    set cursorcolumn
    let s:ruler2 = 1
  else
    set nocursorline
    set nocursorcolumn
    let s:ruler2 = 0
  endif
endfunction

command -nargs=0 Ruler :call ToggleRuler()
command -nargs=0 Ruler2 :call ToggleRuler2()
