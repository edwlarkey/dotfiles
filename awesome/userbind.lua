local awful = require("awful")

-- {{{ Key bindings
globalkeys = awful.util.table.join(globalkeys,
    keydoc.group("Userbind"),
    awful.key({ "Control", "Shift"}, "c", function() awful.util.spawn("chromium") end),
    awful.key({ "Control", "Shift"}, "h", function() awful.util.spawn("hipchat") end),
    awful.key({ "Control", "Shift"}, "s", function() awful.util.spawn("spotify") end),

-- Volume control
    awful.key({ "Control" }, "Up", function ()
                                       awful.util.spawn("amixer set Master playback 5%+", false )
                                       vicious.force({ volumewidget })
                                   end),
    awful.key({ "Control" }, "Down", function ()
                                       awful.util.spawn("amixer set Master playback 5%-", false )
                                       vicious.force({ volumewidget })
                                     end),
    awful.key({ "Control" }, "m", function ()
                                       awful.util.spawn("amixer set Master playback toggle", false )
                                       vicious.force({ volumewidget })
                                     end)
)
-- }}}
