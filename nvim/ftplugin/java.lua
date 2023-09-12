local jdtls = require('jdtls')

local lsp_config = require('djavrell.lsp')

jdtls.start_or_attach(lsp_config({
  cmd = { os.getenv('XDG_BIN_HOME') .. '/java/bin/jdtls'},
  root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1])
}))
