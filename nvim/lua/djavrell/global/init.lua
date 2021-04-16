P = function(v)
  print(vim.inspect(v))
  return v
end

D = function(...)
  local obj = vim.tbl_map(vim.inspect, {...})
  print(unpack(obj))
end

require("djavrell.global.opt")
