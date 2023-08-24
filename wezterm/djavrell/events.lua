local wezterm = require 'wezterm'

-- TEST
-- create new workspace
--  - eventKnd = workspaceNew
--  - loc = path
wezterm.on('user-var-changed', function(window, pane, key, value)
  wezterm.log_info(window:mux_window():get_workspace())
  wezterm.log_info('var: ', key, value)
end)

wezterm.on('update-status', function(win, pane)
  win:set_left_status(wezterm.format {
    { Text = win:mux_window():get_workspace() }
  })
end)
