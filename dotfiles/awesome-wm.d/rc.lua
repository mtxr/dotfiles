-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local lain = require("lain")
local home = os.getenv("HOME")
local markup = lain.util.markup

-- {{{ Helper functions
local function label(text)
    return markup.font(beautiful.font, markup.fg.color(beautiful.fg_muted, (markup.small(text .. " "))))
end

local function value(text, color)
    color = color or beautiful.fg_normal

    return markup.font(beautiful.font, markup.fg.color(color, markup.bold(text)))
end

local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

local function notify_critical(err, title)
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = title or "Error!",
      text = err
    }
  )
end

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- }}}

-- Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "bottom_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 10
naughty.config.defaults.ontop = true
naughty.config.defaults.font = beautiful.notification_font
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 32
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil

-- Startup errors handler and scirpts {{{
if awesome.startup_errors then
  notify_critical(awesome.startup_errors, "Oops, there were errors during startup!")
end

do
  local in_error = false
  awesome.connect_signal(
    "debug::error",
    function(err)
      if in_error then
        return
      end
      in_error = true
      notify_critical(tostring(err))
      in_error = false
    end
  )
end

local startup_script = home .. "/.startup.sh"
local f = io.open(startup_script, "r")
if f ~= nil then
  io.close(f)
  awful.spawn.with_shell(startup_script)
end
-- }}}

-- THEME DEFINITION
local theme_name = "default"
local modkey = "Mod4"
local altkey = "Mod1"
local ctrlKey = "Control"
local shiftKey = "Shift"
local terminal = "urxvt"
local editor = os.getenv("VSCODE_CLI") or "vi"
local browser = "google-chrome"

beautiful.init(home .. "/.config/awesome/theme/" .. theme_name .. "/theme.lua")

-- -- Layouts
awful.util.terminal = terminal
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.magnifier,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal
}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Widgets
local widget_sep = wibox.widget.textbox()
local spc = markup.font(beautiful.font_base .. " 5", " ")
widget_sep:set_markup(spc .. markup.fg.color(beautiful.xrdb.color13, markup.font(beautiful.font_base .. " 5", "|")) .. spc)

local chosen_clock_type = "%a %d %b %H:%M"
local clock_widget = wibox.widget.textclock(value(chosen_clock_type))

local cal_widget = lain.widget.cal({
    -- cal = "cal --color=always",
    week_start = 1,
    attach_to = { clock_widget },
    notification_preset = {
        fg   = beautiful.fg_normal,
        bg   = beautiful.bg_normal
    }
})

-- CPU
local cpu = lain.widget.cpu({
    settings = function()
        local color = nil

        if cpu_now.usage <= 20.0 then
            color = beautiful.ok
        elseif cpu_now.usage <= 70.0 then
            color = beautiful.attention
        else
            color = beautiful.warning
        end

        widget:set_markup(label("CPU") .. value(cpu_now.usage .. "%", color))
    end
})
local cpu_widget = cpu.widget

-- NET
local upload_widget = wibox.widget.textbox()
local download_widget = wibox.widget.textbox()

local network = lain.widget.net {
    wifi_state = "on",
    eth_state = "on",
    notify = "on",
    settings = function()
        local colorup = beautiful.fg_normal
        local colordown = beautiful.fg_normal

        if tonumber(net_now.sent) > 0 then
            colorup = beautiful.attention
        end
        if tonumber(net_now.received) > 0 then
            colordown = beautiful.ok
        end

        upload_widget:set_markup(label('UP') .. value(string.format("%2.1f kb/s", tonumber(net_now.sent)), colorup))
        download_widget:set_markup(label('DOWN') .. value(string.format("%2.1f kb/s", tonumber(net_now.received)), colordown))
    end
}
local net_widget = network.widget

-- VOLUME
local volume_step = 5
local volume_lain = lain.widget.alsabar({
    width=50,
    colors = {
      background = "#111111",
      mute       = beautiful.critical,
      unmute     = beautiful.ok
    },
    margins = { top = 5, bottom = 5 },
    paddings = 0,
    timeout=60
})

local volume_inc_cmd = string.format("%s sset %s %s%%+", volume_lain.cmd, volume_lain.channel, volume_step)
local volume_dec_cmd = string.format("%s sset %s %s%%-" , volume_lain.cmd, volume_lain.channel, volume_step)
local volume_tog_cmd = string.format("%s sset %s toggle", volume_lain.cmd, volume_lain.channel)

local volume_bar = volume_lain.bar
local volume_widget = wibox.widget {
    wibox.widget{
        markup = label("VOL"),
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    },
    volume_bar,
    layout  = wibox.layout.align.horizontal
}

volume_widget:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn(volume_tog_cmd)
        volume_lain.update()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn(volume_inc_cmd)
        volume_lain.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn(volume_dec_cmd)
        volume_lain.update()
    end)
))

-- LIGHT
local light_step = 5
local light_up   = string.format("%s -A %s", 'light', light_step)
local light_down = string.format("%s -U %s", 'light', light_step)

local light_lain = lain.widget.light({
    settings = function()
        widget:set_markup(label("LIGHT") .. value(light_now.level .. "%"))
    end,
    timeout=60
})

light_lain.widget:buttons(awful.util.table.join(
    awful.button({}, 4, function() -- scroll up
        awful.spawn(light_up)
        light_lain.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn(light_down)
        light_lain.update()
    end)

))

local light_widget = light_lain.widget

-- MEM
local mem = lain.widget.mem({
    settings = function()
        local color = nil

        if mem_now.perc <= 20.0 then
            color = beautiful.ok
        elseif mem_now.perc <= 70.0 then
            color = beautiful.attention
        else
            color = beautiful.warning
        end

        widget:set_markup(label("MEM") .. value(mem_now.perc .. "%", color))
    end
})
local mem_widget = mem.widget

-- battery
local bat = lain.widget.bat({
    notify = "on",
    settings = function()
        bat_notification_low_preset = {
            title = "Battery low",
            text = "Plug the cable!",
            timeout = 15,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal
        }
        bat_notification_critical_preset = {
            title = "Battery exhausted",
            text = "Shutdown imminent",
            timeout = 15,
            fg = beautiful.fg_urgent,
            bg = beautiful.bg_urgent
        }

        if bat_now.status ~= "N/A" then
            local color = nil

            if bat_now.perc <= 15.0 then
                color = beautiful.critical
            elseif bat_now.perc <= 50.0 then
                color = beautiful.warning
            elseif bat_now.perc <= 70.0 then
                color = beautiful.attention
            else
                color = beautiful.ok
            end

            widget:set_markup(label("BAT") .. value(bat_now.perc .. "%", color))
        else
            widget:set_markup(value("CHARGED", beautiful.ok))
        end
    end
})
local bat_widget = bat.widget

-- translate_new
local translate = require("widget.translate")

-- {{{ Wibar
-- Create a textclock widget

-- end of wigets

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.panel_height or 20, bg = beautiful.panel, fg = beautiful.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            widget_sep,
            bat_widget,
            widget_sep,
            upload_widget,
            widget_sep,
            download_widget,
            widget_sep,
            cpu_widget,
            widget_sep,
            mem_widget,
            widget_sep,
            volume_widget,
            widget_sep,
            light_widget,
            widget_sep,
            clock_widget,
            widget_sep,
            s.mylayoutbox
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey }, "t",
        function()
            translate.show_translate_prompt()
        end,
        { description = "run translate prompt", group = "launcher" }),

    awful.key({ altkey, ctrlKey }, "=", function () lain.util.useless_gaps_resize(1) end,
        {description = "+ useless gaps", group="awesome"}),
    awful.key({ altkey, ctrlKey }, "-", function () lain.util.useless_gaps_resize(-1) end,
        {description = "- useless gaps", group="awesome"}),
    -- screenshot
        awful.key({                   }, "Print", function() awful.util.spawn("flameshot gui") end),
    -- X screen locker
    awful.key({ altkey, ctrlKey }, "l", function ()
            awful.util.spawn("sync")
            awful.util.spawn("xautolock -locknow")
        end,
              {description = "lock screen", group = "hotkeys"}),


    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, shiftKey   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, shiftKey   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, ctrlKey }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, ctrlKey }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ altkey, ctrlKey }, "t", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, ctrlKey }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    -- awful.key({ modkey, shiftKey   }, "q", awesome.quit,
    --           {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, shiftKey   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, shiftKey   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, ctrlKey }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, ctrlKey }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, shiftKey   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, ctrlKey }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey }, "x", function ()
            awful.spawn(string.format("dmenu_run -i -fn '%s' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.font or 'Monospace 9', beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"}),
    awful.key({ modkey }, "r", function () awful.util.spawn("dmenu_extended_run") end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "l",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    -- Monitor Switch
    awful.key({ modkey, shiftKey }, "p", function() awful.spawn.with_shell("bash " .. os.getenv("HOME") .. "/.workstation/bin/monitor-switch.sh") end,
              {description = "monitor switch", group = "screen"}),
    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp",
        function ()
            awful.util.spawn(light_up)
            light_lain.update()
        end,
              {description = "light +" .. light_step .. "%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown",
        function ()
            awful.util.spawn(light_down)
            light_lain.update()
        end,
              {description = "light -" .. light_step .. "%", group = "hotkeys"}),

    -- ALSA volume control
    awful.key({  }, "XF86AudioRaiseVolume",
        function ()
            awful.spawn(volume_inc_cmd)
            volume_lain.update()
        end,
        {description = "volume +" .. volume_step .. "%", group = "hotkeys"}),
    awful.key({  }, "XF86AudioLowerVolume",
        function ()
            awful.spawn(volume_dec_cmd)
            volume_lain.update()
        end,
        {description = "volume -" .. volume_step .. "%", group = "hotkeys"}),
    awful.key({  }, "XF86AudioMute",
        function ()
            awful.spawn(volume_tog_cmd)
            volume_lain.update()
        end,
        {description = "Mute sounds.", group = "hotkeys"}),
    -- calendar
    awful.key({ altkey, ctrlKey }, "c", function () cal_widget.show() end,
              {description = "show calendar", group = "widgets"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, shiftKey   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, ctrlKey }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, ctrlKey }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, ctrlKey }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, shiftKey   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, ctrlKey }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, shiftKey }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, ctrlKey, shiftKey }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = true
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal" }
      }, properties = { titlebars_enabled = beautiful.titlebars_enabled }
    },
    { rule_any = {type = { "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus",
    function(c)
        if c.maximized then -- no borders if only 1 client visible
            c.border_width = 0
        elseif #awful.screen.focused().clients > 1 then
            c.border_width = beautiful.border_focus_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
