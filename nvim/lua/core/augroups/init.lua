local autocmd = vim.api.nvim_create_autocmd

local augroups = require('core.augroups.utils')

autocmd('TextYankPost', {
  group = augroups['yank'],
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

autocmd('User', {
  group = augroups['gpg'],
  pattern = 'GnuPG',
  command = 'setl textwidth=72',
})

autocmd('ColorScheme', {
  group = augroups['troll'],
  pattern = '*',
  command = 'highlight TrollStopper ctermbg=red guibg=#FF0000',
})

autocmd('BufRead', {
  group = augroups['global'],
  pattern = '*.conf',
  command = 'set ft=conf',
})

autocmd('BufEnter', {
  group = augroups['help'],
  pattern = '*',
  command = "if &buftype ==# 'help' | nnoremap gd <C-]> | endif",
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroups['env'],
  pattern = { '*.env', '*.env.*' },
  command = 'set ft=sh',
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroups['zsh'],
  pattern = { '*.zsh' },
  command = 'set ft=sh',
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroups['git'],
  pattern = { '*gitconfig*' },
  command = 'set ft=gitconfig',
})
