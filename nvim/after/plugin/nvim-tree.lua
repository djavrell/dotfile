local map = vim.keymap.map
local g = vim.g

g.nvim_tree_ignore = { '.git', 'node_modules', '.cache', 'target', '.metals' }
g.nvim_tree_size = 40
g.nvim_tree_gitignore = 1

map { "<leader>w", ":NvimTreeToggle<CR>", silent = true }
map { "<leader>x", ":NvimTreeFindFile<CR>", silent = true }
