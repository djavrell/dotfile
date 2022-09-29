local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

local M = {}

function M.add_parser(ft, url, opt)
  local info = {
    install_info = {
      url = url,
      files = {"src/parser.c"},
      branch = "main",
    },
    filetype = ft,
  }

  if opt then
    info = vim.tbl_deep_extend("force", info, opt)
  end

  parser_config[ft] = info
end

return M
