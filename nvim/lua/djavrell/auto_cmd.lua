local api = vim.api
local ag = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd

local opt = { clear = true }
local M = {
  nvimTree = ag("nvimTree", opt),
  yank = ag("highliht_yank", opt),
  scala = ag("Scala", opt)
}

vim.api.nvim_create_autocmd("BufEnter", {
  group = M.nvimTree,
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil then
      vim.cmd "quit"
    end
  end,
})

autocmd("TextYankPost", {
  group = M.yank,
  callback = function()
    vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  end
})

autocmd({"BufRead", "BufNewFile"}, {
  group = M.scala,
  pattern = "*.sbt",
  command = "set filetype=scala"
})

return M
