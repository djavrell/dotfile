local wezterm = require('wezterm')

local cb = wezterm.action_callback
local act = wezterm.action

local split = require('utils.split').split

local T = require('utils.tables')

local conf = {}
local M = {}

---@class WorkspaceSwitcherOpt
---@field filePath string|nil location of the file that store all workspace pwd
---@field title string|nil

---@class WorkspaceSwitcherConfig
---@field filePath string location of the file that store all workspace pwd
---@field title string

---@type WorkspaceSwitcherConfig
local defaultConfig = {
    title = "Switch to workspace",
    filePath = os.getenv('HOME') .. '/.fzf-marks'
}

---@param opt WorkspaceSwitcherOpt|nil
function M.config(opt)
  conf = T.tbl_extend(defaultConfig, opt or {})
end


---@param path string file to read
---@param sep string line separator
local function getFileSplitBy(path, sep)
  local choices = {}

  for line in io.lines(path) do
    local tok = split(line, sep)
    table.insert(choices, {
      label = tok[1],
      id = tok[2]
    })
  end

  return choices
end

function M.switchTo()
  ---@type WorkspaceSwitcherConfig
  local opt = conf

  return cb(function(win, pane)
    win:perform_action(
      act.InputSelector({
        fuzzy = true,
        title = opt.title,
        choices = getFileSplitBy(opt.filePath, ':'),
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
