local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local r = ls.restore_node

ls.add_snippets("typescript", {
  s("imp", {
    t("import "),
    c(2, {
      i(1, "*"),
      sn(nil, {
        t("{ "),
        r(1, "imp_list"),
        t(" }")
      }),
      sn(nil, {
        t("type { "),
        r(1, "imp_list"),
        t(" }")
      })
    }),
    t(" from '"),
    i(1),
    t("';")
  }, {
    ["imp_list"] = i(1)
  })
})
