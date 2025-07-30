return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'pnx/lualine-lsp-status',
    },
    config = function()
      local C = require('nordic.colors')
      require('lualine').setup({
        options = {
          theme = 'nordic',
        },
        extensions = { 'neo-tree', 'man', 'nvim-dap-ui' },
        sections = {
          lualine_b = { 'branch', 'diagnostics' },
          lualine_x = {
            {
              function()
                -- Check if MCPHub is loaded
                if not vim.g.loaded_mcphub then
                  return '󰐻 -'
                end

                local count = vim.g.mcphub_servers_count or 0
                local status = vim.g.mcphub_status or 'stopped'
                local executing = vim.g.mcphub_executing

                -- Show "-" when stopped
                if status == 'stopped' then
                  return '󰐻 -'
                end

                -- Show spinner when executing, starting, or restarting
                if executing or status == 'starting' or status == 'restarting' then
                  local frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
                  local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                  return '󰐻 ' .. frames[frame]
                end

                return '󰐻 ' .. count
              end,
              color = function()
                if not vim.g.loaded_mcphub then
                  return { fg = C.grey5 } -- Gray for not loaded
                end

                local status = vim.g.mcphub_status or 'stopped'
                if status == 'ready' or status == 'restarted' then
                  return { fg = C.green.bright } -- Green for connected
                elseif status == 'starting' or status == 'restarting' then
                  return { fg = C.yellow.bright } -- Orange for connecting
                else
                  return { fg = C.red.bright } -- Red for error/stopped
                end
              end,
            },
            'lsp-status',
            'filetype',
          },
        },
      })
    end,
  },
}
