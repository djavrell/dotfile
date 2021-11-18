require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true,              -- false will disable the whole extension
    use_languagetree = false,
    additional_vim_regex_highlighting = false,
  },
  playground = {
    enable = true,
    updatetime = 25,
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
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.http = {
  install_info = {
    url = "https://github.com/NTBBloodbath/tree-sitter-http", -- local path or git repo
    files = {"src/parser.c"},
    branch = "main",
    generate_requires_npm = true,
  },
  filetype = "httpResponse", -- if filetype does not agrees with parser name
  maintainers = { "@NTBBloodbath" }
}
