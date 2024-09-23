local ls = require("luasnip")

local u = require('djavrell.utils.snipet')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local f = ls.function_node

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
  }),
  s(
    "zodType",
    fmt(
      [[
        [exp]const [name] = z.[kind]([txt]);
        [exp]type [Name] = z.infer<typeof [name]>;
      ]],
      {
        exp = c(1, {
          t("export "),
          t("")
        }),
        name = i(2),
        kind = c(3, {
          t("object"),
          t("array"),
          t("enum"),
          r(1, "kind_choice")
        }),
        txt = i(4),
        Name = f(u.capitalize, {2}),
      },
      {
        delimiters = "[]",
        repeat_duplicates = true,
      }
      ),
      {
        ["kind_choice"] = i(1)
      }
  )
})
