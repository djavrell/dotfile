local wezterm = require('wezterm')

local pipe = require('utils.pipe').pipe

local Conf = require('djavrell.options')
local Mappings = require('djavrell.mappings')

local WSSwitcher = require('WSSwitcher')

local config = pipe(wezterm.config_builder(), Conf, Mappings)

WSSwitcher.config()

require('djavrell.events')

return config
