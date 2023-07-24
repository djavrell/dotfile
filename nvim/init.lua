vim.loader.enable()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.cmd([[
  try
    source $XDG_CONFIG_HOME/local_nvim.vim
  catch
    let mapleader = '='
  endtry

  filetype plugin indent on
]])

require('djavrell.globals')
local U = require('djavrell.utils.ui')

require('lazy').setup('plugins', {
  ui = {
    border = U.border_chars_outer_thin,
  }
})

require('djavrell.augroups')

require('djavrell.telescope.setup')
require('djavrell.telescope.mapping')
