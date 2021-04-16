--[[
TODO:
when merged: https://github.com/neovim/neovim/pull/13479
get ride of: `./lua/tj/globals/opt.lua
]]--
local opt = vim.opt
local g = vim.g

opt.shell = "/bin/zsh"
opt.encoding = "utf8"
opt.guifont = "Hasklug_Nerd_Font:h11"

-- TODO: figure out this one
-- opt.listchars = {tab="→", trail="⋅", extends="❯", precedes="❮" }
opt.showbreak = "↪"
opt.backspace = opt.backspace +  {"indent", "eol", "start"}
opt.completeopt = {"menuone", "noinsert", "noselect" }
opt.inccommand = "nosplit"
opt.nrformats = opt.nrformats - 'octl'
opt.path = opt.path + "**"
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2 -- size of an indents
opt.scrolloff = 5
-- FIXME: dafuck is going on here
-- opt.shortmess = opt.shortmess + 'c'
vim.cmd[[ set shortmess+=c  ]]
opt.formatoptions = opt.formatoptions - 'c' - 'r' - 'o'
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.spelllang = { "en_us", "fr_fr" }

opt.compatible = false
opt.backup = false
opt.swapfile = false
opt.writebackup = false

opt.hidden = true
opt.autoread = true
opt.relativenumber = true
opt.number = true
opt.list = true
opt.showmatch = true
opt.shiftround = true
opt.expandtab = true
opt.smarttab = true

opt.foldmethod = "expr"
vim.cmd[[ set foldexpr=nvim_treesitter#foldexpr() ]]

g.nvcode_termcolors = 256
opt.termguicolors = true
opt.background = "dark"

opt.foldlevel = 1

vim.cmd[[ syntax enable ]]
vim.cmd[[ colorscheme gruvbox ]]
vim.cmd[[ syntax on ]]
