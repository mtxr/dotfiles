local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local scratch       = require("scratch")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

local f=io.open(os.getenv("HOME") .. "/.startup.sh","r")
-- startup script
if f~=nil then
    io.close(f)
    awful.spawn.with_shell("bash " .. os.getenv("HOME") .. "/.startup.sh")
end

-- Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 0
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "Meslo LGS Regular 10"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 32
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil

-- Autostart windowless processes
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
            findme = cmd:sub(0, firstspace-1)
        end
        awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
    end
end

awful.util.spawn_with_shell('~/.config/awesome/locker.sh')
awful.util.spawn_with_shell('nm-applet')

-- entries must be comma-separated

-- Variable definitions
local themes = {
    "pro-dark",           -- 1
    "pro-gotham",         -- 2
    "pro-light",          -- 3
    "pro-medium-dark",    -- 4
    "pro-medium-light",   -- 5
    "pro-me",             -- 6
}

local chosen_theme = themes[6]
local modkey       = "Mod4"
local altkey       = "Mod1"
local ctrlKey      = "Control"
local shiftKey     = "Shift"
local terminal     = "gnome-terminal"
local editor       = os.getenv("EDITOR") or "nano"
local gui_editor   = "gvim"
local browser      = "google-chrome"
local home   = os.getenv("HOME")

-- Theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/" .. chosen_theme .. "/theme.lua")

-- Layouts
awful.util.terminal = terminal
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    -- awful.layout.suit.max,
    -- lain.layout.centerwork,
    -- awful.layout.suit.spiral,
    awful.layout.suit.magnifier,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    -- lain.layout.cascade,
    -- lain.layout.cascade.tile,
    -- lain.layout.centerwork.horizontal,
    -- lain.layout.termfair.center,
}

awful.util.taglist_buttons = awful.util.table.join(
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
awful.util.tasklist_buttons = awful.util.table.join(
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
                     awful.button({ }, 3, function()
                         local instance = nil

                         return function ()
                             if instance and instance.wibox.visible then
                                 instance:hide()
                                 instance = nil
                             else
                                 instance = awful.menu.clients({ theme = { width = 250 } })
                             end
                        end
                     end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

-- Widgets
local markup = lain.util.markup
space3 = markup.font("Terminus 3", " ")
-- space2 = markup.font("Terminus 2", " ")
-- vspace1 = '<span font="Terminus 3"> </span>'
-- vspace2 = '<span font="Terminus 3">  </span>'
clockgf = beautiful.clockgf

spr = wibox.widget.imagebox(beautiful.spr)
spr4px = wibox.widget.imagebox(beautiful.spr4px)
spr5px = wibox.widget.imagebox(beautiful.spr5px)

widget_display = wibox.widget.imagebox(beautiful.widget_display)
widget_display_r = wibox.widget.imagebox(beautiful.widget_display_r)
widget_display_l = wibox.widget.imagebox(beautiful.widget_display_l)
widget_display_c = wibox.widget.imagebox(beautiful.widget_display_c)

-- Clock / Calendar
local calendar_icon = wibox.widget.imagebox(beautiful.widget_cal)
local clock_types = {
    "%H:%M",          -- 13:19
    "%a %d %b %H:%M", -- Thu 08 Feb 13:19
}

local chosen_clock_type = clock_types[2] -- You can choose a clock type
local textclock = wibox.widget.textclock(markup.font("Monospace 9", chosen_clock_type .. markup.font("Monospace 3", " ")))
local clock_widget = wibox.container.background(textclock)
clock_widget.bgimage=beautiful.widget_display
local cal_widget = lain.widget.cal({
    -- cal = "cal --color=always",
    attach_to = { textclock },
    notification_preset = {
        font = 'Monospace 10',
        fg   = beautiful.fg_normal,
        bg   = beautiful.bg_normal
    }
})

-- CPU
local cpu_icon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font("Monospace 9", cpu_now.usage .. "%"))
    end
})
local cpu_widget = wibox.container.background(cpu.widget)
cpu_widget.bgimage=beautiful.widget_display

-- VOLUME
local volume_step    = 5

local volume_lain = lain.widget.alsabar({
    width=50,
    margins = { top = 10, bottom = 10 },
    paddings = 0,
    timeout=60
})

local volume_inc_cmd = string.format("%s sset %s %s%%+", volume_lain.cmd, volume_lain.channel, volume_step)
local volume_dec_cmd = string.format("%s sset %s %s%%-" , volume_lain.cmd, volume_lain.channel, volume_step)
local volume_tog_cmd = string.format("%s sset %s toggle", volume_lain.cmd, volume_lain.channel)

volume_lain.bar:buttons(awful.util.table.join(
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

local volume_widget = wibox.container.background(volume_lain.bar)
volume_widget.bgimage=beautiful.widget_display
local volume_icon = wibox.widget.imagebox(beautiful.widget_music)

-- LIGHT
local light_step = 5
local light_up   = string.format("%s -A %s", 'light', light_step)
local light_down = string.format("%s -U %s", 'light', light_step)

local light_lain = lain.widget.light({
    settings = function()
        widget:set_markup(markup.font("Monospace 9", light_now.level .. "%"))
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

local light_widget = wibox.container.background(light_lain.widget)
light_widget.bgimage=beautiful.widget_display
local light_icon = wibox.container.margin(wibox.widget {
    image  = beautiful.widget_light,
    resize = true,
    widget = wibox.widget.imagebox
}, 5, 5, 5, 5)

-- translate_new
local translate = require("widget.translate")


-- MEM
local mem_icon = wibox.widget.imagebox(beautiful.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font("Monospace 9", mem_now.perc .. "%"))
    end
})
local mem_widget = wibox.container.background(mem.widget)
mem_widget.bgimage=beautiful.widget_display

-- MPD

-- prev_icon = wibox.widget.imagebox(beautiful.mpd_prev)
-- next_icon = wibox.widget.imagebox(beautiful.mpd_nex)
-- stop_icon = wibox.widget.imagebox(beautiful.mpd_stop)
-- pause_icon = wibox.widget.imagebox(beautiful.mpd_pause)
-- play_pause_icon = wibox.widget.imagebox(beautiful.mpd_play)
-- mpd_sepl = wibox.widget.imagebox(beautiful.mpd_sepl)
-- mpd_sepr = wibox.widget.imagebox(beautiful.mpd_sepr)

-- mpdwidget = lain.widget.mpd({
--     settings = function ()
--         if mpd_now.state == "play" then
--             mpd_now.artist = mpd_now.artist:upper():gsub("&.-;", string.lower)
--             mpd_now.title = mpd_now.title:upper():gsub("&.-;", string.lower)
--             widget:set_markup(markup.font("Monospace 3", " ")
--                               .. markup.font("Monospace 7",
--                               mpd_now.artist
--                               .. " - " ..
--                               mpd_now.title
--                               .. markup.font("Monospace 2", " ")))
--             play_pause_icon = wibox.widget.imagebox(beautiful.mpd_pause)
--             mpd_sepl = wibox.widget.imagebox(beautiful.mpd_sepl)
--             mpd_sepr = wibox.widget.imagebox(beautiful.mpd_sepr)
--         elseif mpd_now.state == "pause" then
--             widget:set_markup(markup.font("Monospace 4", "") ..
--                               markup.font("Monospace 7", "MPD PAUSED") ..
--                               markup.font("Monospace 10", ""))
--             play_pause_icon = wibox.widget.imagebox(beautiful.mpd_play)
--             mpd_sepl = wibox.widget.imagebox(beautiful.mpd_sepl)
--             mpd_sepr = wibox.widget.imagebox(beautiful.mpd_sepr)
--         else
--             widget:set_markup("")
--             play_pause_icon = wibox.widget.imagebox(beautiful.mpd_play)
--             mpd_sepl = wibox.widget.imagebox(nil)
--             mpd_sepr = wibox.widget.imagebox(nil)
--         end
--     end
-- })

-- Battery
local bat_icon = wibox.widget.imagebox(beautiful.widget_battery)
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
            fg = beautiful.bat_fg_critical,
            bg = beautiful.bat_bg_critical
        }

        if bat_now.status ~= "N/A" then
            local battery_perc = markup.font("Monospace 9", bat_now.perc .. "%")
            if bat_now.status == "Charging" then
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, battery_perc)))
                bat_icon:set_image(beautiful.widget_ac)
            elseif bat_now.status == "Full" then
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, battery_perc)))
                bat_icon:set_image(beautiful.widget_battery)
            elseif tonumber(bat_now.perc) <= 35 then
                bat_icon:set_image(beautiful.widget_battery_empty)
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, battery_perc)))
            elseif tonumber(bat_now.perc) <= 80 then
                bat_icon:set_image(beautiful.widget_battery_low)
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, battery_perc)))
            elseif tonumber(bat_now.perc) <= 99 then
                bat_icon:set_image(beautiful.widget_battery)
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, battery_perc)))
            else
                bat_icon:set_image(beautiful.widget_battery)
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, battery_perc)))
            end
        else
            widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, " AC ")))
            bat_icon:set_image(beautiful.widget_ac)
        end
    end
})
local bat_widget = wibox.container.background(bat.widget)
bat_widget.bgimage=beautiful.widget_display

-- Mail
-- local mail_icon = wibox.widget.imagebox(beautiful.widget_mail)
-- commented because it needs to be set before use
-- local mail = lain.widget.imap({
--     timeout  = 180,
--     server   = "server",
--     mail     = "login",
--     password = "password",
--     settings = function()
--         mail_notification_preset.fg = beutiful.fg_normal
--         mail  = ""
--         count = ""

--         if mailcount > 0 then
--             mail = "Mail "
--             count = mailcount .. " "
--         end

--         widget:set_markup(markup.font(beautiful.font, markup(blue, mail) .. markup("#FFFFFF", count)))
--     end
-- })

function connect(s)
  s.quake = lain.util.quake({ app = awful.util.terminal })

  -- If wallpaper is a function, call it with the screen
  local wallpaper = beautiful.wallpaper
  if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
  end
  gears.wallpaper.maximized(wallpaper, 1, true)

  -- Tags
  --awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])
  layout = { awful.layout.layouts[1], awful.layout.layouts[1], awful.layout.layouts[1], awful.layout.layouts[3], awful.layout.layouts[5], awful.layout.layouts[5]}
  awful.tag({ "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  " }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(awful.util.table.join(
                         awful.button({ }, 1, function () awful.layout.inc( 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(-1) end),
                         awful.button({ }, 4, function () awful.layout.inc( 1) end),
                         awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s, height = 22, bg = beautiful.panel, fg = beautiful.fg_normal })

  -- Add widgets to the wibox
  s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          spr5px,
          s.mytaglist,
          spr5px,

      },
      s.mytasklist, -- Middle widget
      --nil,
      { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          s.mypromptbox,
          spr,
          wibox.widget.systray(),
          -- CPU widget
          spr,
          cpu_icon,
          widget_display_l,
          cpu_widget,
          widget_display_r,
          spr5px,
          -- Mem widget
          spr,
          mem_icon,
          widget_display_l,
          mem_widget,
          widget_display_r,
          spr5px,
          -- Battery widget
          spr,
          bat_icon,
          widget_display_l,
          bat_widget,
          widget_display_r,
          spr5px,
          -- volume bar
          spr,
          volume_icon,
          widget_display_l,
          volume_widget,
          widget_display_r,
          spr5px,
          -- light bar
          spr,
          light_icon,
          widget_display_l,
          light_widget,
          widget_display_r,
          spr5px,
          -- Clock
          spr,
          calendar_icon,
          widget_display_l,
          clock_widget,
          widget_display_r,
          spr5px,
          spr,
          -- Layout box
          s.mylayoutbox,
      },
  }
end

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) connect(s) end)

-- Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})

screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys = awful.util.table.join(
    -- X screen locker
    awful.key({ altkey, ctrlKey }, "l", function ()
            awful.util.spawn("sync")
            awful.util.spawn("xautolock -locknow")
        end,
              {description = "lock screen", group = "hotkeys"}),
    -- Hotkeys
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Tag browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    -- Non-empty tag browsing
    awful.key({ modkey, shiftKey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view  previous nonempty", group = "tag"}),
    awful.key({ modkey, shiftKey }, "Right", function () lain.util.tag_view_nonempty(1) end,
              {description = "view  previous nonempty", group = "tag"}),

    -- Default client focus
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

    -- By direction client focus
    -- awful.key({ modkey }, "j",
    --     function()
    --         awful.client.focus.bydirection("down")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "focus down", group = "client"}),
    -- awful.key({ modkey }, "k",
    --     function()
    --         awful.client.focus.bydirection("up")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "focus up", group = "client"}),
    -- awful.key({ modkey }, "h",
    --     function()
    --         awful.client.focus.bydirection("left")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "focus left", group = "client"}),
    -- awful.key({ modkey }, "l",
    --     function()
    --         awful.client.focus.bydirection("right")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "focus right", group = "client"}),
    -- awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, shiftKey }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, shiftKey }, "k", function () awful.client.swap.byidx( -1)    end,
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

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}),

    -- Dynamic tagging
    awful.key({ modkey, shiftKey }, "n", function () lain.util.add_tag() end,
              {description = "add new tag", group = "tag"}),
    awful.key({ modkey, shiftKey }, "r", function () lain.util.rename_tag() end,
              {description = "rename tag", group = "tag"}),
    -- awful.key({ modkey, shiftKey }, "Left", function () lain.util.move_tag(-1) end,
    --           {description = "move tag to the left", group = "tag"}),
    -- awful.key({ modkey, shiftKey }, "Right", function () lain.util.move_tag(1) end,
    --           {description = "move tag to the right", group = "tag"}),
    awful.key({ modkey, shiftKey }, "d", function () lain.util.delete_tag() end,
              {description = "delete tag", group = "tag"}),
    -- Programms
    -- awful.key({ modkey            }, "l", function() awful.util.spawn_with_shell("~/.config/scripts/lock.sh") end),
    awful.key({                   }, "Print", function() awful.util.spawn("flameshot gui") end),
    --awful.key({ }, "F4", function () scratch.drop("weechat", "bottom", "left", 0.60, 0.60, true, mouse.screen) end),
    --awful.key({ }, "F6", function () scratch.drop("smuxi-frontend-gnome", "bottom", "left", 0.60, 0.60, true, mouse.screen) end),
    -- awful.key({ }, "F12", function () awful.util.spawn("/home/ban/.config/scripts/translate_new.sh \"".. translate_service.. "\"",false) end),
    -- Standard program
    awful.key({ altkey, ctrlKey }, "t", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "x", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, ctrlKey }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ altkey, ctrlKey   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ altkey, shiftKey }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ altkey, shiftKey }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, shiftKey }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, shiftKey }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, ctrlKey }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, ctrlKey }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, shiftKey }, "space", function () awful.layout.inc(-1)                end,
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

    -- Dropdown application
    awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end,
              {description = "dropdown application", group = "launcher"}),

    -- Widgets popups
    awful.key({ altkey, ctrlKey }, "c", function () cal_widget.show() end,
              {description = "show calendar", group = "widgets"}),
    -- awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
    --           {description = "show filesystem", group = "widgets"}),
    -- awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
    --           {description = "show weather", group = "widgets"}),

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

    -- Default
    --[[ Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
    --]]
    --[[ dmenu
    awful.key({ modkey }, "x", function ()
        awful.spawn(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
        beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
    end,
        {description = "show dmenu", group = "launcher"}),
    --]]
    -- Prompt
    awful.key({ modkey }, "r", function () awful.util.spawn("dmenu_extended_run") end),
    -- awful.key({ altkey }, "o", function () awful.screen.focused().mypromptbox:run() end,
    --           {description = "run prompt", group = "launcher"}),

    awful.key({ altkey }, "l",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, shiftKey }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ altkey,           }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, ctrlKey }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,          }, "y",      function (c) c.ontop = not c.ontop            end,
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
        {description = "maximize", group = "client"}),
    awful.key({ modkey }, "t",
        function()
            translate.show_translate_prompt()
        end,
        { description = "run translate prompt", group = "launcher" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, ctrlKey }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
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
                  descr_move),
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
                  descr_toggle_focus)
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

root.keys(globalkeys)

-- Rules

awful.rules.rules = {
    { rule = { },
      properties = { border_width = 0, beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = true } },

    { rule = { class = "Caja" },
      properties = { floating = true, geometry = { x=200, y=150, height=600, width=1100 } } },
    { rule = { class = "Nm-connection-editor" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { instance = "exe" },
      properties = { floating = true } },
    { rule = { role = "_NET_WM_STATE_FULLSCREEN" },
      properties = { floating = true } },
    { rule = { class = "Gimp", role = "gimp-image-window" },
      properties = { maximized = true } },
}

-- Signals
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
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
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

    awful.titlebar(c, {size = 16}) : setup {
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

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized then -- no borders if only 1 client visible
            c.border_width = 0
        elseif #awful.screen.focused().clients > 1 then
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
