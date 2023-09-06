local M = {}

---@param a table
---@param b table
---@return table
function M.merge(a, b)
  local c = {}

  for _,v in ipairs(a) do
    table.insert(c, v)
  end
  for _,v in ipairs(b) do
    table.insert(c, v)
  end

  return c
end

---@param ... table|fun(): table
---@return table
function M.merge_all(...)
  local result = {}
  local tables = { ... }

  for i=1, #tables do
    if type(tables[i]) == "function" then
      result = M.merge(result, tables[i]())
    else
      local t = tables[i]

      ---@cast t table
      result = M.merge(result, t)
    end
  end

  return result
end

return M
