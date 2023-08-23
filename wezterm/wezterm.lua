local wezterm = require 'wezterm'

local config = {}
local Conf = require('djavrell.options')
local Mappings = require('djavrell.mappings')

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = Conf(config)
config = Mappings(config)

return config
