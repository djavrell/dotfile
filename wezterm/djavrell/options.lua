local wezterm = require 'wezterm'

--- @param config table
--- @return table
return function(config)
  if wezterm == nil then
    return config
  end

  config.color_scheme = 'nordic'
  config.font = wezterm.font 'Hasklug Nerd Font'

  config.window_padding = {
    left = 0,
    right = 0,
    bottom = 0,
    top = 0
  }

  config.enable_scroll_bar = false
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true

  config.enable_kitty_keyboard = true
  config.disable_default_key_bindings = true

  config.status_update_interval = 500

  config.wsl_domains = {
    {
      name = "arch",
      distribution = "Arch",
      default_cwd = "/home/kpr"
    }
  }

  config.default_domain = 'arch'

  return config
end
