local lsp_conf = require('core.lsp')

local M = {}

local metals_config = require("metals").bare_config()

metals_config.settings = {
  showImplicitArguments = true,
  showImplicitConversionsAndClasses = true,
  showInferredType = true,
  autoImportBuild = "all",
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl"
  },
  verboseCompilation = false,
  testUserInterface = "Test Explorer",
  -- serverVersion = '0.11.12'
}

local setup = lsp_conf.setup()
metals_config.init_options.statusBarProvider = "off"
metals_config.capabilities = setup.capabilities
metals_config.on_attach = setup.on_attach

M.config = metals_config

return M
