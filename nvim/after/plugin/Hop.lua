require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }

local mapOpt = { silent = true, noremap = true }

-- vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
-- vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
-- vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
-- vim.api.nvim_set_keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
-- vim.api.nvim_set_keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
-- vim.api.nvim_set_keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})

vim.api.nvim_set_keymap('', 'f', ":HopWordAC<CR>", mapOpt)
vim.api.nvim_set_keymap('o', 'f', ":HopWordCurrentLineAC<CR>", mapOpt)
-- vim.api.nvim_set_keymap('o', 'f', ":HopChar1CurrentLineAC<CR>", mapOpt)
-- vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
vim.api.nvim_set_keymap('', 'F', ":HopWordBC<CR>", mapOpt)
vim.api.nvim_set_keymap('o', 'F', ":HopWordCurrentLineBC<CR>", mapOpt)

vim.api.nvim_set_keymap('n', '<leader>k', ":HopLineBC<CR>", mapOpt)
vim.api.nvim_set_keymap('n', '<leader>j', ":HopLineAC<CR>", mapOpt)
