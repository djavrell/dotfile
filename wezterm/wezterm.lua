local wezterm = require 'wezterm'

local config = {}
local Conf = require('djavrell.options')
local Mappings = require('djavrell.mappings')
local U = require('utils.utils')

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = U.pipe(
  config,
  Conf,
  Mappings
)

return config
