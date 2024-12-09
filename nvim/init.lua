vim.cmd([[
  try
    source $XDG_CONFIG_HOME/local_nvim.vim
  catch
    let mapleader = '!'
    let maplocalleader = '!'
  endtry

  filetype plugin indent on
]])

require('core.globals')
require('core.lazy_init')
-- require('core.options')
require('core.augroups')
require('core.commands')
