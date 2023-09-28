local wezterm = require('wezterm')
local NF = wezterm.nerdfonts
local T = require('utils.tables')

---@type StatuslineConfig
local conf = {}

---@type Wezline
local M = {}

---@type StatuslineConfig
local defaultConfig = {
  key_table_icone = {
    copy_mode = NF.md_content_copy
  },
  battery = {
    icons = {
      charges = {
        NF.md_battery_outline,
        NF.md_battery_10,
        NF.md_battery_20,
        NF.md_battery_30,
        NF.md_battery_40,
        NF.md_battery_50,
        NF.md_battery_60,
        NF.md_battery_70,
        NF.md_battery_80,
        NF.md_battery_90,
        NF.md_battery
      },
      state = {
        Full = NF.md_battery,
        Charging = NF.md_lightning_bolt,
        Discharging = NF.md_lightning_bolt_outline,
      }
    },
    colors = {
      warning = "nope"
    }
  }
}

---@param opt StatuslineOpt|nil
function M.config(opt)
  conf = T.tbl_extend(defaultConfig, opt or {})
end

---@param opt StatuslineOpt
---@return StatuslineConfig
function M.updateConfig(opt)
  conf = T.tbl_extend(conf, opt or {})
  return conf
end

---@return StatuslineConfig
function M.getConfig()
  return conf
end

return M
