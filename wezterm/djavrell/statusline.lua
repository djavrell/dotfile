local wezterm = require('wezterm')
local NF = wezterm.nerdfonts
local M = {}

local C = require('djavrell.colors')
local T = require('utils.tables')

local key_table_icons = {
  copy_mode = NF.md_content_copy,
}

-- same icon table on purpose (in copy mode the workspace block shows the copy icon), only the fallback differs
local ws_icon = T.setDefault(key_table_icons, NF.md_apps)
local kt_icon = T.setDefault(key_table_icons, NF.md_table_key)

---@param background string
---@param foreground string
---@param text string
---@param bold? boolean
---@return table[] items for wezterm.format
local function section(background, foreground, text, bold)
  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Attribute = { Intensity = bold and 'Bold' or 'Normal' } },
    { Text = ' ' .. text .. ' ' },
    'ResetAttributes',
  }
end

-- index = charge rounded to the nearest 10%
local battery_icons = {
  [0] = NF.md_battery_outline,
  NF.md_battery_10,
  NF.md_battery_20,
  NF.md_battery_30,
  NF.md_battery_40,
  NF.md_battery_50,
  NF.md_battery_60,
  NF.md_battery_70,
  NF.md_battery_80,
  NF.md_battery_90,
  NF.md_battery,
}

-- above this charge the icon is enough, below it the percentage shows too
local battery_percent_threshold = 0.4

---@return table[] one section per battery running on its charge, none on AC
local function batterySections()
  local items = {}

  for _, battery in ipairs(wezterm.battery_info()) do
    if battery.state == 'Discharging' then
      local charge = battery.state_of_charge
      local text = battery_icons[math.floor(charge * 10 + 0.5)]
      if charge < battery_percent_threshold then
        text = string.format('%s %.0f%%', text, charge * 100)
      end
      items = T.merge(items, section(C.palette.black0, C.palette.white1, text))
    end
  end

  return items
end

function M.right(win)
  local key_table = win:active_key_table()
  local items = batterySections()

  if key_table then
    items = T.merge(items, section(C.palette.orange.bright, C.palette.black0, kt_icon[key_table] .. ' ' .. key_table, true))
  end

  return T.merge(items, section(C.palette.black0, C.palette.white1, wezterm.time.now():format('%H:%M %F')))
end

function M.left(win)
  local key_table = win:active_key_table()
  -- the workspace block turns green in copy mode
  local background = key_table == 'copy_mode' and C.palette.green.bright or C.palette.orange.bright

  return section(background, C.palette.black0, ws_icon[key_table] .. ' ' .. win:active_workspace(), true)
end

return M
