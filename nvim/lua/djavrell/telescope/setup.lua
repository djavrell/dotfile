local Telescope = require('telescope')
local actions = require('telescope.actions')
local actions_layout = require('telescope.actions.layout')

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
    hop = {},
    ['ui-select'] = {
      require("telescope.themes").get_cursor {}
    }
  }
}

-- extension
Telescope.load_extension('fzf')
Telescope.load_extension('hop')
Telescope.load_extension('ui-select')

-- hydra submode

local Hydra = require('hydra')

local function l(command)
  return string.format("<cmd>lua R('djavrell.telescope')['%s']()<cr>", command)
end


local hint = [[
                 _f_: files       ^
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    ^                _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _b_: buffers     _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _h_: vim help    _c_: execute command
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  ^                _;_: commands history
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _r_: registers   _?_: search history

                 _<Enter>_: Telescope           _<Esc>_
]]

Hydra({
   name = 'Telescope',
   hint = hint,
   config = {
      color = 'teal',
      invoke_on_body = true,
      hint = {
         position = 'middle',
         border = 'rounded',
      },
   },
   mode = 'n',
   body = '<Leader>t',
   heads = {
      { 'f', l 'find_files' },
      { 'g', l 'live_grep' },
      { 'h', l 'help_tags', { desc = 'Vim help' } },
      { 'k', l 'keymaps' },
      { 'r', l 'registers' },
      { 'b', l 'buffers' },
      { '/', l 'current_buffer_fuzzy_find', { desc = 'Search in file' } },
      { '?', l 'search_history',  { desc = 'Search history' } },
      { ';', l 'command_history', { desc = 'Command-line history' } },
      { 'c', l 'commands', { desc = 'Execute command' } },
      { '<Enter>', l 'Telescope', { exit = true, desc = 'List all pickers' } },
      { '<Esc>', nil, { exit = true, nowait = true } },
   }
})
