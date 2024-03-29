---@meta wezline

---@alias IconeTable table<string, string>

---@class StatuslineOpt
---@field key_table_icone IconeTable|nil
---@field battery wezline.battery.BatteryConfig|nil

---@class StatuslineConfig
---@field key_table_icone IconeTable
---@field battery wezline.battery.BatteryConfig

---@class Wezline
---@field config fun(opt?: StatuslineOpt): nil
---@field updateConfig fun(opt: StatuslineOpt): StatuslineConfig
---@field getConfig fun(): StatuslineConfig
