local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.unix_domains = {
  {
    name = 'unix',
  },
}

config.default_gui_startup_args = { 'connect', 'unix' }

local domains = wezterm.default_ssh_domains()

config.ssh_domains = domains

config.font_size = 13;
config.font = wezterm.font_with_fallback {
  "SFMono Nerd Font",
  "DejaVu Sans Mono",
}

config.keys = {
  {
    key = 's',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ShowLauncherArgs {
      flags = 'FUZZY|DOMAINS',
    },
  },
  {
    key = 's',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ShowLauncherArgs {
      flags = 'FUZZY|DOMAINS',
    },
  },
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ShowLauncherArgs {
      flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS|DOMAINS|WORKSPACES|COMMANDS',
    }
  },
  {
    key = 'k',
    mods = 'ALT',
    action = wezterm.action.ShowLauncherArgs {
      flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS|DOMAINS|WORKSPACES|COMMANDS',
    }
  },
}

return config
