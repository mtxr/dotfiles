local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local domains = wezterm.default_ssh_domains()

config.ssh_domains = domains

config.keys = {
  {
    key = 's',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ShowLauncherArgs {
      flags = 'FUZZY|DOMAINS',
    },
  }
}

return config
