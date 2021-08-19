-- install packer automatically if needed
if require("djavrell.first_load")() then
  return
end

vim.g.mapleader = '='

require("djavrell.global")
require("djavrell.plugins")
require("djavrell.options")
