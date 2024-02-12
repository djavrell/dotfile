local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local r = ls.restore_node

ls.add_snippets("typescript", {
  s("zodDef", {
    t("const "),
    r(1, "obj_name"),
    t(" = z."),
    c(2, {
      sn(nil, {
        r(1, "zod_type"),
        t("object({"),
        i(2),
        t("});")
      }),
      sn(nil, {
        r(1, "zod_type"),
        t("({"),
        i(2),
        t("});")
      })
    }),
  }, {
    ["obj_name"] = i(1),
    ["zod_type"] = i(1)
  }),
  s("infer", {
    t("z."),
    c(1, {
      sn(nil, {
        t("infer<typeof "),
        r(1, "schema"),
        t(">;")
      }),
      r(1, "type")
    })
  }, {
    ["schema"] = i(1),
    ["type"] = i(1)
  })
})
