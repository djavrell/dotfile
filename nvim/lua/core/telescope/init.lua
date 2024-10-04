local reloader = function()
  RELOAD "plenary"
  RELOAD "telescope"
  RELOAD "core.telescope.setup"
end

local M = {}

local themes = require "telescope.themes"

local builtin = require('telescope.builtin')
local menufacture = require('telescope').extensions.menufacture

function M.find_files()
  return menufacture.find_files {
    fname_width = 80,
  }
end

function M.buffers()
  return builtin.buffers({
    layout_strategy = "center",
    layout_config = {
      anchor = "N",
      height = function(_, _, row) return math.min(row, 15) end,
    },
  })
end

function M.commands()
  return builtin.commands(themes.get_dropdown {
    previewer = false,
    layout_config = {
      width = function(_, col, _)
        return math.min(col, 150)
      end,
      height = function(_, _, row)
        return math.min(row, 50)
      end,
      prompt_position = "top"
    }
  })
end

function M.search_history()
  return builtin.search_history(themes.get_dropdown {
  previewer = false,
  layout_config = {
    prompt_position = "top"
  }
})
end

function M.quickfixhistory()
  return builtin.quickfixhistory(themes.get_dropdown {
    layout_config = {
      prompt_position = "top"
    }
  })
end

function M.lsp_references()
  return builtin.lsp_references {
    layout_strategy = "vertical",
    layout_config = {
      width = function(_, col, _)
        return math.min(col, 150)
      end,
      height = function(_, _, row)
        return math.min(row, 50)
      end,
      prompt_position = "top"
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
    show_line = false,
    include_declaration = false,
  }
end

function M.lsp_implementations()
  return builtin.lsp_references {
    layout_strategy = "vertical",
    layout_config = {
      width = function(_, col, _)
        return math.min(col, 150)
      end,
      height = function(_, _, row)
        return math.min(row, 50)
      end,
      prompt_position = "top"
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
    show_line = false,
  }
end

function M.lsp_definitions()
  return builtin.lsp_references {
    layout_strategy = "vertical",
    layout_config = {
      width = function(_, col, _)
        return math.min(col, 150)
      end,
      height = function(_, _, row)
        return math.min(row, 50)
      end,
      prompt_position = "top"
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
    show_line = false,
  }
end

function M.lsp_dynamic_workspace_symbols()
  return builtin.lsp_dynamic_workspace_symbols {
    fname_width = 80,
  }
end

function M.live_grep_args()
  return menufacture.live_grep()
end

function M.grep_string()
  return menufacture.grep_string()
end

return setmetatable({}, {
  __index = function(_, k)
    reloader()

    if M[k] then
      return M[k]
    else
      return require("telescope.builtin")[k]
    end
  end,
})
