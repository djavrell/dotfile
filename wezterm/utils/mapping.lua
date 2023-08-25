---@alias ModifierMapping fun(mod: string): KeyMapping
---@alias KeyMapping fun(key: string, action: function): table

---@class Mapping
---@field mod ModifierMapping
local M = {}

---@type ModifierMapping
M.mod = function(mods)
  ---@type KeyMapping
  return function(key, action)
    return { mods = mods, key = key, action = action }
  end
end

return M
