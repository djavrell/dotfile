local wezterm = require 'wezterm'

local config = {}
local U = require('utils.utils')

local Conf = require('djavrell.options')
local Mappings = require('djavrell.mappings')

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = U.pipe(
  config,
  Conf,
  Mappings
)

require('djavrell.events')

return config
