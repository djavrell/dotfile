local wezterm = require('wezterm')

local G = wezterm.GLOBAL
local cb = wezterm.action_callback
local act = wezterm.action

local U = require('utils.utils')

local M = {}


---@param path string file to read
---@param sep string line separator
local function getFileSplitBy(path, sep)
  local choices = {}

  for line in io.lines(path) do
    local tok = U.split(line, sep)
    table.insert(choices, {
      label = tok[1],
      id = tok[2]
    })
  end

  return choices
end

function M.switchTo()
  return cb(function(win, pane)
    win:perform_action(
      act.InputSelector({
        title = 'Switch to project',
        choices = getFileSplitBy(G.marksFile, ':'),
        action = cb(function(_, _, id, label)
          if id and label then
            win:perform_action(
              act.SwitchToWorkspace({
                name = label,
                spawn = { cwd = id }
              }),
              pane
            )
          end
        end)
      }),
      pane
    )
  end)
end

return M
