local wezterm = require('wezterm')

local pipe = require('utils.pipe').pipe

local Conf = require('djavrell.options')
local Mappings = require('djavrell.mappings')

local WSSwitcher = require('WSSwitcher')
local wezline = require('wezline')

--- @type table
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = pipe(config, Conf, Mappings)

WSSwitcher.config()
wezline.config()

require('djavrell.events')

return config
