return {
  'ianks/vim-tsx',
  {
    'maxmellon/vim-jsx-pretty',
    config = function()
      vim.cmd([[
        let g:vim_jsx_pretty_template_tags = ['html', 'jsx', 'tsx']
      ]])
    end,
  },
  -- 'leafgarland/typescript-vim',
  'davidosomething/format-ts-errors.nvim',
  {
    'dmmulroy/ts-error-translator.nvim',
    config = function()
      require('ts-error-translator').setup()
    end,
  },
}
