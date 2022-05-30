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
  },
  nlua = "enable"
}

local has_one = false
for adapter, conf in pairs(adapters_bin) do
  local has_dir = type(conf) == "table" and vim.fn.isdirectory(conf.folder)
  local test = type(conf) == "string" and conf == "enable"
  log.info("dap", string.format("loading %s", adapter))
  log.info("dap", string.format("%s or %s => %s", has_dir, test, has_dir or test))
  if has_dir or test then

    local c = configs[adapter](conf)
    if c then
      dap.adapters[adapter] = c.adapter
      dap.configurations[c.configuration_key or adapter] = c.configuration
    end

    mappings[adapter]()

    has_one = true
  end
end

if has_one then
  mappings.global()
end
