local config = require('djavrell.lsp').setup()

config.cmd = { os.getenv('XDG_BIN_HOME') .. '/java/bin/jdtls'}
config.root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),

require('jdtls').start_or_attach(config)
