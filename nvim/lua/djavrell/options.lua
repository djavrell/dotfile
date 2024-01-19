vim.opt_global.completopt = { "menu", "menuone", "noselect" }
vim.opt_global.shortmess:remove("F"):append("c")

vim.cmd([[
  try
    source $XDG_CONFIG_HOME/local_nvim.vim
  catch
    let mapleader = '='
  endtry

  filetype plugin indent on
]])

