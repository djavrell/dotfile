local log = require("djavrell.utils.logger")
local M = {}

M.chrome = function(ac)
  return {
    adapter = {
      type = 'executable',
      command = 'node',
      args = { ac.folder .. ac.bin },
    },
    configuration_key = "typescript",
    configuration = {
      {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require'dap.utils'.pick_process,
      },
    }
  }
end

M.nlua = function(ac)
  return {
    adapter = function(callback, config)
      callback { type = "server", host = config.host, port = config.port }
    end,
    configuration_key = "lua",
    configuration = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
        host = function()
          return "127.0.0.1"
        end,
        port = function()
          -- local val = tonumber(vim.fn.input('Port: '))
          -- assert(val, "Please provide a port number")
          local val = 54231
          return val
        end,
      },
    }
  }
end

return setmetatable({}, {
  __index = function(_, k)
    if not M[k] then
      log.warn("dap.adapter.configuration", string.format("cannot find configuration for %s adapter", k))
      return function() end
    else
      return M[k]
    end
  end
})
