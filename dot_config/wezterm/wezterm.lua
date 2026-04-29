local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = wezterm.config_builder()

config.unix_domains = {
  {
    name = 'unix',
  },
}

-- Decide whether cmd represents a default startup invocation
function is_default_startup(cmd)
  if not cmd then
    -- we were started with `wezterm` or `wezterm start` with
    -- no other arguments
    return true
  end
  if cmd.domain == "DefaultDomain" and not cmd.args then
    -- Launched via `wezterm start --cwd something`
    return true
  end
  -- we were launched some other way
  return false
end

wezterm.on('gui-startup', function(cmd)
  if is_default_startup(cmd) then
    -- for the default startup case, we want to switch to the unix domain instead
    local unix = mux.get_domain("unix")
    mux.set_default_domain(unix)
    -- ensure that it is attached
    unix:attach()
  end
end)

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
