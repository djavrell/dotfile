local M = {}

---@param str string string to split
---@param sep string separator use to split str
---@return string[]
M.split = function(str, sep)
  local result = {}
  for tok in str.gmatch(str, ('([^%s]+)'):format(sep)) do
    -- trim the ends only: spaces inside a label or a path are meaningful
    local trimed = tok:match('^%s*(.-)%s*$')
    table.insert(result, trimed)
  end

  return result
end

return M
