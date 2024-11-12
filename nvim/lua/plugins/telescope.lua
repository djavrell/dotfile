return {
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  'nvim-telescope/telescope-hop.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'nvim-telescope/telescope-dap.nvim',
  'molecule-man/telescope-menufacture',
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('core.telescope.setup')
      require('core.telescope.mapping')
    end,
  },
}
