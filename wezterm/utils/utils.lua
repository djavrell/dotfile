local M = {}

M.pipe = function(data, ...)
  local func = { ... }
  local res = data

  for i=1, #func do
    res = func[i](res)
  end

  return res
end

return M
