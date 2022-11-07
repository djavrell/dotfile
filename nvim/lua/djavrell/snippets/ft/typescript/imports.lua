local ls = require("luasnip")
local l = require("luasnip.extras").lambda

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node

ls.add_snippets("typescript", {
  s("imp", {
    t("import "),
    c(2, {
      i(1, "*"),
      sn(nil, {
        t("{ "),
        i(1),
        t(" }")
      }),
      sn(nil, {
        t("type { "),
        i(1),
        t(" }")
      })
    }),
    t(" from '"),
    i(1),
    t("';")
  })
})
