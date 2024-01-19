
return {
  'nvim-treesitter/playground',
  'RRethy/nvim-treesitter-textsubjects',
  'nvim-treesitter/nvim-treesitter-textobjects',
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        auto_install = true,
        modules = {},
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "cmake",
          "css",
          "html",
          "http",
          "json",
          "scala",
          "scss",
          "tsx",
          "vim",
          "yaml",
          "lua",
          "typescript",
          "scheme",
          "markdown",
          "markdown_inline",
        },
        sync_install = false,
        ignore_install = {},
        highlight = {
          enable = true,              -- false will disable the whole extension
          additional_vim_regex_highlighting = false,
        },
        playground = {
          enable = true,
          updatetime = 5,
          persist_queries = true,
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",

            -- This shows stuff like literal strings, commas, etc.
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
        context_commentstring = {},
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = {"BufWrite", "CursorHold"},
        },
        textsubjects = {
          enable = true,
          prev_selection = ',', -- (Optional) keymap to select the previous selection
          keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aco"] = "@comment.outer"
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>z"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>Z"] = "@parameter.inner",
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            peek_definition_code = {
              ["<leader>df"] = "@function.outer",
              ["<leader>dF"] = "@class.outer",
            },
          },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>v",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        }
      }

      -- local TSUtils = require('djavrell.treesitter')
      --[[ TSUtils.add_parser("sql", "https://github.com/derekstride/tree-sitter-sql") ]]
    end
  },
}
