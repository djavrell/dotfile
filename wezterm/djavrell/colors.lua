local C = {}

-- nordic.nvim's palette, fetched by `dots link` at the commit nvim/lazy-lock.json pins (wezterm/module.d/install_wezterm)
C.palette = require('colors.palette')

C.foreground = C.palette.white1
C.background = C.palette.gray0
C.cursor_bg = C.palette.white1
C.cursor_border = C.palette.white1
C.cursor_fg = C.palette.gray0
C.selection_fg = C.palette.white1
C.selection_bg = C.palette.gray1

return C
