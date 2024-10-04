local ls = require("luasnip")
local l = require("luasnip.extras").lambda
local pf = require("luasnip.extras.postfix").postfix

local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node
local sn = ls.snippet_node
local r = ls.restore_node

ls.add_snippets("typescript", {
  pf("log", l("console.log(" .. l.POSTFIX_MATCH .. ")")),
  s("cl", {
    t("console.log("),
    c(1, {
      r(1, "log_txt"),
      sn(nil, {
        t("JSON.stringify("),
        r(1, "log_txt"),
        t(", null, 2)")
      })
    }),
    t(")")
  }, {
    ["log_txt"] = i(1)
  }),
})
