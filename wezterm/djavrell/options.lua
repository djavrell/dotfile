local wezterm = require('wezterm')

--- @param config table
--- @return table
return function(config)
  if wezterm == nil then
    return config
  end

  config.color_scheme = 'nordic'
  config.font = wezterm.font('Hasklug Nerd Font')
  config.font_size = 8

  config.window_padding = {
    left = 0,
    right = 0,
    bottom = 0,
    top = 0,
  }
  -- with no padding the leftover pixels all go to the bottom/right edge; spread them around instead
  config.window_content_alignment = { horizontal = 'Center', vertical = 'Center' }

  config.enable_scroll_bar = false
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true

  config.enable_kitty_keyboard = false
  config.disable_default_key_bindings = true

  config.status_update_interval = 500
  config.scrollback_lines = 10000

  config.audible_bell = 'Disabled'

  -- the 'arch' WSL domain only exists on Windows; on native Linux the local domain is the right default
  if wezterm.target_triple:find('windows') then
    config.wsl_domains = {
      {
        name = 'arch',
        distribution = 'Arch',
        default_cwd = '/home/kpr',
      },
    }

    config.default_domain = 'arch'
  end

  return config
end
