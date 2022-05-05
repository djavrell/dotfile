local map = vim.api.nvim_set_keymap
local Telescope = require('telescope')
local actions = require('telescope.actions')

Telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      prompt_position = "bottom",
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    path_display = {},
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    mappings = {
      i = {
        -- IMPORTANT
        -- either hot-reloaded or `function(prompt_bufnr) telescope.extensions.hop.hop end`
        ["<C-h>"] = R("telescope").extensions.hop.hop,  -- hop.hop_toggle_selection
        -- custom hop loop to multi selects and sending selected entries to quickfix list
        ["<C-space>"] = function(prompt_bufnr)
          local opts = {
            callback = actions.toggle_selection,
            loop_callback = actions.send_selected_to_qflist,
          }
          require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
        end,
        ["<c-a>"] = actions.add_to_qflist,
        ["<c-A>"] = actions.add_selected_to_qflist,
        ["<c-q>"] = function(bufnr)
          actions.send_to_qflist(bufnr)
          actions.open_qflist(bufnr)
        end,
        ["<c-Q>"] = function(bufnr)
          actions.send_selected_to_qflist(bufnr)
          actions.open_qflist(bufnr)
        end
      },
    }
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
    },
    hop = {

    }
  }
}

-- extension
Telescope.load_extension('fzf')
Telescope.load_extension('hop')

local opt = { silent = true, noremap = true }
map('n', '<leader>f', '<cmd>lua require(\'telescope.builtin\').find_files()<cr>', opt)
map('n', '<leader>g', '<cmd>lua require(\'telescope.builtin\').live_grep()<cr>', opt)
map('n', '<leader>b', '<cmd>lua require(\'telescope.builtin\').buffers(require(\'telescope.themes\').get_dropdown({}))<cr>', opt)
map('n', '<space>r', '<cmd>lua require(\'telescope.builtin\').resume()<cr>', opt)
