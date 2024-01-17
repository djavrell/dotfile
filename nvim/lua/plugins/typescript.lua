return {
  'pmizio/typescript-tools.nvim',
  'ianks/vim-tsx',
  {
    'maxmellon/vim-jsx-pretty',
    config = function()
      vim.cmd [[
        let g:vim_jsx_pretty_template_tags = ['html', 'jsx', 'tsx']
      ]]
    end
  },
  -- 'leafgarland/typescript-vim',
  'davidosomething/format-ts-errors.nvim',
}
