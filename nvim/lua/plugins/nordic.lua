return {
  'AlexvZyl/nordic.nvim',
  opts = {
    cursorline = {
      theme = 'light',
      blend = 1,
    },
    telescope = {
      style = 'flat'
    },
    override = {
      ['@keyword.coroutine'] = { link = 'Keyword' },
      ['@lsp.type.interface'] = { link = 'Type' }
    }
  }
}
