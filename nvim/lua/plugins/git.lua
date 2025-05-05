return {
  'rhysd/git-messenger.vim',
  {
    'rhysd/committia.vim',
    config = function()
      vim.cmd([[
        let g:committia_edit_window_width = 120
        let g:committia_hooks = {}
        function! g:committia_hooks.edit_open(info)
            " Additional settings
            setlocal spell

            " If no commit message, start with insert mode
            if a:info.vcs ==# 'git' && getline(1) ==# ''
                startinsert
            endif

            " Scroll the diff window from insert mode
            " Map <C-n> and <C-p>
            imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
            nmap <buffer> ) <Plug>(committia-scroll-diff-down-half)

            imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
            nmap <buffer> ( <Plug>(committia-scroll-diff-up-half)
        endfunction
      ]])
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require('gitsigns')
      gitsigns.setup()

      vim.api.nvim_create_user_command('Blame', 'Gitsigns blame_line', {})
    end,
  },
  {
    'SuperBo/fugit2.nvim',
    opts = {
      width = '95%',
      max_width = '95%',
      height = '95%',
      external_diffview = true,
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit',
      },
    },
    cmd = { 'Fugit2', 'Fugit2Graph' },
    keys = {
      { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' },
    },
  },
  {
    'isakbm/gitgraph.nvim',
    ---@type I.GGConfig
    opts = {
      symbols = {
        merge_commit = 'M',
        commit = '*',
      },
      format = {
        timestamp = '%H:%M:%S %d-%m-%Y',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      },
      hooks = {
        -- Check diff of a commit
        on_select_commit = function(commit)
          vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
          vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
          vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
        end,
      },
    },
    keys = {
      {
        '<leader>gl',
        function()
          require('gitgraph').draw({}, { all = true, max_count = 5000 })
        end,
        desc = 'GitGraph - Draw',
      },
    },
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('octo').setup({
        suppress_missing_scope = {
          projects_v2 = true,
        },
        mappings = {
          review_diff = {
            select_next_entry = { lhs = '<space>n', desc = 'move to next changed file' },
            select_prev_entry = { lhs = '<space>p', desc = 'move to previous changed file' },
            select_first_entry = { lhs = '<space>N', desc = 'move to first changed file' },
            select_last_entry = { lhs = '<space>P', desc = 'move to last changed file' },
          },
        },
      })
      vim.treesitter.language.register('markdown', 'octo')
    end,
  },
}
