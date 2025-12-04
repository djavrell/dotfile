return {
  -- 'nvim-treesitter/playground',
  -- 'RRethy/nvim-treesitter-textsubjects',
  -- 'nvim-treesitter/nvim-treesitter-textobjects',
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })
    end,
  },
}
