local wezterm = require 'wezterm'
local log = wezterm.log_info

local C = require("djavrell.colors")
local merge = require("utils.merge").merge_all
local P = require("utils.pipe")

local S = require("statusline.sections")
local A = require("statusline.attrs")

local ob = P.pipeC(
  A.Bold,
  S.wrapSpace,
  S.section({
    { Background = { Color = C.palette.orange.bright } },
    { Foreground = { Color = C.palette.black0 } },
  })
)

local time = P.pipeC(
  S.wrapSpace,
  S.section({
    { Background = { Color = C.palette.black0 } },
    { Foreground = { Color = C.palette.white1 } },
  })
)

function KeyTable(name)
  return merge(
    ob(wezterm.nerdfonts.md_table_key),
    ob(name)
  )
end

wezterm.on('update-status', function(win)
  win:set_left_status(
    wezterm.format(
      ob(win:active_workspace())
    )
  )

  win:set_right_status(wezterm.format(
    merge(
      S.if_def(
        win:active_key_table(),
        KeyTable
      ),
      time({{ Text = wezterm.time.now():format("%H:%M %F") }})
    )
  ))
end)
