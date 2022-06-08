local api = vim.api
local ag = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd

local opt = { clear = true }
local M = {
  nvimTree = ag("nvimTree", opt),
  yank = ag("highliht_yank", opt),
  scala = ag("Scala", opt),
  gpg = ag("GPG", opt),
  troll = ag("TrollStopper", opt),
  global = ag("Global", opt),
  help = ag("HelpFile", opt),
  envRC = ag("EnvRC", opt)
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

autocmd("User", {
  group = M.gpg,
  pattern = "GnuPG",
  command = "setl textwidth=72"
})

autocmd("ColorScheme", {
  group = M.troll,
  pattern = "*",
  command = "highlight TrollStopper ctermbg=red guibg=#FF0000"
})

autocmd("BufRead", {
  group = M.global,
  pattern = "*.conf",
  command = "set ft=conf"
})

vim.cmd [[
  augroup Global
    autocmd!
    autocmd BufRead *.conf set ft=conf
    autocmd BufWritePre * :%s/\s\+$//e
  augroup END
]]
-- autocmd("BufWritePre", {
--   group = M.global,
--   pattern = "*",
--   command = ":%s/\s\+$//e"
-- })

autocmd("BufEnter", {
  group = M.help,
  pattern = "*",
  command = "if &buftype ==# 'help' | nnoremap gd <C-]> | endif"
})

autocmd("BufRead", {
  group = M.envRC,
  pattern = { ".envrc", ".env.*", ".env" },
  command = "set ft=sh"
})

return M
