local nvim_lsp = require('lspconfig')
local lsp_conf = require('djavrell.lsp')

local lua_conf = {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT'
      },
      diagnostics = {
        globals = { "vim", "next", "pairs", "pcall", "type", "tostring", "ipairs", "table", "string" },
      },
      workspace = {
        library =  {
          vim.env.VIMRUNTIME,
        }
      },
      telemetry = {
        enable = false
      },
    }
  },
}

nvim_lsp.lua_ls.setup(lsp_conf.setup(lua_conf))
