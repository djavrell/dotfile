---@meta wezline.Battery

---@class wezline.battery.BatteryIcons
---@field charges string[]
---@field state wezline.battery.BatteryIcons.State

---@class wezline.battery.BatteryConfig
---@field icons wezline.battery.BatteryIcons
---@field colors table

---@alias wezline.battery.BatteryIcons.State table<wezline.battery.BatteryStateEnum, string>

---@alias wezline.battery.BatteryStateEnum
---| "Charging"
---| "Discharging"
---| "Empty"
---| "Full"
---| "Unknown"

---@class wezline.battery.BatteryInfo
---@field state wezline.battery.BatteryStateEnum
---@field state_of_charge number
