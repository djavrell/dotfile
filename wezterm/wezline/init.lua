local wezterm = require("wezterm")
local G = wezterm.GLOBAL
local NF = wezterm.nerdfonts
local T = require('utils.merge')

local M = {}

local namespace = "wezline"

---@alias IconeTable table<string, string>

---@class StatuslineOpt
---@field key_table_icone IconeTable|nil

---@class StatuslineConfig
---@field key_table_icone IconeTable

---@type StatuslineConfig
local defaultConfig = {
  key_table_icone = {
    copy_mode = NF.md_content_copy
  },
}

---@param opt StatuslineOpt|nil
function M.config(opt)
  G[namespace] = T.tbl_extend(defaultConfig, opt or {})
end

---@return StatuslineConfig
function M.getConfig()
  return G[namespace]
end

return M
