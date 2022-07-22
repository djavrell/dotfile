local reloader = function()
  RELOAD "plenary"
  RELOAD "telescope"
  RELOAD "tj.telescope.setup"
  RELOAD "tj.telescope.custom"
end

local M = {}

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"

local dropdown = themes.get_dropdown {
  previewer = false,
  layout_config = {
    prompt_position = "top"
  }
}

function M.buffers()
  return require('telescope.builtin').buffers(dropdown)
end

function M.commands()
  return require('telescope.builtin').commands(themes.get_dropdown {
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
  return require('telescope.builtin').search_history(dropdown)
end

function M.quickfixhistory()
  return require('telescope.builtin').quickfixhistory(themes.get_dropdown {
    layout_config = {
      prompt_position = "top"
    }
  })
end

function M.lsp_references()
  return require('telescope.builtin').lsp_references {
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
  }
end

function M.lsp_implementations()
  return require('telescope.builtin').lsp_references {
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
  }
end

function M.lsp_definitions()
  return require('telescope.builtin').lsp_references {
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
  }
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
