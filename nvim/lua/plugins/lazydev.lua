return {
  {
    'folke/lazydev.nvim',
    dependencies = {
      'justinsgithub/wezterm-types',
    },
    ft = 'lua',
    config = function()
      -- Monkeypatch in a PR to remove a call to the deprecated `client.notify`
      -- function.
      --
      -- See: https://github.com/folke/lazydev.nvim/pull/106
      local config = require('lazydev.config')
      config.have_0_11 = vim.fn.has('nvim-0.11') == 1

      local lsp = require('lazydev.lsp')
      lsp.update = function(client)
        lsp.assert(client)
        if config.have_0_11 then
          client:notify('workspace/didChangeConfiguration', {
            settings = { Lua = {} },
          })
        else
          client.notify('workspace/didChangeConfiguration', {
            settings = { Lua = {} },
          })
        end
      end

      require('lazydev').setup({
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          'lazy.nvim',
          { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          { path = 'LazyVim', words = { 'LazyVim' } },
          { path = 'wezterm-types', mods = { 'wezterm' } },
        },
      })
    end,
    --[[ opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        'lazy.nvim',
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'LazyVim', words = { 'LazyVim' } },
        { path = 'wezterm-types', mods = { 'wezterm' } },
      },
    }, ]]
  },
  { 'Bilal2453/luvit-meta', lazy = true },
}
