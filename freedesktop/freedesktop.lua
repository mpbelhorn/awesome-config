-- This is an usage example
-- Modify according to your preferences

-- If you are a Debian user, you can also uncomment the two lines that insert
-- the Debian menu together with the rest of the items (11 and 33).

local awful     = require("awful")
local beautiful = require("beautiful")

require('freedesktop')
-- require("debian.menu")

freedesktop.utils.terminal   = terminal -- defined in rc.lua, otherwise define it here (default: "xterm")
freedesktop.utils.icon_theme = 'gnome'  -- choose your favourite from /usr/share/icons/ (default: nil)

menu_items = freedesktop.menu.new()

myawesomemenu = {
 { "Manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
 { "Configuration", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua", freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
 { "Restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'gtk-refresh' }) },
 { "Switch User", awful.util.spawn_with_shell('dm-tool switch-to-greeter'), freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) },
 { "Quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) },
}


for s = 1, screen.count() do
    --freedesktop.desktop.add_application_icons({screen = s, showlabels = true})
    --freedesktop.desktop.add_dirs_and_file_icons({screen = s, showlabels = true})
    freedesktop.desktop.add_desktop_icons({screen = s, showlabels = true})
end

table.insert(menu_items, { "Awesome", myawesomemenu, beautiful.awesome_icon })
table.insert(menu_items, { "Terminal", terminal, freedesktop.utils.lookup_icon({icon = 'terminal'}) })
-- table.insert(menu_items, { "Debian", debian.menu.Debian_menu.Debian, freedesktop.utils.lookup_icon({ icon = 'debian-logo' }) })

mymainmenu = awful.menu.new({ items = menu_items, theme = { width = 150 } })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
