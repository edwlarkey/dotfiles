local beautiful = require("beautiful")
-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mysystemmenu = {
  { "reboot", "zsh -c -i 'sudo shutdown -r now'" },
  { "shutdown", "zsh -c -i 'sudo shutdown -h now'"}
}

mymainmenu = awful.menu({ items = { 
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "chromium", "chromium"},
    { "hipchat", "hipchat"},
    { "spotify", "spotify"},
    { "open terminal", terminal },
    { "system", mysystemmenu }

}

})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu })
-- }}}

awful.menu.menu_keys = { up    = { "k", "Up" },
                         down  = { "j", "Down" },
                         exec  = { "l", "Return", "Right" },
                         enter = { "Right" },
                         back  = { "h", "Left" },
                         close = { "q", "Escape" },
                       }
