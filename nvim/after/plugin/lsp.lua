local has_lsp, lspconfig = pcall(require, 'lspconfig')
local _, lsp_utils = pcall(require, 'lspconfig.util')

if not has_lsp then
  return
end

local lsp_statut = require('lsp-status')
require('vim.lsp.log').set_level('debug')
require('lspkind').init()
require('lspsaga').init_lsp_saga()

local opt = {noremap = true, silent = true}

local map = function(mode, key, cmd)
  vim.api.nvim_set_keymap(mode, key, "<cmd>lua " .. cmd .. "<CR>", opt)
end
local nmap = function(...) map('n', ...) end
local vmap = function(...) map('v', ...) end

local custom_init = function(client)
  config.client.flags = client.config.client.flags or {}
  config.client.flags.allow_incremental_sync = true
end

local custom_attach = function(client)
  local lsp = function(name) return 'vim.lsp.buf.' .. name .. '()' end
  local saga = function(module, name)
    return "require('lspsaga." .. module .."')." .. name .. "()"
  end

  lsp_statut.on_attach(client)

  nmap('gd', lsp('definition'))
  nmap('gi', lsp('implementation'))
  nmap('gD', lsp('declaration'))
  nmap('gh', saga('provider', 'lsp_finder'))
  nmap('gr', lsp('references'))
  nmap('K', lsp('hover'))
  nmap('<C-k>', lsp('signature_help'))
  nmap('<space>d', lsp('type_definition'))
  nmap('<leader>rn', saga('rename', 'rename'))

  if client.resolved_capabilities.document_formatting then
    nmap('<space>f', 'formatting')
  end
  if client.resolved_capabilities.document_range_formatting then
    vmap('<space>f', 'range_formatting')
  end

  nmap('<leader>ca', saga('codeaction', 'code_action'))
  vim.api.nvim_set_keymap(
    'v',
    '<leader>ca',
    ':<C-U>lua ' .. saga('codeaction', 'range_code_action') .. '<CR>',
    opt
  )

  nmap('<C-f>', "require('lspsaga.action').smart_scroll_with_saga(1)")
  nmap('<C-b>', "require('lspsaga.action').smart_scroll_with_saga(-1)")

end

lspconfig.tsserver.setup {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = lsp_statut.capabilities,
  cmd = { 'typescript-language-server', '--stdio' },
  filetype = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  }
}
