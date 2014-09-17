--[[

     MB AWM Theme based on
     Holo Awesome WM config 2.0
     github.com/copycat-killer

--]]

-- {{{ Required libraries
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local drop      = require("scratchdrop")
local lain      = require("lain")
--local vicious = require("vicious")

-- beautiful init
beautiful.init(awful.util.getdir("config") .. "/themes/current/theme.lua")

naughty.config.presets.normal = {
  bg = beautiful.fg_urgent,
  fg = beautiful.fg_normal,
  timeout = 10
}
naughty.config.presets.low = {
  bg = beautiful.fg_urgent,
  fg = beautiful.fg_normal,
  timeout = 10
}
naughty.config.presets.critical = {
  bg = beautiful.alarm,
  fg = beautiful.fg_normal,
  timeout = 10
}
-- }}}

-- {{{ Error handling
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
                         title = "AWM Critical Error",
                         text = err })
        in_error = false
    end)
end

--- Pads str to length len with char from right
str_pad = function(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str) .. str
end

function linkInfo(adapter)
  local f = io.open("/sys/class/net/"..adapter.."/carrier", "r")
  if f~=nil then
    state = f:read()
    if state == "1" then
      connection = beautiful.highlight
    else
      connection = beautiful.dim
    end
    io.close(f)
  else
    connection = beautiful.dim
  end
  return connection
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

--run_once("urxvtd")
--run_once("dex -a -e Awesome")
--run_once("conky")
--run_once("mpd")
--run_once("unclutter")
-- }}}

-- {{{ Variable definitions
-- localization
--os.setlocale(os.getenv("LANG"))



-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "urxvtc" or "xterm"
editor     = os.getenv("EDITOR") or "vim" or "vi"
editor_cmd = terminal .. " -e " .. editor

-- user defined
browser    = "firefox"
filemgr    = terminal .. " -e ranger "
gui_editor = "gvim"
graphics   = "gimp"
musicplr   = terminal .. " -e ncmpcpp "
mixer_term = terminal .. " -e alsamixer -c 0"
mixer_gui  = "pavucontrol"
python_iterperetor = terminal .. " -e ipython "

local layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
}
-- }}}


-- {{{ functions to help launch run commands in a terminal using ":" keyword
-- {{{ functions to help launch run commands in a terminal using ":" keyword
function check_for_terminal (command)
   if command:sub(1,1) == ":" then
      command = terminal .. ' -e "' .. command:sub(2) .. '"'
   end
   awful.util.spawn(command)
end

function clean_for_completion (command, cur_pos, ncomp, shell)
   local term = false
   if command:sub(1,1) == ":" then
      term = true
      command = command:sub(2)
      cur_pos = cur_pos - 1
   end
   command, cur_pos =  awful.completion.shell(command, cur_pos,ncomp,shell)
   if term == true then
      command = ':' .. command
      cur_pos = cur_pos + 1
   end
   return command, cur_pos
end
-- }}}
function check_for_terminal (command)
   if command:sub(1,1) == ":" then
      command = terminal .. ' -e "' .. command:sub(2) .. '"'
   end
   awful.util.spawn(command)
end

function clean_for_completion (command, cur_pos, ncomp, shell)
   local term = false
   if command:sub(1,1) == ":" then
      term = true
      command = command:sub(2)
      cur_pos = cur_pos - 1
   end
   command, cur_pos =  awful.completion.shell(command, cur_pos,ncomp,shell)
   if term == true then
      command = ':' .. command
      cur_pos = cur_pos + 1
   end
   return command, cur_pos
end
-- }}}

-- {{{ Conky

function get_conky()
    local clients = client.get()
    local conky = nil
    local i = 1
    while clients[i]
    do
        if clients[i].class == "Conky"
        then
            conky = clients[i]
        end
        i = i + 1
    end
    return conky
end
function raise_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = true
    end
end
function lower_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = false
    end
end
function toggle_conky()
    local conky = get_conky()
    if conky
    then
        if conky.ontop
        then
            conky.ontop = false
        else
            conky.ontop = true
        end
    end
end

-- }}}

-- {{{ Tags
tags = {
  names = {
    " 1 ",
    " 2 ",
    " 3 ",
    " 4 ",
    " 5 ",
    " 6 ",
    " 7 ",
    " 8 ",
    " 9 "
  },
  layout = {
    layouts[1],
    layouts[1],
    layouts[1],
    layouts[1],
    layouts[1],
    layouts[1],
    layouts[1],
    layouts[1],
    layouts[1]
  }
}
for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Menu
require("freedesktop/freedesktop")
-- }}}

-- {{{ Wibox
markup = lain.util.markup
blue   = beautiful.highlight

-- Menu icon
awesome_icon = wibox.widget.imagebox()
awesome_icon:set_image(beautiful.awesome_icon)
awesome_icon:buttons(
    awful.util.table.join( awful.button(
        { }, 1, function() mymainmenu:toggle() end)))

-- Clock
mytextclock = awful.widget.textclock(
    markup(beautiful.fg_normal, " %H:%M %a"), 2)
clock_icon = wibox.widget.imagebox()
clock_icon:set_image(beautiful.clock)
clockwidget = wibox.widget.background()
clockwidget:set_widget(mytextclock)
clockwidget:set_bgimage(beautiful.widget_bg)

-- Calendar
mytextcalendar = awful.widget.textclock(
    markup(beautiful.fg_normal, " %Y-%m-%d <span></span>"))
calendar_icon = wibox.widget.imagebox()
calendar_icon:set_image(beautiful.calendar)
calendarwidget = wibox.widget.background()
calendarwidget:set_widget(mytextcalendar)
calendarwidget:set_bgimage(beautiful.widget_bg)
lain.widgets.calendar:attach(
    calendarwidget,
        {fg = beautiful.fg_normal,
         font = beautiful.font_no_size,
         font_size = "10",
         position = "top_right" })

--[[ Mail IMAP check
-- commented because it needs to be set before use
mailwidget = lain.widgets.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        mail_notification_preset.fg = white
        mail  = ""
        count = ""

        if mailcount > 0 then
            mail = "Arch "
            count = mailcount .. " "
        end

        widget:set_markup(markup(gray, mail) .. markup(white, count))
    end
})
]]

-- MPD
mpd_icon = wibox.widget.imagebox()
mpd_icon:set_image(beautiful.mpd)
prev_icon = wibox.widget.imagebox()
prev_icon:set_image(beautiful.prev)
next_icon = wibox.widget.imagebox()
next_icon:set_image(beautiful.nex)
stop_icon = wibox.widget.imagebox()
stop_icon:set_image(beautiful.stop)
pause_icon = wibox.widget.imagebox()
pause_icon:set_image(beautiful.pause)
play_pause_icon = wibox.widget.imagebox()
play_pause_icon:set_image(beautiful.play)

mpdwidget = lain.widgets.mpd({
    settings = function ()
        if mpd_now.state == "play" then
            --mpd_now.artist = mpd_now.artist:upper():gsub("&.-;", string.lower)
            --mpd_now.title = mpd_now.title:upper():gsub("&.-;", string.lower)
            widget:set_markup(
                " " .. mpd_now.artist .. " - " .. mpd_now.title .. " ")
            play_pause_icon:set_image(beautiful.pause)
        elseif mpd_now.state == "pause" then
            widget:set_markup(" MPD PAUSED ")
            play_pause_icon:set_image(beautiful.play)
        else
            widget:set_markup(" ")
            play_pause_icon:set_image(beautiful.play)
        end

        mpd_notification_preset = {
          title = "Now Playing:",
          fg = beautiful.fg_normal,
          bg = beautiful.bg_normal,
          timeout = 6,
          text = string.format("%s\n%s (%s)",
              mpd_now.title, mpd_now.artist, mpd_now.album, mpd_now.date)
        }
    end
})

musicwidget = wibox.widget.background()
musicwidget:set_widget(mpdwidget)
musicwidget:set_bgimage(beautiful.widget_bg)
musicwidget:buttons(
  awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)
    )
)
mpd_icon:buttons(
  awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)
  )
)

-- CPU/Memory Usage
cpuwidget = lain.widgets.cpu({
    settings = function()
        widget:set_markup(markup(beautiful.highlight, " CPU ") .. str_pad(cpu_now.usage, 3) .. "% ")
    end
})
cpu_widget = wibox.widget.background()
cpu_widget:set_widget(cpuwidget)
cpu_widget:set_bgimage(beautiful.widget_bg)
cpu_icon = wibox.widget.imagebox()
cpu_icon:set_image(beautiful.cpu)

memwidget = lain.widgets.mem({
    settings = function()
        widget:set_markup(markup(beautiful.highlight, " RAM ") .. string.format("%3i", 100 * mem_now.used / 7849.) .. "% ")
    end
})
mem_widget = wibox.widget.background()
mem_widget:set_widget(memwidget)
mem_widget:set_bgimage(beautiful.widget_bg)
mem_icon = wibox.widget.imagebox()
mem_icon:set_image(beautiful.mem)

-- Battery
batt_status = lain.widgets.bat({
    settings = function()
        bat_header = "Batt "
        bat_value_color = beautiful.fg_normal
        notify = "on"
        if tonumber(bat_now.perc) <= 15 then
          bat_value_color = beautiful.fg_urgent
        elseif tonumber(bat_now.perc) <= 5 then
          bat_value_color = beautiful.alarm
        end
        bat_p      = bat_now.perc .. "-"

        if bat_now.status == "Charging" then
            bat_header = "Line "
            bat_p      = bat_now.perc .. "+"
            notify = "off"
        elseif bat_now.status == "Unknown" then
          bat_header = "Line "
          bat_p      = bat_now.perc .. "-"
          notify = "off"
        end

        bat_notification_low_preset = {
          title = "Low Battery Warning",
          text = "Connect to external power soon.",
          timeout = 5,
          fg = beautiful.fg_normal,
          bg = beautiful.fg_urgent
        }
        bat_notification_critical_preset = {
          title = "Critical Battery Warning",
          text = "Battery depleted; shutdown imminent!",
          timeout = 15,
          fg = beautiful.fg_normal,
          bg = beautiful.alarm
        }


        widget:set_markup(
            " " ..
            markup(blue, bat_header) ..
            markup(bat_value_color, bat_p) ..
            " "
        )
    end
})
batt_widget = wibox.widget.background()
batt_widget:set_widget(batt_status)
batt_widget:set_bgimage(beautiful.widget_bg)


sound_level_widget = lain.widgets.alsa({
    settings = function()
        header = " Vol "
        vlevel  = volume_now.level
        vol_color = beautiful.fg_normal

        if volume_now.status == "off" then
            vlevel = "M" .. str_pad(vlevel, 3)
            vol_color = beautiful.dim
        else
            vlevel = " " .. str_pad(vlevel, 3)
        end

        widget:set_markup(markup(beautiful.highlight, header) .. markup(vol_color, vlevel .. "%") .. " ")
    end
})
volumewidget = wibox.widget.background()
volumewidget:set_widget(sound_level_widget)
volumewidget:set_bgimage(beautiful.widget_bg)

volumewidget:buttons(
    awful.util.table.join(
        awful.button({ }, 1, function () awful.util.spawn_with_shell(mixer_term) end),
        awful.button({ }, 3, function () awful.util.spawn(mixer_gui) end)
    )
)

-- Network Widgets
wifi_status = wibox.widget.textbox()
wifi_status:set_text(" Wifi")
wired_status = wibox.widget.textbox()
wired_status:set_text(" Wired")
vpn_status = wibox.widget.textbox()
vpn_status:set_text(" VPN ")
net_timer = timer({ timeout = 5 })
net_timer:connect_signal("timeout",
    function()
      wifi_status:set_markup(markup(linkInfo("wlp3s0"), " Wifi"))
    end)
net_timer:connect_signal("timeout",
    function()
      wired_status:set_markup(markup(linkInfo("enp0s25"), " Wired"))
    end)
net_timer:connect_signal("timeout",
    function()
      vpn_status:set_markup(markup(linkInfo("tun0"), " VPN "))
    end)
net_timer:start()


wifi_widget = wibox.widget.background()
wifi_widget:set_widget(wifi_status)
wifi_widget:set_bgimage(beautiful.widget_bg)
wired_widget = wibox.widget.background()
wired_widget:set_widget(wired_status)
wired_widget:set_bgimage(beautiful.widget_bg)
vpn_widget = wibox.widget.background()
vpn_widget:set_widget(vpn_status)
vpn_widget:set_bgimage(beautiful.widget_bg)

-- Separators
first = wibox.widget.textbox('<span> </span>')
last = wibox.widget.imagebox()
last:set_image(beautiful.last)
spr = wibox.widget.imagebox()
spr:set_image(beautiful.spr)
spr_small = wibox.widget.imagebox()
spr_small:set_image(beautiful.spr_small)
spr_very_small = wibox.widget.imagebox()
spr_very_small:set_image(beautiful.spr_very_small)
spr_right = wibox.widget.imagebox()
spr_right:set_image(beautiful.spr_right)
spr_bottom_right = wibox.widget.imagebox()
spr_bottom_right:set_image(beautiful.spr_bottom_right)
spr_left = wibox.widget.imagebox()
spr_left:set_image(beautiful.spr_left)
bar = wibox.widget.textbox("<span font='Devavu Sans Mono 8'> </span>")
bottom_bar = wibox.widget.imagebox()
bottom_bar:set_image(beautiful.bottom_bar)

-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 32 })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout:add(first)
    -- left_layout:add(awesome_icon)
    left_layout:add(mytaglist[s])
    --left_layout:add(spr)
    left_layout:add(mylayoutbox[s])
    --left_layout:add(spr)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the upper right
    local right_layout = wibox.layout.fixed.horizontal()
    -- right_layout:add(mailwidget)
    right_layout:add(spr_right)
    right_layout:add(mpd_icon)
    right_layout:add(musicwidget)
    right_layout:add(bar)
    right_layout:add(volumewidget)
    right_layout:add(bar)
    right_layout:add(cpu_widget)
    right_layout:add(bar)
    right_layout:add(mem_widget)
    right_layout:add(bar)
    right_layout:add(wifi_widget)
    right_layout:add(wired_widget)
    right_layout:add(vpn_widget)
    right_layout:add(bar)
    right_layout:add(batt_widget)
    right_layout:add(bar)
    right_layout:add(calendar_icon)
    right_layout:add(calendarwidget)
    right_layout:add(clock_icon)
    right_layout:add(clockwidget)
    right_layout:add(spr_left)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    -- Create the bottom wibox
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 22 })

    -- Widgets that are aligned to the bottom left
    bottom_left_layout = wibox.layout.fixed.horizontal()

    -- Widgets that are aligned to the bottom right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then bottom_right_layout:add(wibox.widget.systray()) end
    --
    --

    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)

    -- Set proper backgrounds, instead of beautiful.bg_normal
    mywibox[s]:set_bg("#242424")
    mybottomwibox[s]:set_bg("#242424")

    -- Create a borderbox above the bottomwibox
    lain.widgets.borderbox(mybottomwibox[s], s, { position = "top", color = "#0099CC" } )
end
-- }}}

-- {{{ Title Bars

-- mytitlebar = awful.titlebar({position = "top"})

--mytitlebartitle = wibox.widget({type = "textbox", name = "mytitlebartitle" })
--mytitlebar:widgets({ mytitlebartitle })

-- c = client.focus
-- c.titlebar = mytitlebar

-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Take a screenshot
    -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
    -- awful.key({ altkey }, "p", function() os.execute("screenshot") end),

    -- Tag browsing
    awful.key({ modkey }, "j",   awful.tag.viewprev       ),
    awful.key({ modkey }, "l",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Non-empty tag browsing
    awful.key({ modkey, altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
    awful.key({ modkey, altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

    -- Default client focus
    awful.key({ modkey }, "F10", raise_conky, lower_conky),
    awful.key({ modkey }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "i",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    --[[ By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),
    --]]
 awful.key({ modkey, "Shift"   }, "j",
   function (c)
       local curidx = awful.tag.getidx()
       if curidx == 1 then
           awful.client.movetotag(tags[client.focus.screen][9])
       else
           awful.client.movetotag(tags[client.focus.screen][curidx - 1])
       end
       awful.tag.viewprev()
   end),
 awful.key({ modkey, "Shift"   }, "l",
   function (c)
       local curidx = awful.tag.getidx()
       if curidx == 9 then
           awful.client.movetotag(tags[client.focus.screen][1])
       else
           awful.client.movetotag(tags[client.focus.screen][curidx + 1])
       end
       awful.tag.viewnext()
   end),

    -- Show Menu
    awful.key({ modkey }, "w",
        function ()
            mymainmenu:show({ keygrabber = true })
        end),

    -- Show/Hide Wibox
    awful.key({ modkey, altkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
        mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible
    end),

    -- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end),

    -- Layout manipulation
    awful.key({ modkey,         }, "o", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift" }, "O", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Shift" }, "L", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Shift" }, "J", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,         }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,         }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ modkey, altkey }, "l",      function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ modkey, altkey }, "j",      function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey,         }, "m",      function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Shift" }, "m",      function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey,         }, "c",      function () awful.tag.incncol( 1)          end),
    awful.key({ modkey, "Shift" }, "c",      function () awful.tag.incncol(-1)          end),
    awful.key({ modkey,         }, "space",  function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift" }, "space",  function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Shift" }, "h",      awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    -- Dropdown terminal
    awful.key({ modkey,	          }, "`",      function () drop(terminal) end),

    -- Widgets popups
    awful.key({ altkey,           }, "c",      function () lain.widgets.calendar:show(7) end),
    awful.key({ altkey,           }, "w",      function () yawn.show(7) end),

    -- Battery Levels
    -- TODO: NEEDS SUDO PROMPT
    --awful.key({},"XF86Battery",
    --    function ()
    --        awful.util.spawn("set_battery_thresholds")
    --    end),

    -- ALSA volume control
    awful.key({ altkey }, "Up",
        function ()
            awful.util.spawn("amixer -q set Master 1%+")
            sound_level_widget.update()
        end),
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            awful.util.spawn("amixer -q set Master 4.0%+")
            sound_level_widget.update()
        end),
    awful.key({ altkey }, "Down",
        function ()
            awful.util.spawn("amixer -q set Master 1%-")
            sound_level_widget.update()
        end),
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            awful.util.spawn("amixer -q set Master 4.0%-")
            sound_level_widget.update()
        end),
    awful.key({ altkey }, "m",
        function ()
            awful.util.spawn("amixer -q set Master playback toggle")
            sound_level_widget.update()
        end),
    awful.key({ }, "XF86AudioMute",
        function ()
            awful.util.spawn("amixer -q set Master toggle")
            sound_level_widget.update()
        end),
    awful.key({ altkey, "Control" }, "m",
        function ()
            awful.util.spawn("amixer -q set Master playback 100%")
            sound_level_widget.update()
        end),

    -- CDROM lock
    awful.key({modkey, }, "XF86Forward",
        function ()
            awful.util.spawn_with_shell("eject -i on /dev/sr0")
        end),
    awful.key({modkey, "Shift"}, "XF86Forward",
        function ()
            awful.util.spawn_with_shell("eject -i off /dev/sr0")
        end),

    -- MPD control
    awful.key({}, "XF86AudioPlay",
        function ()
            awful.util.spawn_with_shell("mpc toggle || ncmpcpp toggle || ncmpc toggle || pms toggle")
            mpdwidget.update()
        end),
    awful.key({}, "XF86AudioStop",
        function ()
            awful.util.spawn_with_shell("mpc stop || ncmpcpp stop || ncmpc stop || pms stop")
            mpdwidget.update()
        end),
    awful.key({}, "XF86AudioPrev",
        function ()
            awful.util.spawn_with_shell("mpc prev || ncmpcpp prev || ncmpc prev || pms prev")
            mpdwidget.update()
        end),
    awful.key({}, "XF86AudioNext",
        function ()
            awful.util.spawn_with_shell("mpc next || ncmpcpp next || ncmpc next || pms next")
            mpdwidget.update()
        end),

    -- Copy to clipboard
    awful.key({ modkey, "Control" }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs
    awful.key({ modkey, }, "b", function () awful.util.spawn(browser) end),
    awful.key({ modkey, }, "d", function () awful.util.spawn_with_shell(filemgr) end),
    awful.key({ modkey, }, "e", function () awful.util.spawn(gui_editor) end),
    awful.key({ modkey, "Control" }, "l", function () awful.util.spawn("sexlock") end),
    awful.key({ modkey, }, "p", function () awful.util.spawn(python_iterperetor) end),
    --awful.key({ modkey, }, "g", function () awful.util.spawn(graphics) end),
    awful.key({ modkey, }, "F2", function () awful.util.spawn_with_shell("eject -i on /dev/sr0") end),
    awful.key({ modkey, "Shift" }, "F2", function () awful.util.spawn_with_shell("eject -i off /dev/sr0") end),


    -- Prompt
    awful.key({ modkey }, "r",
        function ()
            awful.prompt.run({prompt = "Run "},
              mypromptbox[mouse.screen].widget,
              check_for_terminal,
              clean_for_completion,
              awful.util.getdir("cache") .. "/history")
        end
    ),
    awful.key({ modkey }, "x",
      function ()
          awful.prompt.run({ prompt = "Run Lua code: " },
          mypromptbox[mouse.screen].widget,
          awful.util.eval, nil,
          awful.util.getdir("cache") .. "/history_eval")
      end
    )
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",               function (c) c.sticky = not c.sticky end),
    awful.key({ modkey, "Shift"   }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, altkey }, "m", function (c) c:swap(awful.client.getmaster()) end),
    -- awful.key({ modkey,           }, "s",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "h",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey, }, "f",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end)
   --[[ awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end) --]]
                  )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false,
                     callback = awful.client.setslave } },
    { rule = { class = "URxvt" },
          properties = { opacity = 0.99 } },

    { rule = { class = "MPlayer" },
          properties = { floating = true } },

    { rule = { class = "Conky" },
      properties = {
          floating = true,
          sticky = true,
          ontop = false,
          focusable = false,
          size_hints = {"program_position", "program_size"}
      } },

--[[    { rule = { class = "Dwb" },
          properties = { tag = tags[1][1] } },

    { rule = { class = "Iron" },
          properties = { tag = tags[1][1] } },
--]]
    { rule = { instance = "plugin-container" },
          properties = { floating = true,
                         tag = tags[1][1] } },
    { rule = { name = "dwb", icon_name="dwb", size_hints = {
      "program specified location: 0, 0",
      "program specified minimum size: 0 by 0",
      "window gravity: NorthWest",} },
          properties = { floating = true,} },
    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized_horizontal = true,
                         maximized_vertical = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup and not c.size_hints.user_position
       and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_width = 0
            c.border_color = beautiful.border_normal
        else
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                    awful.client.moveresize(0, 0, 2, 2, clients[1])
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}
