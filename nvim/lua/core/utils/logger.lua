local M = {}

local log = function(level, loc, msg)
  msg = msg:gsub("'", "''")
  vim.cmd(string.format([[
    echohl %s
    echom '[%s] %s'
    echohl NONE
  ]], level, loc, msg))
end

function M.info(...)
  return log("None", ...)
end

function M.warn(...)
  return log("WarningMsg", ...)
end

function M.err(...)
  return log("ErrorMsg", ...)
end

return M
