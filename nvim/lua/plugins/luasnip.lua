
return {
  'L3MON4D3/LuaSnip',
  config = function()
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

    -- my expansion key
    vim.keymap.set({ "i", "s" }, "<c-k>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { silent = true })

    -- jump backwards key.
    vim.keymap.set({ "i", "s" }, "<c-j>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })

    -- selecting within a list of options.
    vim.keymap.set({ "i", "s" }, "<c-s>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end)

    for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('lua/core/snippets/ft/**/*.lua', true)) do
      loadfile(ft_path)()
    end
  end
}
