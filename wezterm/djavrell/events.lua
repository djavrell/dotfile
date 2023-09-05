local wezterm = require 'wezterm'

local status = require('utils.status')

wezterm.on('update-status', function(win)
  win:set_left_status(wezterm.format {
    { Text = win:active_workspace() }
  })
end)

wezterm.on('update-right-status', status.KeyGroup)
