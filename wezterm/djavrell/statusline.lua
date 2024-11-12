local wezterm = require('wezterm')
local M = {}

local C = require('djavrell.colors')
local P = require('utils.pipe')
local T = require('utils.tables')

---@type Wezline
local line = require('wezline')
local config = line.getConfig()

local ws_icone = T.setDefault(config.key_table_icone, wezterm.nerdfonts.md_apps)
local kt_icone = T.setDefault(config.key_table_icone, wezterm.nerdfonts.md_table_key)

local A = require('wezline.attrs')
local S = require('wezline.nodes')
-- local B = require("wezline.battery")

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

---@param kt? string
---@return wezline.Attr[]
local function KeyTableSection(kt)
  return ob(kt_icone[kt] .. ' ' .. kt)
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
  return ws_icone[kt] .. ' ' .. txt
end

function M.right(win)
  local key_table = win:active_key_table()

  return T.merge(S.if_def(key_table, KeyTableSection), time({ { Text = wezterm.time.now():format('%H:%M %F') } }))
end

function M.left(win)
  local key_table = win:active_key_table()
  -- B.section()

  return selectSection(key_table)(workspaceIcone(key_table, win:active_workspace()))
end

return M
