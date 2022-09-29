local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("typescript", {
  s("import", {
    t("import {"),
    i(2),
    t("} from '"),
    i(1),
    t("';")
  })
})
