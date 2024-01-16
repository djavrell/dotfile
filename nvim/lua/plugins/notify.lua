return {
  'rcarriga/nvim-notify',
  opts = {
    timeout = 2500,
    render = "compact"
  },
  config = function()
    vim.notify = require('notify')
  end
}
