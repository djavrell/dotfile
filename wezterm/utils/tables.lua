local wezterm = require 'wezterm'
local log = wezterm.log_info

local M = {}

function M.intercal(tables, nodes)
  for i=2, #tables, 2 do
    table.insert(tables, i, nodes)
  end
  return tables
end

function M.include(table, key)
  for _, v in ipairs(table) do
    if v == key then
      return true
    end
  end
  return false
end

return M
