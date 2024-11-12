local wez = require('wezterm')
local log = wez.log_info

local B = {}

---@type wezline.battery.BatteryConfig
local config = require('wezline').getConfig().battery

---@param info wezline.battery.BatteryInfo
---@return string
local function get_charge_icon(info)
  local nb_step = #config.icons.charges - 1
  local lvl = info.state_of_charge * 100

  local step = math.floor((lvl - (lvl % nb_step)) / 10) + 1
  return config.icons.charges[step]
end

---@param info wezline.battery.BatteryInfo
---@return string|nil
local function get_battery_state(info)
  return config.icons.state[info.state]
end

function B.section()
  ---@type wezline.battery.BatteryInfo
  local battery_info = wez.battery_info()[1]

  --[[ local tests = {
    battery_info,
    {
      state_of_charge = 1.0,
      state = "Full"
    },
    {
      state_of_charge = 0.94,
      state = "Discharging"
    },
    {
      state_of_charge = 0.85,
      state = "Discharging"
    },
    {
      state_of_charge = 0.59,
      state = "Discharging"
    },
    {
      state_of_charge = 0.23,
      state = "Charging"
    },
    {
      state_of_charge = 0.03,
      state = "Discharging"
    },
    {
      state_of_charge = 0.0,
      state = "Empty"
    },
  }

  for _,data in pairs(tests) do
    log(data)
    log("charge: ", get_charge_icon(data))
    log("state : ", get_battery_state(data))
    log("")
  end ]]
end

return B
