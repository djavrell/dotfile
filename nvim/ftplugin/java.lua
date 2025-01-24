---@diagnostic disable: missing-fields
local lsp_config = require('core.lsp')

require('jdtls').start_or_attach(lsp_config.setup({
  cmd = { os.getenv('XDG_BIN_HOME') .. '/java/bin/jdtls' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]) or '',
}))
