local wezterm = require 'wezterm'

local map = require('utils.mapping')
local status = require('utils.status')

local alt = map.mod('ALT')
local ctrl = map.mod('CTRL')
local cm = map.mod('CTRL|SHIFT')
local leader = map.mod('LEADER')

return function(config)
  local actions = wezterm.action

  config.leader = { key = 'Space', mods = 'CTRL' }

  config.keys = {
    alt('w', actions.ActivateKeyTable { name = 'win', timeout_millisecond = 500 }),
    cm('v', actions.PasteFrom('Clipboard')),
    cm('v', actions.PasteFrom('PrimarySelection')),
    leader('c', actions.ActivateCopyMode),
    leader('s', actions.ShowLauncherArgs( { flags = 'FUZZY|WORKSPACES' } )),
    leader('t', actions.ShowLauncherArgs( { flags = 'FUZZY|TABS' } )),
    ctrl('+', actions.IncreaseFontSize),
    ctrl('-', actions.DecreaseFontSize),
    ctrl('0', actions.ResetFontSize),
  }

  config.key_tables = {
    win = {
      { key = 'n', action = actions.SpawnTab('CurrentPaneDomain')},
      { key = 'h', action = actions.ActivateTabRelative(-1) },
      { key = 'l', action = actions.ActivateTabRelative(1) },
      { key = '-', action = actions.SplitVertical({ domain = 'CurrentPaneDomain' })},
      { key = '+', action = actions.SplitHorizontal({ domain = 'CurrentPaneDomain' })}
    }
  }

  wezterm.on('update-right-status', status.KeyGroup)

  return config
end
