return {
  'AlexvZyl/nordic.nvim',
  opts = function()
    local C = require 'nordic.colors'
    return {
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
        ['@lsp.type.interface'] = { link = 'Type' },
        FloatBorder = {
          fg = C.fg_sidebar,
          bg = C.bg
        },
        LazyNormal = {
          bg = C.bg,
        },
      }
    }
  end
}
