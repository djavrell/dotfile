local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("typescript", {
  s(
    "dol-error",
    fmt([[
      import { z } from 'zod';

      const schema = z.object({
        code: z.literal('[err_name]-error'),
      });

      export type [err_type_name]Error = z.infer<typeof schema>;

      function build(): [err_type_name]Error {
        return { code: '[err_name]-error' };
      }

      export const [err_type_name]Error = { build, schema };
    ]], {
      err_name = i(1),
      err_type_name = i(2)
    }, {
      delimiters = "[]",
      repeat_duplicates = true,
    })
  ),
  s("ret", fmt([[
    return {
      [kind]: [err],
    }
  ]], {
    kind = c(1, {
      t("success"),
      t("failure")
    }),
    err = i(2, "undefined"),
  }, {
    delimiters = "[]",
  }))
})
