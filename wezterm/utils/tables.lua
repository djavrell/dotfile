---@class TableUtils
local M = {}

---@param a table
---@param b table
---@return table
function M.merge(a, b)
  local c = {}

  for _, v in ipairs(a) do
    table.insert(c, v)
  end
  for _, v in ipairs(b) do
    table.insert(c, v)
  end

  return c
end

---@generic V
---@param a table<string, `V`>
---@param b table<string, `V`>
---@return table<string, `V`>
function M.tbl_extend(a, b)
  local result = {}

  for k, v in pairs(a) do
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

---@param orig table
---@param copies? table
---@return table
function M.clone(orig, copies)
  copies = copies or {}
  local copy
  if type(orig) == 'table' then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}
      copies[orig] = copy
      for orig_key, orig_value in next, orig, nil do
        copy[M.clone(orig_key, copies)] = M.clone(orig_value, copies)
      end
      setmetatable(copy, M.clone(getmetatable(orig), copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

---@generic T
---@param t table
---@param d T
---@return table
function M.setDefault(t, d)
  local t2 = M.clone(t)
  return setmetatable(t2, {
    __index = function(_, _)
      return d
    end,
  })
end

return M
