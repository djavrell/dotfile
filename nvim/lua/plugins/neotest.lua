-- neotest types setup() with the full neotest.Config, though it merges partial tables into its defaults.
---@diagnostic disable: missing-fields
local jest_configs = { 'jest.config.ts', 'jest.config.js', 'jest.config.cjs', 'jest.config.mjs' }
local integration_configs = { 'jest.integration.config.ts', 'jest.integration.config.js', 'jest.integration.config.cjs' }
local playwright_configs = { 'playwright.config.ts', 'playwright.config.js' }

-- Nearest file named one of `names`, walking up from `path`.
local function find_up(path, names)
  for dir in vim.fs.parents(path) do
    for _, name in ipairs(names) do
      local file = dir .. '/' .. name
      if vim.uv.fs_stat(file) then
        return file
      end
    end
  end
end

-- *.integration.spec.ts run under their package's jest.integration.config (Dolmen web/api), the rest under jest.config.
local function jest_config(path)
  local integration = path:match('%.integration%.spec%.[jt]sx?$') and find_up(path, integration_configs)
  return integration or find_up(path, jest_configs)
end

local function run(fn)
  return function()
    fn(require('neotest'))
  end
end

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-jest',
    'thenbe/neotest-playwright',
  },
  cmd = 'Neotest',
  keys = {
    { '<leader>tt', run(function(neotest) neotest.run.run() end), desc = '[Test] nearest' },
    { '<leader>tf', run(function(neotest) neotest.run.run(vim.fn.expand('%')) end), desc = '[Test] file' },
    { '<leader>tl', run(function(neotest) neotest.run.run_last() end), desc = '[Test] last' },
    { '<leader>td', run(function(neotest) neotest.run.run({ strategy = 'dap' }) end), desc = '[Test] debug nearest' },
    { '<leader>tx', run(function(neotest) neotest.run.stop() end), desc = '[Test] stop' },
    { '<leader>tw', run(function(neotest) neotest.watch.toggle(vim.fn.expand('%')) end), desc = '[Test] watch file' },
    { '<leader>ts', run(function(neotest) neotest.summary.toggle() end), desc = '[Test] summary' },
    { '<leader>to', run(function(neotest) neotest.output.open({ enter = true, auto_close = true }) end), desc = '[Test] output' },
    { '<leader>tO', run(function(neotest) neotest.output_panel.toggle() end), desc = '[Test] output panel' },
    { '<leader>ta', run(function(neotest) neotest.playwright.attachment() end), desc = '[Test] playwright attachment' },
    { '<leader>tn', run(function(neotest) neotest.jump.next({ status = 'failed' }) end), desc = '[Test] next failed' },
    { '<leader>tp', run(function(neotest) neotest.jump.prev({ status = 'failed' }) end), desc = '[Test] prev failed' },
  },
  config = function()
    local jest_util = require('neotest-jest.jest-util')

    require('neotest').setup({
      adapters = {
        require('neotest-jest')({
          -- Monorepo: run jest from the package that owns the test, not from the git root.
          cwd = function(path)
            local config = jest_config(path)
            return config and vim.fs.dirname(config) or vim.fn.getcwd()
          end,
          jestConfigFile = function(path)
            return jest_config(path) or 'jest.config.ts'
          end,
          -- ts-jest in ESM mode needs node's vm modules, as the npm scripts do.
          jestCommand = function(path)
            local jest = find_up(path, { 'node_modules/jest/bin/jest.js' })
            return jest and ('node --experimental-vm-modules ' .. jest) or 'npx jest'
          end,
          env = { NODE_ENV = 'test' },
          -- Both runners use *.spec.ts: a file under a playwright.config belongs to playwright.
          isTestFile = function(path)
            return jest_util.defaultIsTestFile(path) and vim.fs.root(path, playwright_configs) == nil
          end,
        }),
        require('neotest-playwright').adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
        }),
      },
      summary = {
        -- Default is a fixed 50 columns; 40% of the screen, computed on each open.
        open = function()
          vim.cmd('botright vsplit | vertical resize ' .. math.floor(vim.o.columns * 0.4))
          return vim.api.nvim_get_current_win()
        end,
      },
      consumers = {
        playwright = require('neotest-playwright.consumers').consumers,
      },
    })
  end,
}
