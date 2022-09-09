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

local l = require("luasnip.extras").lambda
local pf = require("luasnip.extras.postfix").postfix

local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node


--[[ local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end

ls.add_snippets("typescript", {
	-- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
	-- \item as necessary by utilizing a choiceNode.
	s("ls", {
		t({ "\\begin{itemize}", "\t\\item " }),
		i(1),
		d(2, rec_ls, {}),
		t({ "", "\\end{itemize}" }),
	}),
}) ]]

local desc_rec
desc_rec = function()
  return sn(
    nil,
    c(1, {
      t(""),
      sn(nil, { t(", "), i(1) }),
      sn(nil, { t(", ..."), i(1, "rest") }),
      sn(nil, {
        t(", "),
        d(1, desc_rec, {})
      }),
    })
  )
end

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
  pf(".desc", {
    l("[" .. l.POSTFIX_MATCH),
    d(1, desc_rec, {}),
    t("]"),
  }),
  s("desc", {
    t("const [")
  })
})
