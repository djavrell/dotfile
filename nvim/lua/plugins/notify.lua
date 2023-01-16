return {
  'rcarriga/nvim-notify',
  opts = {
    timeout = 2500,
  },
  config = function()
    vim.notify = require('notify')
  end
}
