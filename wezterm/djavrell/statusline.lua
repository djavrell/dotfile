local wezterm = require 'wezterm'
local M = {}

local C = require("djavrell.colors")
local merge = require("utils.merge").merge_all
local P = require("utils.pipe")

local config = require('wezline').getConfig()

local S = require("wezline.sections")
local A = require("wezline.attrs")

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

local function KeyTableSection(kt)
  local icone = wezterm.nerdfonts.md_table_key
  if kt ~= nil and config.key_table_icone[kt] ~= nil then
    icone = config.key_table_icone[kt]
  end

  return ob(icone .. ' ' .. kt)
end

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
  if kt ~= nil and config.key_table_icone[kt] ~= nil then
    icone = config.key_table_icone[kt]
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
