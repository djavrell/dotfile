---@diagnostic disable: missing-fields
return {
  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',

  'rebelot/kanagawa.nvim',
  'sainnhe/gruvbox-material',

  'lifepillar/vim-colortemplate',
  'ryanoasis/vim-devicons',
  'kyazdani42/nvim-web-devicons', -- for file icons
  'mortepau/codicons.nvim',
  {
    'catgoose/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {},
  },

  'hsanson/vim-openapi',

  'mtdl9/vim-log-highlighting',

  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup({
        mappings = {
          '<C-u>',
          '<C-d>',
          'zz',
        },
      })
    end,
  },

  'vim-utils/vim-troll-stopper',
  {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.cmd([[
        let g:better_whitespace_filetypes_blacklist=['<filetype1>', '<filetype2>', '<etc>', 'diff', 'gitcommit', 'unite', 'qf', 'help', 'dashboard']
        let g:better_whitespace_operator=''

        nmap <silent> <C-Space> :StripWhitespace<CR>
      ]])
    end,
  },
  {
    'm4xshen/smartcolumn.nvim',
    config = function()
      require('smartcolumn').setup({
        disabled_filetypes = {
          'help',
          'text',
          'markdown',
          'dbout',
          'man',
          'lazy',
        },
        limit_to_line = true,
      })
    end,
  },

  -- utils
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>s', '<space>j' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup()
    end,
  },
  'christianrondeau/vim-base64',
  {
    'kburdett/vim-nuuid',
    keys = { '<leader>u' },
    config = function()
      vim.g.nuuid_no_mappings = 1
    end,
  },

  {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup({
        move_cursor = false,
        indent_lines = false,
      })
    end,
  },
  'AndrewRadev/tagalong.vim',

  {
    'meznaric/key-analyzer.nvim',
    config = function()
      require('key-analyzer').setup()
    end,
  },

  {
    'rhysd/vim-fixjson',
    ft = 'json',
    config = function()
      vim.g.fixjson_fix_on_save = 0
    end,
  },
  {
    'jamessan/vim-gnupg',
  },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },
  'JoosepAlviste/nvim-ts-context-commentstring',

  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup({})
    end,
  },
  {
    'gregorias/coerce.nvim',
    config = function()
      require('coerce').setup({})
    end,
  },

  {
    'ptdewey/yankbank-nvim',
    cmd = { 'YankBank' },
    keys = {
      { '<leader>y', '<cmd>YankBank<cr>', { noremap = true, silent = true } },
    },
    config = function()
      require('yankbank').setup()
    end,
  },

  {
    'kevinhwang91/nvim-bqf',
    config = function()
      require('bqf').setup({
        auto_enable = true,
        auto_resize_height = true,
      })
    end,
  },
  {
    'junegunn/fzf',
    build = function()
      vim.fn['fzf#install']()
    end,
  },
}
