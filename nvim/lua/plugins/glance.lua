return {
  'DNLHC/glance.nvim',
  config = function()
    vim.keymap.set('n', '<leader>gr', '<cmd>Glance resume<CR>', { silent = true, noremap = true })

    require('glance').setup({
      height = 40,
      zindex = 50,
      border = {
        enable = true,
      },
      detached = true,
      theme = {
        enable = true,
      },
      hooks = {
        before_open = function(results, open, jump, method)
          if #results == 1 then
            jump(results[1]) -- argument is optional
          else
            open(results) -- argument is optional
          end
        end,
      },
    })
  end,
}
