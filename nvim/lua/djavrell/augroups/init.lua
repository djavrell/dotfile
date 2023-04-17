local autocmd = vim.api.nvim_create_autocmd
local augroups = require('djavrell.augroups.utils')

autocmd("BufEnter", {
  group = augroups["nvimTree"],
  nested = true,
  callback = function()
    if #vim.api.nvim_tabpage_list_wins(0) == 1 and vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil then
      vim.cmd "quit"
    end
  end,
})

autocmd("TextYankPost", {
  group = augroups["yank"],
  callback = function()
    vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  end
})

autocmd({"BufRead", "BufNewFile"}, {
  group = augroups["scala"],
  pattern = { "*.sbt", "*.sc" },
  command = "set filetype=scala"
})

autocmd("User", {
  group = augroups["gpg"],
  pattern = "GnuPG",
  command = "setl textwidth=72"
})

autocmd("ColorScheme", {
  group = augroups["troll"],
  pattern = "*",
  command = "highlight TrollStopper ctermbg=red guibg=#FF0000"
})

autocmd("BufRead", {
  group = augroups["global"],
  pattern = "*.conf",
  command = "set ft=conf"
})

autocmd("BufEnter", {
  group = augroups["help"],
  pattern = "*",
  command = "if &buftype ==# 'help' | nnoremap gd <C-]> | endif"
})
