local opt = vim.opt
local g = vim.g

opt.shell = "/bin/zsh"
opt.encoding = "utf8"
opt.guifont = "Hasklug_Nerd_Font:h11"

-- opt.listchars = opt.listchars + {tab = "→", trail = "⋅", extends = "❯", precedes = "❮" }
-- opt.listchars = opt.listchars + "tab:→\ ,trail:⋅,extends:❯,precedes:❮"
opt.showbreak = "↪"
opt.backspace = opt.backspace +  {"indent", "eol", "start"}
opt.nrformats = opt.nrformats - "octl"
opt.path = opt.path + "**"
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2 -- size of an indents
opt.completeopt = {"menuone", "noinsert", "noselect" }
opt.inccommand = "nosplit"
opt.scrolloff = 5
opt.shortmess = opt.shortmess + "c"
opt.formatoptions = opt.formatoptions - {"c" , "r" , "o"}
opt.signcolumn = "yes"
opt.cmdheight = 2
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

vim.cmd[[ syntax enable ]]
opt.foldmethod = "syntax"
opt.foldlevel = 1
-- vim.cmd[[ set foldexpr=nvim_treesitter#foldexpr() ]]

g.nvcode_termcolors = 256
opt.termguicolors = true
opt.background = "dark"

opt.foldlevel = 1

vim.cmd[[ colorscheme gruvbox ]]
vim.cmd[[ syntax on ]]
