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
        let query = "
        \SELECT\n
        \  conrelid::regclass AS table_from,\n
        \  conname,\n
        \  pg_get_constraintdef(oid)\n
        \FROM pg_constraint\n
        \WHERE contype IN ('f', 'p')\n
        \  AND conrelid = '{table}'::regclass\n
        \  AND connamespace = 'public'::regnamespace\n
        \ORDER\n
        \  BY conrelid::regclass::text,\n
        \  contype DESC;\n
        \"

        let g:db_ui_table_helpers = {
        \   'postgresql': {
        \     'Constraints': query
        \   }
        \ }
      ]]
    end
  },
  'kristijanhusak/vim-dadbod-completion',
}
