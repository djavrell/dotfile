local ls = require("luasnip")
local l = require("luasnip.extras").lambda
local pf = require("luasnip.extras.postfix").postfix

local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local desc_rec
desc_rec = function()
  return sn(nil, {
    c(1, {
      t(""),
      sn(nil, {
        t(", "),
        i(1),
        d(2, desc_rec, {}),
      }),
      sn(nil, { t(", ..."), i(1) })
    })
  })
end

ls.add_snippets("typescript", {
  pf(".desc", {
    l("[" .. l.POSTFIX_MATCH),
    d(1, desc_rec, {}),
    t("]"),
  }),
  s("desc", {
    t("const ["),
    i(1),
    d(2, desc_rec, {}),
    t("]")
  })
})
