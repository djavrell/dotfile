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
    elseif type(tables[i]) == "string" then
      table.insert(result, tables[i])
    else
      local t = tables[i]

      ---@cast t table
      result = M.merge(result, t)
    end
  end

  return result
end

---@generic K
---@generic V
---@param a table<`K`, `V`>
---@param b table<`K`, `V`>
---@return table<`K`, `V`>
function M.tbl_extend(a, b)
  local result = {}

  for k,v in pairs(a) do
    if type(v) == 'table' then
      if (type(b[k]) or false) == 'table' then
        result[k] = M.tbl_extend(a[k], b[k])
      else
        result[k] = b[k] or v
      end
    else
      result[k] = b[k] or v
    end
  end

  return result
end

return M
