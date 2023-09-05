local ts_utils_lsp = require('nvim-lsp-ts-utils')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local Tmap = require("djavrell.telescope.mapping")

local M = {}

local additionalSetup = setmetatable({
  tsserver = function(client, bufnr)
    ts_utils_lsp.setup({})
    ts_utils_lsp.setup_client(client)
    -- client.server_capabilities.document_formatting = false
  end
}, {
  __index = function()
    return function() end
  end
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.keymap.set(...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true, buffer=bufnr }

  Tmap('<leader>s', 'lsp_dynamic_workspace_symbols')

  buf_set_keymap('n', 'gd', '<cmd>Glance definitions<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>Glance implementations<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Glance references<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>Glance type_definitions<CR>', opts)

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>E', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>Q', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)

  additionalSetup[client.name](client, bufnr)
end

local config = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

function M.setup()
  return config
end

return M
