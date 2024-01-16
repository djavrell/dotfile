local nvim_lsp = require('lspconfig')
local lsp_conf = require('djavrell.lsp')

local common = {
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
      telemetry = { enable = false },
      hint = { enable = true }
    }
}

---@diagnostic disable-next-line: missing-fields
nvim_lsp.lua_ls.setup(lsp_conf.setup({
  ---@param client lsp.Client
  on_init = function(client)
    local path = client.workspace_folders[1].name
    local has_luarc = vim.uv.fs_stat(path .. '/.luarc.json') ~= nil and vim.uv.fs_stat(path .. '/.luarc.jsonc') ~= nil

    if has_luarc == true then
      return true
    end

    client.config.settings = vim.tbl_deep_extend('force', client.config.settings, common)
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
}))
