vim.loader.enable()
local ui = require("core.utils.ui")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
  spec = {
    { import = "plugins" }
  },
  ui = {
    border = ui.border_thin,
    backdrop = 100,
  }
})

