return {
  'rhysd/git-messenger.vim',
  {
    'rhysd/committia.vim',
    config = function()
      vim.cmd[[
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
      ]]
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require('gitsigns')
      gitsigns.setup()

      vim.api.nvim_create_user_command('Blame', 'Gitsigns blame_line', {})

      local Hydra = require('hydra')
      local hint = [[
      _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
      _K_: prev hunk   _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full
      _x_: reset hunk  _S_: stage buffer      ^ ^                 _/_: show base file
      ^
      ^ ^              _<Enter>_: Neogit              _q_: exit
      ]]

      Hydra({
        hint = hint,
        config = {
            color = 'pink',
            invoke_on_body = true,
            hint = {
              position = 'bottom',
              border = 'rounded'
            },
            on_enter = function()
              gitsigns.toggle_linehl(true)
            end,
            on_exit = function()
              gitsigns.toggle_linehl(false)
              gitsigns.toggle_deleted(false)
            end
        },
        mode = {'n','x'},
        body = '<leader>a',
        heads = {
            { 'J', function()
                  if vim.wo.diff then return ']c' end
                  vim.schedule(function() gitsigns.next_hunk() end)
                  return '<Ignore>'
              end, { expr = true } },
            { 'K', function()
                  if vim.wo.diff then return '[c' end
                  vim.schedule(function() gitsigns.prev_hunk() end)
                  return '<Ignore>'
              end, { expr = true } },
            { 'x', gitsigns.reset_hunk },
            { 's', ':Gitsigns stage_hunk<CR>', { silent = true } },
            { 'u', gitsigns.undo_stage_hunk },
            { 'S', gitsigns.stage_buffer },
            { 'p', gitsigns.preview_hunk },
            { 'd', gitsigns.toggle_deleted, { nowait = true } },
            { 'b', gitsigns.blame_line },
            { 'B', function() gitsigns.blame_line{ full = true } end },
            { '/', gitsigns.show, { exit = true } }, -- show the base of the file
            { '<Enter>', '<cmd>Neogit<CR>', { exit = true } },
            { 'q', nil, { exit = true, nowait = true } },
        }
      })
    end
  },
  {
    'SuperBo/fugit2.nvim',
    opts = {
      width = "95%",
      max_width = "95%",
      height = "95%",
      external_diffview = true,
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit',
        dependencies = { 'stevearc/dressing.nvim' }
      }
    },
    cmd = { 'Fugit2', 'Fugit2Graph' },
    keys = {
      { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' }
    }
  },
}
