return {
  'AlexvZyl/nordic.nvim',
  opts = {
    bold_keywords = true,
    reduced_blue = true,
    cursorline = {
      theme = 'light',
      blend = 1,
    },
    telescope = {
      style = 'flat'
    },
    ts_context = {
      dark_background = true,
    },
    override = {
      ['@keyword.coroutine'] = { link = 'Keyword' },
      ['@lsp.type.interface'] = { link = 'Type' }
    }
  }
}
