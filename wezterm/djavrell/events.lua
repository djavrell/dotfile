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

local gb = P.pipeC(
  A.Bold,
  S.wrapSpace,
  S.section({
    { Background = { Color = C.palette.green.bright } },
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

---@param kt string|nil key table in use
local function selectSection(kt)
  if kt ~= nil and kt == 'copy_mode' then
    return function(txt)
      return merge(
        gb(wezterm.nerdfonts.md_content_copy),
        gb(txt)
      )
    end
  end
  return ob
end

wezterm.on('update-status', function(win)
  win:set_left_status(
    wezterm.format(
      selectSection(win:active_key_table())(win:active_workspace())
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
