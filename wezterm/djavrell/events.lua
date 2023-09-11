local wezterm = require 'wezterm'

local S = require("djavrell.statusline")

wezterm.on('update-status', function(win)
  win:set_left_status(wezterm.format(S.left(win)))

  win:set_right_status(wezterm.format(S.right(win)))
end)
