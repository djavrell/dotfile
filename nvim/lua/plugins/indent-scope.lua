return {
  {
    'nvimdev/indentmini.nvim',
    config = function()
      require('indentmini').setup({
        only_curent = true,
        minlevel = 2,
        exclude = {
          'help',
          'javascript',
          'typescript',
          'typescript.tsx',
          'sh',
          'lua',
          'json',
          'sql',
        },
      })
    end,
  },
}
