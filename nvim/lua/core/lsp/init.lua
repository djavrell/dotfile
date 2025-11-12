local lsp_signature = require('lsp_signature')
local ts_utils_lsp = require('nvim-lsp-ts-utils')

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local U = require('core.utils.ui')

local M = {}

local function buf_set_keymap(...)
  vim.keymap.set(...)
end

local additionalSetup = setmetatable({
  ['typescipt-tools'] = function(client, bufnr)
    ts_utils_lsp.setup({})
    ts_utils_lsp.setup_client(client)

    require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
  end,
  ts_ls = function(client, bufnr)
    ts_utils_lsp.setup({})
    ts_utils_lsp.setup_client(client)

    require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
  end,
  vtsls = function(client, bufnr)
    ts_utils_lsp.setup({})
    ts_utils_lsp.setup_client(client)

    require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
  end,
}, {
  __index = function()
    return function() end
  end,
})

local on_attach = function(client, bufnr)
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {
    buf = bufnr,
  })

  local opts = { noremap = true, silent = true, buffer = bufnr }

  buf_set_keymap('n', 'gd', '<cmd>Glance definitions<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>Glance implementations<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Glance references<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>Glance type_definitions<CR>', opts)

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>E', function()
    vim.diagnostic.jump({
      count = -1,
    })
  end, opts)
  buf_set_keymap('n', '<leader>e', function()
    vim.diagnostic.jump({
      count = 1,
    })
  end, opts)
  buf_set_keymap('n', '<space>Q', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)

  vim.api.nvim_create_user_command('Format', vim.lsp.buf.format, {})
  vim.api.nvim_create_user_command('ResetDiagnostic', function()
    vim.diagnostic.reset()
  end, {})

  lsp_signature.on_attach({
    max_height = 100,
    max_width = 200,
    wrap = true,
    timer_interval = 50,
    floating_window = false,
    hint_enable = false,
    hint_prefix = '',
    handler_opt = {
      border = U.border_chars_outer_thin,
    },
    toggle_key = '<M-x>',
    toggle_key_flip_floatwin_setting = false,
    select_signature_key = '<M-n>',
  }, bufnr)

  additionalSetup[client.name](client, bufnr)
end

M.on_attach = on_attach
M.capabilities = capabilities

local config = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

-- ---@param opt vim.lsp.ClientConfig|nil
---@return vim.lsp.ClientConfig
function M.setup(opt)
  return vim.tbl_extend('force', config, opt or {})
end

return M
