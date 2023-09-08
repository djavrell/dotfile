local wezterm = require 'wezterm'

local workspace = require('space')
local map = require('utils.mapping')

---@param config table
---@return table
return function(config)
  local actions = wezterm.action

  config.leader = { key = 'x', mods = 'CTRL' }

  config.keys = {
    map.alt('w', actions.ActivateKeyTable { name = 'win', timeout_millisecond = 500 }),
    map.alt('p', actions.ActivateKeyTable { name = 'pane', timeout_millisecond = 500 }),
    map.Alt('p', actions.ActivateKeyTable { name = 'resize_pane', one_shot = false }),

    map.cm('v', actions.PasteFrom('Clipboard')),
    map.cm('v', actions.PasteFrom('PrimarySelection')),

    map.leader('c', actions.ActivateCopyMode),
    map.leader('s', actions.ShowLauncherArgs( { flags = 'FUZZY|WORKSPACES' } )),
    map.leader('t', actions.ShowLauncherArgs( { flags = 'FUZZY|TABS' } )),

    map.leader('u', workspace.switchTo()),

    map.ctrl('+', actions.IncreaseFontSize),
    map.ctrl('-', actions.DecreaseFontSize),
    map.ctrl('0', actions.ResetFontSize),
  }

  config.key_tables = {
    win = {
      { key = 'n', action = actions.SpawnTab('CurrentPaneDomain')},
      { key = 'h', action = actions.ActivateTabRelative(-1) },
      { key = 'l', action = actions.ActivateTabRelative(1) },
      { key = '-', action = actions.SplitVertical({ domain = 'CurrentPaneDomain' })},
      { key = '+', action = actions.SplitHorizontal({ domain = 'CurrentPaneDomain' })},
      { key = 'o', action = actions.ActivateLastTab }
    },
    pane = {
      { key = 'l', action = actions.ActivatePaneDirection('Next') },
      { key = 'h', action = actions.ActivatePaneDirection('Prev') },
    },
    resize_pane = {
      { key = 'h', action = actions.AdjustPaneSize { 'Left', 5 } },
      { key = 'l', action = actions.AdjustPaneSize { 'Right', 5 } },
      { key = 'k', action = actions.AdjustPaneSize { 'Up', 5 } },
      { key = 'j', action = actions.AdjustPaneSize { 'Down', 5 } },
      { key = 'Escape', action = 'PopKeyTable' },
    }
  }

  return config
end
