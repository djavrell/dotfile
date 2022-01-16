if require "djavrell.init_config"() then
  return
end

require('plugins')

vim.cmd([[
  try
    source $XDG_CONFIG_HOME/local_nvim.vim
  catch
    let mapleader = '='
  endtry

  filetype plugin indent on
]])
