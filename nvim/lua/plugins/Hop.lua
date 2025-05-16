local mapOpt = { silent = true, noremap = true }

return {
  'smoka7/hop.nvim',
  keys = {
    { 'f', '<cmd>HopWordAC<CR>', '', mapOpt },
    -- { 'f', '<cmd>HopChar1CurrentLineAC<CR>', 'o', mapOpt },
    { 't', '<cmd>HopChar1CurrentLineAC<CR>', 'o', mapOpt },

    { 'F', '<cmd>HopWordBC<CR>', '', mapOpt },
    { 'T', '<cmd>HopChar1CurrentLineBC<CR>', 'o', mapOpt },

    { '<leader>k', '<cmd>HopLineBC<CR>', 'n', mapOpt },
    { '<leader>j', '<cmd>HopLineAC<CR>', 'n', mapOpt },
  },
  config = function()
    require('hop').setup({ keys = 'etovxqpdygfblzhckisuran' })
  end,
}
