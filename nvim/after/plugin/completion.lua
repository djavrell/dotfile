local cmp = require('cmp')
local lspkind = require('lspkind')

local U = require('core.utils.ui')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c', 'n' }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c', 'n' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'copilot', group_index = 2 },
    { name = 'lazydev', group_index = 0 },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'git' },
    { name = 'emoji' },
  }),
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    expandable_indicator = true,
    format = lspkind.cmp_format({
      maxwidth = 50,
      mode = 'symbol',
      symbol_map = U.kind_icons,
    }),
  },
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'buffer' },
  }),
  view = {
    entries = { name = 'custom' },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'cmdline' },
    { name = 'path' },
  }),
  view = {
    entries = { name = 'custom' },
  },
})

cmp.setup.filetype('prompt', {
  sources = cmp.config.sources({
    { name = 'dap' },
  }),
  view = {
    entries = 'native',
  },
})

cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
  sources = {
    { name = 'vim-dadbod-completion' },
  },
})

cmp.setup.filetype({ 'zsh' }, {
  sources = {
    { name = 'zsh' },
  },
})
