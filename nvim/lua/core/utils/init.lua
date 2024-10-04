local M = {}

function M.every(array, predicate)
  for _, v in pairs(array) do
    if not predicate(v) then
      return false
    end
  end
  return true
end

function M.some(array, predicate)
  for _, v in pairs(array) do
    if predicate(v) then
      return true
    end
  end
  return false
end

return M
