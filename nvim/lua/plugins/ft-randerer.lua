return {
  {
    'OXY2DEV/markview.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    lazy = false,
    config = function()
      require('markview').setup({
        preview = {
          enable = true,
          filetypes = { 'markdown', 'Avante' },
          ignore_buftypes = { 'nofile' },
        },
        markdown = {
          enable = true,
        },
        experimental = { check_rtp_message = false },
      })

      require('markview.extras.checkboxes').setup({
        --- Default checkbox state(used when adding checkboxes).
        ---@type string
        default = 'X',

        --- Changes how checkboxes are removed.
        ---@type
        ---| "disable" Disables the checkbox.
        ---| "checkbox" Removes the checkbox.
        ---| "list_item" Removes the list item markers too.
        remove_style = 'disable',

        --- Various checkbox states.
        ---
        --- States are in sets to quickly change between them
        --- when there are a lot of states.
        ---@type string[][]
        states = {
          { ' ', '/', 'X' },
          { '<', '>' },
          { '?', '!', '*' },
          { '"' },
          { 'l', 'b', 'i' },
          { 'S', 'I' },
          { 'p', 'c' },
          { 'f', 'k', 'w' },
          { 'u', 'd' },
        },
      })
      require('markview.extras.headings').setup()
      require('markview.extras.editor').setup()
    end,
  },
  {
    'OXY2DEV/helpview.nvim',
    ft = 'help',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'hat0uma/csvview.nvim',
    config = function()
      require('csvview').setup({
        delimiter = {
          default = ';',
        },
        view = {
          display_mode = 'border',
        },
      })
    end,
  },
}
