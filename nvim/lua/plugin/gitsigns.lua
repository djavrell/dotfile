require('gitsigns').setup()

vim.cmd[[ :command! -nargs=0 Blame lua require"gitsigns".blame_line()<CR> ]]
