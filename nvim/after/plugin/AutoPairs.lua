local has_nvim_autopairs, nvim_autopairs = pcall(require, 'nvim-autopairs')
if not has_nvim_autopairs then
  return
end

nvim_autopairs.setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')

local has_cmp, cmp = pcall(require, 'cmp')
if not has_cmp then
  return
end
-- If you want insert `(` after select function or method item
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done())
