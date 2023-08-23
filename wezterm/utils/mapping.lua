local M = {}

M.mod = function(mods)
  return function(key, action)
    return { mods = mods, key = key, action = action }
  end
end

return M
