local nvim_lsp = require('lspconfig')
local cmp = require('cmp')
local lspkind = require('lspkind')

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local augroups = require('djavrell.augroups.utils')
local lsp_conf = require('djavrell.lsp')

local U = require("djavrell.utils.ui")

local kind_names = {
  nvim_lsp = "[LSP]",
  path = "[Path]",
  calc = "[Calc]",
  luasnip = "[Snippet]",
  buffer = "[Buffer]",
  ['vim-dadbod-completion'] = "[DB]",
}

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'path' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      menu = kind_names,
      maxwidth = 50,
      symbol_map = U.kind_icons,
    })
  },
  view = {
    entries = 'native'
  },
  experimental = {}
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'buffer' }
  }),
  view = {
    entries = { name = 'custom' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'cmdline' },
    { name = 'path' }
  }),
  view = {
    entries = { name = 'custom' }
  }
})

cmp.setup.filetype('prompt', {
  sources = cmp.config.sources({
    { name = 'dap' }
  }),
  view = {
    entries = 'native'
  },
})

local servers = {
  'tsserver',
  'bashls',
  'clangd',
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup(lsp_conf.setup())
end

nvim_lsp.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

_ = vim.cmd [[
  augroup DadbodSql
    au!
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
  augroup END
]]

_ = vim.cmd [[
  augroup CmpZsh
    au!
    autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
  augroup END
]]

-- _ = vim.cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach({})]])

local null_ls = require("null-ls")
require("null-ls").setup {
  source = {
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.tsc,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.prettier
  }
}

----------------------------------
-- Metals ------------------------
----------------------------------

local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  showImplicitConversionsAndClasses = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

metals_config.capabilities = capabilities

-- Autocmd that will actually be in charging of starting the whole thing
-- local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = augroups["nvim-metals"],
})
