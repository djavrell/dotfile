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
  end
})

api.nvim_create_autocmd("TextYankPost", {
  group = M.yank,
  callback = function()
    vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  end
})


--[[
test for TS query

((function_call
  name: (_) @_vimcmd_identifier
  arguments: (arguments (string content: _ @vim)))
  (#any-of? @_vimcmd_identifier "vim.cmd" "vim.api.nvim_command" "vim.api.nvim_exec"))
--]]
vim.cmd [[
  augroup Foo
  augroup END
]]

--[[
((function_call
  name: (_) @autocmd
  arguments: [
    (table_constructor) @table <-- Error here
  ])
 (#any-of? @autocmd "autocmd" "api.nvim_create_autocmd" "vim.api.nvim_create_autocmd")
)
--]]
autocmd({"BufRead", "BufNewFile"}, {
  group = M.scala,
  pattern = "*.sbt",
  command = "set filetype=scala"
})

function foo() end

foo()

return M
