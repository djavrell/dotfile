local wezterm = require 'wezterm'
local M = {}

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

local function KeyTableSection(name)
  return ob(wezterm.nerdfonts.md_table_key .. ' ' .. name)
end

--[[ local battery_state = {
  empty = {
    icone = "fa_battery_empty",
    color = C.palette.red.bright,
  },
  quarter = {
    icone = "fa_battery_quarter",
    color = C.palette.yellow.bright,
  },
  half = {
    icone = "fa_battery_half",
    color = C.palette.orange.base,
  },
  three = {
    icone = "fa_battery_three_quarter",
    color = C.palette.green.dim,
  },
  full = {
    icone = "fa_battery_full",
    color = C.palette.green.bright,
  }
}

local function getBattery(level)
  log("level: ", level)
  log("step: ", (level * 100) - ((level * 100) % 20 ))
end ]]

---@param kt string|nil key table in use
local function selectSection(kt)
  if kt ~= nil and kt == 'copy_mode' then
    return gb
  end
  return ob
end

---@param kt string|nil key table in use
---@param txt string
---@return string
local function workspaceIcone(kt, txt)

  local icone = wezterm.nerdfonts.md_apps
  if kt ~= nil and kt == 'copy_mode' then
    icone = wezterm.nerdfonts.md_content_copy
  end

  return icone .. ' ' .. txt
end

function M.right(win)
  local key_table = win:active_key_table()

  return merge(
    S.if_def(key_table, KeyTableSection),
    time({{ Text = wezterm.time.now():format("%H:%M %F") }})
  )
end

function M.left(win)
  local key_table = win:active_key_table()

  return selectSection(key_table)(
    workspaceIcone(key_table, win:active_workspace())
  )
end

return M
