local ls = require('luasnip')

local u = require('core.utils.snipet')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local r = ls.restore_node
local fmt = require('luasnip.extras.fmt').fmt
local f = ls.function_node

ls.add_snippets('markdown', {
  s(
    'codeblock',
    fmt(
      [[
    ```[lang]
    [code]
    ```
    ]],
      {
        lang = i(1, 'sql'),
        code = i(2),
      },
      {
        delimiters = '[]',
      }
    )
  ),
  s(
    'note',
    fmt(
      [[
    > [!NOTE]
    > {text}
    ]],
      {
        text = i(1),
      }
    )
  ),
})
