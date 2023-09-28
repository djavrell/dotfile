local wezterm = require 'wezterm'
local log = wezterm.log_info

---@class TableUtils
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

---@generic V
---@param a table<string, `V`>
---@param b table<string, `V`>
---@return table<string, `V`>
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

---@generic T
---@param table table<`T`, unknown>
---@param key T
---@return boolean
function M.include(table, key)
  for _, v in ipairs(table) do
    if v == key then
      return true
    end
  end
  return false
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
  log(t2)
  log(type(t2))
  return setmetatable(t2, {
    __index = function(_, _)
      return d
    end
  })
end

return M
