local ok, dap = pcall(require, "dap")
if not ok then
  return false
end

local dap = require("dap")
local log = require("djavrell.utils.logger")
local mappings = require("djavrell.dap.mappings")
local configs = require("djavrell.dap.configurations")

local home = os.getenv("HOME")

local adapters_bin = {
  chrome = {
    folder = home .. "/bin/vscode-chrome-debug/out/src/",
    bin = "chromeDebug.js",
  },
  node2 = {
    folder = home .. "/bin/vscode-node-debug2/out/src/",
    bin = "nodeDebug.js"
  }
}

local has_one = false
for adapter, conf in pairs(adapters_bin) do
  if  vim.fn.isdirectory(conf.folder) then

    local c = configs[adapter](conf)
    dap.adapters[adapter] = c.adapter
    dap.configurations[c.configuration_key or adapter] = c.configuration

    mappings[adapter]()

    has_one = true
  end
end

if has_one then
  mappings.global()
end
