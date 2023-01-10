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

--[[ if require "djavrell.init_config"() then
  return
end ]]

vim.cmd([[
  try
    source $XDG_CONFIG_HOME/local_nvim.vim
  catch
    let mapleader = '='
  endtry

  filetype plugin indent on
]])

require('djavrell.globals')
require('lazy').setup('plugins')

require('djavrell.augroups')

require('djavrell.telescope.setup')
require('djavrell.telescope.mapping')
