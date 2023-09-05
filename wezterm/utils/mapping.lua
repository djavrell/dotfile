---@alias ModifierMapping fun(mod: string): KeyMapping
---@alias KeyMapping fun(key: string, action: function): table

---@class Mapping
---@field mod ModifierMapping
---@field [string] KeyMapping
local M = {}

---@type ModifierMapping
M.mod = function(mods)
  ---@type KeyMapping
  return function(key, action)
    return { mods = mods, key = key, action = action }
  end
end

M.alt = M.mod('ALT')
M.Alt = M.mod('ALT|SHIFT')
M.ctrl = M.mod('CTRL')
M.cm = M.mod('CTRL|SHIFT')
M.leader = M.mod('LEADER')

return M
