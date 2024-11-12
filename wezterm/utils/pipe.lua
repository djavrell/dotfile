local M = {}

--- @generic T
--- @param data `T`
--- @param ... fun(data: T): T
--- @return T
function M.pipe(data, ...)
  local func = { ... }
  local res = data

  for i = 1, #func do
    res = func[i](res)
  end

  return res
end

--- @generic T
--- @param ... fun(data: T): T
--- @return T
function M.pipeC(...)
  local func = { ... }

  --- @param data `T`
  return function(data)
    local res = data

    for i = 1, #func do
      res = func[i](res)
    end

    return res
  end
end

---@generic T
---@param f fun(T, T): T
---@param acc `T`
---@param ... `T`
---@return T
function M.reduce(f, acc, ...)
  local data = { ... }

  for i = 1, #data do
    acc = f(acc, data[i])
  end

  return acc
end

return M
