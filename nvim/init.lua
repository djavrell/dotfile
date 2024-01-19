vim.cmd([[
  try
    source $XDG_CONFIG_HOME/local_nvim.vim
  catch
    let mapleader = '='
  endtry

  filetype plugin indent on
]])

require('djavrell.globals')
require('djavrell.lazy_init')
require('djavrell.augroups')

require('djavrell.telescope.setup')
require('djavrell.telescope.mapping')
