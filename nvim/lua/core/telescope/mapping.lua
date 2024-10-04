if not pcall(require, "telescope") then
  return
end

TelescopeArgs = TelescopArgs or {}

local Tmap = function(key, f, option)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeArgs[map_key] = option or {}

  local rhs = string.format("<cmd>lua R('core.telescope')['%s'](TelescopeArgs['%s'])<cr>", f, map_key)

  local opt = { silent = true, noremap = true }
  vim.keymap.set('n', key, rhs, opt)
end

Tmap('<leader>f', 'find_files')
Tmap('<leader>g', 'live_grep_args')
Tmap('<leader>G', 'grep_string')
Tmap('<leader>b', 'buffers')
Tmap('<space>r', 'resume')
Tmap('<space>d', 'commands')
Tmap('<space>sh', 'search_history')

return Tmap
