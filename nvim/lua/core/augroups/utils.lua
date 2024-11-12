local augroup = {}

return setmetatable({}, {
  __index = function(_, k)
    if not augroup[k] then
      augroup[k] = vim.api.nvim_create_augroup(k, { clear = true })
    end
    return augroup[k]
  end,
})
