return {
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        copilot_node_command = vim.fn.expand('$FNM_DIR') .. '/node-versions/v22.19.0/installation/bin/node',
      })
    end,
  },
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
    config = function()
      require('mcphub').setup({
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
        },
      })
    end,
  },
  {
    -- 'zbirenbaum/copilot-cmp',
    'jvune0/copilot-cmp',
    branch = 'deprication_fix',
    after = { 'copilot.lua' },
    config = function()
      require('copilot_cmp').setup()
    end,
  },
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    opts = {
      terminal = {
        split_width_percentage = 0.40,
        snacks_win_opts = {
          width = 0.40,
        },
      },
      diff_opts = {
        layout = 'horizontal',
      },
    },
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },
}
