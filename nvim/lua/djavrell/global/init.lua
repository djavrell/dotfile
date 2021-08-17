function _G.info(v)
  print(vim.inspect(v))
  return v
end

function _G.dump(...)
  local obj = vim.tbl_map(vim.inspect, {...})
  print(unpack(obj))
  return ...
end
