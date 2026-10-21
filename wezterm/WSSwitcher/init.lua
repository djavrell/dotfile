local wezterm = require('wezterm')

local G = wezterm.GLOBAL
local namespace = 'WSSwitcher'

local cb = wezterm.action_callback
local act = wezterm.action

local split = require('utils.split').split

local T = require('utils.tables')

local M = {}

---@type WorkspaceSwitcherConfig
local defaultConfig = {
  title = 'Switch to workspace',
  -- home_dir is %USERPROFILE% on Windows, $HOME on Linux; USERPROFILE alone is nil on Linux and broke the whole config
  filePath = wezterm.home_dir .. '/.local/share/.fzf-marks',
}

---@param opt WorkspaceSwitcherOpt|nil
function M.config(opt)
  G[namespace] = T.tbl_extend(defaultConfig, opt or {})
end

function M.getConfig()
  return G[namespace]
end

---@param path string file to read
---@param sep string line separator
local function getFileSplitBy(path, sep)
  local choices = {}

  -- io.lines raises when the marks file is missing (fresh machine): show an empty selector instead
  local file = io.open(path)
  if not file then
    wezterm.log_warn('WSSwitcher: no marks file at ' .. path)
    return choices
  end

  for line in file:lines() do
    local tok = split(line, sep)
    table.insert(choices, {
      label = tok[1],
      id = tok[2],
    })
  end
  file:close()

  return choices
end

function M.switchTo()
  return cb(function(win, pane)
    -- read at keypress, not here: mappings are built before M.config() runs in wezterm.lua
    ---@type WorkspaceSwitcherConfig
    local opt = M.getConfig()


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
                spawn = { cwd = id },
              }),
              pane
            )
          end
        end),
      }),
      pane
    )
  end)
end

return M
