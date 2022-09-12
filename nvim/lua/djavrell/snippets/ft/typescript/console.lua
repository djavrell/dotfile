local ls = require("luasnip")
local l = require("luasnip.extras").lambda
local pf = require("luasnip.extras.postfix").postfix

local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node
local sn = ls.snippet_node

ls.add_snippets("typescript", {
  s("cl", {
    t("console.log("),
    c(1, {
      i(1),
      sn(nil, {
        t("JSON.stringify("),
        i(1),
        t(", null, 2)")
      })
    }),
    t(")")
  }),
})
