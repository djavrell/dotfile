local U = require('core.utils.ui')

local Telescope = require('telescope')
local actions = require('telescope.actions')
local actions_layout = require('telescope.actions.layout')

Telescope.setup({
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    prompt_prefix = '> ',
    selection_caret = '> ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'descending',
    layout_strategy = 'horizontal',
    layout_config = {
      prompt_position = 'bottom',
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter = require('telescope.sorters').get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
    path_display = {},
    border = true,
    borderchars = {
      prompt = U.border_chars_outer_thin_telescope,
      results = U.border_chars_outer_thin_telescope,
      preview = U.border_chars_outer_thin_telescope,
    },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    mappings = {
      i = {
        ['<c-q>'] = function(bufnr)
          actions.smart_add_to_qflist(bufnr)
          actions.open_qflist(bufnr)
        end,
        ['<c-d>'] = actions.delete_buffer,
        ['<c-o>'] = actions_layout.toggle_preview,
        ['<c-j>'] = actions.preview_scrolling_down,
        ['<c-k>'] = actions.preview_scrolling_up,
        ['<c-v>'] = actions.file_vsplit,
        ['<c-t>'] = actions.file_tab,
      },
      n = {
        ['d'] = actions.delete_buffer,
        ['q'] = function(bufnr)
          actions.smart_add_to_qflist(bufnr)
          actions.open_qflist(bufnr)
        end,
        ['p'] = actions_layout.toggle_preview,
        ['<c-j>'] = actions.preview_scrolling_down,
        ['<c-k>'] = actions.preview_scrolling_up,
        ['<c-v>'] = actions.file_vsplit,
        ['<c-t>'] = actions.file_tab,
      },
    },
  },
  extensions = {
    fzf = {
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
    },
    menufacture = {
      mappings = {
        main_menu = {
          [{ 'i', 'n' }] = '<C-k>',
        },
      },
    },
  },
})

-- extension
Telescope.load_extension('fzf')
Telescope.load_extension('menufacture')
