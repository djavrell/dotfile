local Telescope = require('telescope')
local actions = require('telescope.actions')
local actions_layout = require('telescope.actions.layout')
local lga_actions = require("telescope-live-grep-args.actions")

Telescope.setup {
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
        ["<C-h>"] = R("telescope").extensions.hop.hop,  -- hop.hop_toggle_selection
        -- custom hop loop to multi selects and sending selected entries to quickfix list
        ["<C-space>"] = function(prompt_bufnr)
          local opts = {
            callback = actions.toggle_selection,
            loop_callback = actions.send_selected_to_qflist,
          }
          require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
        end,
        ['<c-a>'] = function(bufnr)
          actions.add_to_qflist(bufnr)
          actions.open_qflist(bufnr)
        end,
        ['<c-A>'] = function(bufnr)
          actions.add_selected_to_qflist(bufnr)
          actions.open_qflist(bufnr)
        end,
        ['<c-q>'] = function(bufnr)
          actions.send_to_qflist(bufnr)
          actions.open_qflist(bufnr)
        end,
        ['<c-Q>'] = function(bufnr)
          actions.send_selected_to_qflist(bufnr)
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
        ['a'] = function(bufnr)
          actions.add_selected_to_qflist(bufnr)
          actions.open_qflist(bufnr)
        end,
        ['q'] = function(bufnr)
          actions.send_to_qflist(bufnr)
          actions.open_qflist(bufnr)
        end,
        ['p'] = actions_layout.toggle_preview,
        ['<c-j>'] = actions.preview_scrolling_down,
        ['<c-k>'] = actions.preview_scrolling_up,
        ['<c-v>'] = actions.file_vsplit,
        ['<c-t>'] = actions.file_tab,
      }
    }
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
    },
    live_grep_args = {
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt({
            postfix = ' -t'
          }),
        }
      }
    }
  }
}

-- extension
Telescope.load_extension('fzf')
Telescope.load_extension('hop')
Telescope.load_extension('live_grep_args')
