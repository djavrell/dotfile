return {
  {
    'sindrets/diffview.nvim',
    config = function()
      local cb = require('diffview.config').diffview_callback
      local conflictChoose = cb('conflict_choose')

      require('diffview').setup({
        diff_binaries = false, -- Show diffs for binaries
        use_icons = true, -- Requires nvim-web-devicons
        file_panel = {
          win_config = {
            width = 35,
          },
        },
        view = {
          merge_tool = {
            layout = 'diff4_mixed',
            disable_diagnostics = true,
          },
        },
        hooks = {
          view_opened = function()
            -- h:activate()
          end,
          view_closed = function()
            -- h:exit()
          end,
        },
        key_bindings = {
          -- The `view` bindings are active in the diff buffers, only when the current
          -- tabpage is a Diffview.
          view = {
            ['<tab>'] = cb('select_next_entry'), -- Open the diff for the next file
            ['<s-tab>'] = cb('select_prev_entry'), -- Open the diff for the previous file
            ['<leader>e'] = cb('focus_files'), -- Bring focus to the files panel
            ['<leader>b'] = cb('toggle_files'), -- Toggle the files panel.
          },
          file_panel = {
            ['j'] = cb('next_entry'), -- Bring the cursor to the next file entry
            ['<down>'] = cb('next_entry'),
            ['k'] = cb('prev_entry'), -- Bring the cursor to the previous file entry.
            ['<up>'] = cb('prev_entry'),
            ['<cr>'] = cb('select_entry'), -- Open the diff for the selected entry.
            ['o'] = cb('select_entry'),
            ['R'] = cb('refresh_files'), -- Update stats and entries in the file list.
            ['<tab>'] = cb('select_next_entry'),
            ['<s-tab>'] = cb('select_prev_entry'),
            ['<leader>e'] = cb('focus_files'),
            ['<leader>b'] = cb('toggle_files'),
          },
          diff4 = {
            { { 'n', 'x' }, '<leader>co', cb('conflict_choose')('ours') },
            { { 'n', 'x' }, '<leader>ct', cb('conflict_choose')('theirs') },
            { { 'n', 'x' }, '<leader>cb', cb('conflict_choose')('base') },
            { { 'n', 'x' }, '<leader>ca', cb('conflict_choose')('all') },
            { { 'n', 'x' }, 'dx', cb('conflict_choose')('none') },
            { { 'n', 'x' }, '<leader>n', cb('next_conflict') },
            { { 'n', 'x' }, '<leader>p', cb('prev_conflict') },
          },
        },
      })
    end,
  },
}
