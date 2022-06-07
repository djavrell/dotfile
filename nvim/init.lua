if require "djavrell.init_config"() then
  return
end

vim.cmd([[
  try
    source $XDG_CONFIG_HOME/local_nvim.vim
  catch
    let mapleader = '='
  endtry

  filetype plugin indent on
]])

require('djavrell.globals')
require('plugins')

require('djavrell.auto_cmd')
require('djavrell.dap.setup')

require('djavrell.telescope.setup')
require('djavrell.telescope.mapping')
