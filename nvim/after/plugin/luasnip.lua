local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.setup({
  history = true,
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<-" } },
      },
    },
  },
})

-- <c-k> is my expansion key
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <c-j> is my jump backwards key.
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
vim.keymap.set("i", "<c-s>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node
local sn = ls.snippet_node

ls.add_snippets("typescript", {
  s("trn", {
    i(1), t(" ? "), i(2), t(" : "), i(0)
  }),
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
  })
})
