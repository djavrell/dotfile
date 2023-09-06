local wezterm = require 'wezterm'

local mergeA = require("utils.merge").merge_all
local status = require("utils.status")

wezterm.on('update-status', function(win)
 local name = win:active_key_table()

  local workspace = status.orange_section(win:active_workspace())
  win:set_left_status(wezterm.format(workspace))

  local conf = mergeA(
    status.if_def(name, status.orange_section),
    status.wrapSpace({{ Text = wezterm.time.now():format("%H:%M %F") }})
  )

  win:set_right_status(wezterm.format {
    table.unpack(conf)
  })
end)
