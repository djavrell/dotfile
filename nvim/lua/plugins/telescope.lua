return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      'molecule-man/telescope-menufacture',
    },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')
      local toggle_preview = require('telescope.actions.layout').toggle_preview

      local function send_to_qflist(prompt_bufnr)
        actions.smart_add_to_qflist(prompt_bufnr)
        actions.open_qflist(prompt_bufnr)
      end

      telescope.setup({
        defaults = {
          borderchars = require('core.utils.ui').border_chars_outer_thin_telescope,
          mappings = {
            i = {
              ['<c-q>'] = send_to_qflist,
              ['<c-o>'] = toggle_preview,
              ['<c-j>'] = actions.preview_scrolling_down,
              ['<c-k>'] = actions.preview_scrolling_up,
            },
            n = {
              q = send_to_qflist,
              p = toggle_preview,
              ['<c-j>'] = actions.preview_scrolling_down,
              ['<c-k>'] = actions.preview_scrolling_up,
            },
          },
        },
        pickers = {
          buffers = {
            theme = 'ivy',
            layout_config = { height = 0.6 },
            mappings = {
              i = { ['<c-d>'] = actions.delete_buffer },
              n = { d = actions.delete_buffer },
            },
          },
        },
        extensions = {
          menufacture = {
            -- wins over the preview scroll <c-k> in the menufacture pickers (grep)
            mappings = { main_menu = { [{ 'i', 'n' }] = '<C-k>' } },
          },
        },
      })

      telescope.load_extension('fzf')
      telescope.load_extension('menufacture')
      telescope.load_extension('ui-select')

      local menufacture = telescope.extensions.menufacture
      vim.keymap.set('n', '<leader>f', builtin.find_files)
      vim.keymap.set('n', '<leader>b', builtin.buffers)
      vim.keymap.set('n', '<leader>g', menufacture.live_grep)
      vim.keymap.set('n', '<leader>G', menufacture.grep_string)
      vim.keymap.set('n', '<space>r', builtin.resume)
    end,
  },
}
