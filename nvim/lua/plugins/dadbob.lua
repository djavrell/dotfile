return {
  {
    'tpope/vim-dadbod',
    config = function()
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_auto_execute_table_helpers = 1
    end,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    config = function()
      vim.cmd([[
        let g:db_ui_table_helpers = {
        \   'postgresql': {
        \     'Describe': '\d {table}'
        \   }
        \ }
      ]])
    end,
  },
  'kristijanhusak/vim-dadbod-completion',
}
