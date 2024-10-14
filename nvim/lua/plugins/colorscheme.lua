return {
  {
    'AlexvZyl/nordic.nvim',
    opts = function()
      local C = require 'nordic.colors'
      return {
        bold_keywords = true,
        italic_comments = true,
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
        ---@diagnostic disable-next-line: unused-local
        on_highlight = function(highlights, palette)
          highlights.FloatBorder = {
            fg = C.fg_sidebar,
            bg = C.bg
          }
          highlights.LazyNormal = {
            bg = C.bg,
          }
          highlights['@keyword.coroutine'] = { link = 'Keyword' }
          highlights['@lsp.type.interface'] = { link = 'Type' }
        end
      }
    end
  },
}
