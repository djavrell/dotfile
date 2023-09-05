local wezterm = require('wezterm')
local M = {}

--- @generic T
--- @param data `T`
--- @param ... fun(data: T): T
--- @return T
M.pipe = function(data, ...)
  local func = { ... }
  local res = data

  for i=1, #func do
    res = func[i](res)
  end

  return res
end

---@param str string string to split
---@param sep string separator use to split str
---@return string[]
M.split = function(str, sep)
  local result = {}
  for tok in str.gmatch(str, ("([^%s]+)"):format(sep)) do
    local trimed = tok:gsub("%s", "")
    table.insert(result, trimed)
  end

  return result
end

return M
