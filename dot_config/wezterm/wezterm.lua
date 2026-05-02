local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = wezterm.config_builder()

-- Performance: use WebGpu renderer (Metal on macOS), much faster than OpenGL
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- Animation: needed for Claude Code spinners and other TUI animations
config.animation_fps = 60
config.max_fps = 120

-- Reduce input latency
config.enable_kitty_keyboard = true

-- Disable update checks at startup (saves a network round-trip)
config.check_for_updates = false

config.unix_domains = {
  {
    name = 'unix',
  },
}

-- Decide whether cmd represents a default startup invocation
local function is_default_startup(cmd)
  if not cmd then
    return true
  end
  if cmd.domain == "DefaultDomain" and not cmd.args then
    return true
  end
  return false
end

wezterm.on('gui-startup', function(cmd)
  if is_default_startup(cmd) then
    local unix = mux.get_domain("unix")
    mux.set_default_domain(unix)
    unix:attach()
  end
end)

local domains = wezterm.default_ssh_domains()
config.ssh_domains = domains

config.font_size = 13
config.font = wezterm.font_with_fallback {
  "JetBrainsMono Nerd Font",
  "DejaVu Sans Mono",
}

-- Disable font ligatures (can slow down rendering in code-heavy terminals)
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

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
