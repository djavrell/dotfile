return {
  {
    'tpope/vim-dadbod',
    config = function()
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_auto_execute_table_helpers = 1
    end
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    config = function()
      vim.cmd[[
        let g:db_ui_table_helpers = {
        \   'postgresql': {
        \     'Constraints': "SELECT conrelid::regclass AS table_from, conname, pg_get_constraintdef(oid) FROM  pg_constraint WHERE contype IN ('f', 'p') AND conrelid = '{table}'::regclass AND connamespace = 'public'::regnamespace ORDER BY conrelid::regclass::text, contype DESC;"
        \   }
        \ }
      ]]
    end
  },
  'kristijanhusak/vim-dadbod-completion',
}
