require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }

local mapOpt = { silent = true, noremap = true }

vim.api.nvim_set_keymap(''  , 'f', ":HopWordAC<CR>",            mapOpt)
vim.api.nvim_set_keymap('o' , 'f', ":HopChar1CurrentLineAC<CR>", mapOpt)
vim.api.nvim_set_keymap('o' , 't', ":HopChar1CurrentLineAC<CR>", mapOpt)

vim.api.nvim_set_keymap(''  , 'F', ":HopWordBC<CR>",            mapOpt)
vim.api.nvim_set_keymap('o' , 'T', ":HopChar1CurrentLineBC<CR>", mapOpt)

vim.api.nvim_set_keymap('n', '<leader>k', ":HopLineBC<CR>", mapOpt)
vim.api.nvim_set_keymap('n', '<leader>j', ":HopLineAC<CR>", mapOpt)
