require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "lua",
    "tsx",
    "typescript",
    "javascript",
    "css",
    "html",
    "scala",
    "yaml",
    "json",
    "query"
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
}
