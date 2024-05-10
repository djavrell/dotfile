local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local r = ls.restore_node
local c = ls.choice_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("typescript", {
  s("dol-error", fmt([[
      import { z } from 'zod';

      const CODE = '[err_name]-error' as const;

      const schema = z.object({
        code: z.literal(CODE),
      });

      export type [err_type_name]Error = z.infer<typeof schema>;

      function build(): [err_type_name]Error {
        return { code: CODE };
      }

      export const [err_type_name]Error = { CODE, build, schema };
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
  })),
  s(
    "schema",
    fmt(
      [[
        import { z } from 'zod';

        const [name] = z.object([content]);

        export type [type] = z.infer<typeof [name]>;

        export const [type] = { [name] };
      ]],
      {
        type = i(1),
        name = i(2, "schema"),
        -- content = i(3),
        content = c(3, {
          sn(nil, {
            t("object({"),
            r(1, "obj_content"),
            t("})")
          }),
          sn(nil, {
            t("array(["),
            r(1, "arr_content"),
            t("])")
          }),
          sn(nil, {
            t("array("),
            r(1, "arr_content_empty"),
            t(")")
          }),
        }),

      },
      {
        delimiters = "[]",
        repeat_duplicates = true,
      }
    ),
    {
      ["obj_content"] = i(1),
      ["arr_content"] = i(1),
      ["arr_content_empty"] = i(1)
    }
  )
})
