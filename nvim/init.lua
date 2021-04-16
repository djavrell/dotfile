-- install packer automatically if needed
if require("djavrell.first_load")() then
  return
end

-- some opt helpers
require("djavrell.global")

vim.g.mapleader = '='

require("djavrell.plugins")
require("djavrell.options")
