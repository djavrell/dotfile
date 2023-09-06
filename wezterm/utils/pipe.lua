local M = {}

--- @generic T
--- @param data `T`
--- @param ... fun(data: T): T
--- @return T
function M.pipe(data, ...)
  local func = { ... }
  local res = data

  for i=1, #func do
    res = func[i](res)
  end

  return res
end

return M
