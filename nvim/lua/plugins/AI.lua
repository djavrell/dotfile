return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
    config = function()
      require('avante_lib').load()
      require('avante').setup({
        provider = 'copilot',
        mode = 'agentic',
        providers = {
          copilot = {
            model = 'claude-sonnet-4',
            extra_request_body = {
              temperature = 0,
              max_tokens = 8192,
            },
            reasoning_mode = 'medium',
          },
        },
        behaviour = {
          auto_suggestions = false, -- Experimental stage
          auto_set_highlight_group = true,
          auto_set_keymaps = true,
          auto_apply_diff_after_generation = false,
          support_paste_from_clipboard = true,
          minimize_diff = true,
          -- enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
          -- enable_claude_text_editor_tool_mode = true, -- Whether to enable Claude Text Editor Tool Mode.
        },
        mappings = {
          --- @class AvanteConflictMappings
          diff = {
            ours = 'co',
            theirs = 'ct',
            all_theirs = 'ca',
            both = 'cb',
            cursor = 'cc',
            next = ']x',
            prev = '[x',
          },
          suggestion = {
            accept = '<M-l>',
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
          jump = {
            next = ']]',
            prev = '[[',
          },
          submit = {
            normal = '<CR>',
            insert = '<C-s>',
          },
          sidebar = {
            apply_all = 'A',
            apply_cursor = 'a',
            switch_windows = '<Tab>',
            reverse_switch_windows = '<S-Tab>',
          },
        },
        hints = { enabled = true },
        windows = {
          ---@type "right" | "left" | "top" | "bottom"
          position = 'right',
          wrap = true,
          width = 40,
          sidebar_header = {
            enabled = true,
            align = 'center',
            rounded = true,
          },
          input = {
            prefix = '> ',
          },
          edit = {
            border = 'rounded',
            start_insert = true,
          },
          ask = {
            floating = false,
            start_insert = true,
            border = 'rounded',
          },
        },
        highlights = {
          ---@type AvanteConflictHighlights
          diff = {
            current = 'DiffText',
            incoming = 'DiffAdd',
          },
        },
        --- @class AvanteConflictUserConfig
        diff = {
          autojump = true,
          ---@type string | fun(): any
          list_opener = 'copen',
        },
        file_selector = {
          provider = 'telescope',
        },
      })
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        copilot_node_command = vim.fn.expand('$FNM_DIR') .. '/node-versions/v20.19.0/installation/bin/node',
      })
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    after = { 'copilot.lua' },
    config = function()
      require('copilot_cmp').setup()
    end,
  },
}
