local awful = require("awful")
local keydoc = require("keydoc")

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
-- {{{ Key bindings
globalkeys = awful.util.table.join(
    keydoc.group("Std"),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       , "Prev tag"),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       , "Next tag"),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore, "Prev history tag"),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
        end, "Next window"),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end, "Prev window"),
    awful.key({ modkey, "Shift"   }, "j",
        function () awful.client.swap.byidx(  1)    end, "Swap active windows to next"),
    awful.key({ modkey, "Shift"   }, "k",
        function () awful.client.swap.byidx( -1)    end, "Swap active windows to prev"),
    awful.key({ modkey, "Control" }, "j",
        function () awful.screen.focus_relative( 1) end, "Next screen"),
    awful.key({ modkey, "Control" }, "k",
        function () awful.screen.focus_relative(-1) end, "Prev screen"),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto, "Jump to urgent windows"),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end, "Jump to prev history window"),

    awful.key({ modkey,           }, "Return",
        function () awful.util.spawn(terminal) end, "Start terminal"),
    awful.key({ modkey, "Control" }, "r", awesome.restart, "Restart awesome"),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit, "Quit awesome"),

    awful.key({ modkey,           }, "l",
        function () awful.tag.incmwfact( 0.05)    end, "Inc master part"),
    awful.key({ modkey,           }, "h",
        function () awful.tag.incmwfact(-0.05)    end, "Dec master part"),
    awful.key({ modkey, "Shift"   }, "h",
        function () awful.tag.incnmaster( 1)      end, "Inc master windows"),
    awful.key({ modkey, "Shift"   }, "l",
        function () awful.tag.incnmaster(-1)      end, "Dec master windows"),
    awful.key({ modkey, "Control" }, "h",
        function () awful.tag.incncol( 1)         end, "Inc slave column"),
    awful.key({ modkey, "Control" }, "l",
        function () awful.tag.incncol(-1)         end, "Dec slave column"),
    awful.key({ modkey,           }, "space",
        function () awful.layout.inc(layouts,  1) end, "Change to next layout"),
    awful.key({ modkey, "Shift"   }, "space",
        function () awful.layout.inc(layouts, -1) end, "Change to prev layout"),

    awful.key({ modkey,           }, "Next",
        function () awful.client.moveresize( 0, 20, 0, -20) end),
    awful.key({ modkey,           }, "Prior",
        function () awful.client.moveresize( 0, -20, 0, 20) end),
    awful.key({ modkey,           }, "End",
        function () awful.client.moveresize( 20,  0, -20, 0) end),
    awful.key({ modkey,           }, "Home",
        function () awful.client.moveresize(-20, 0, 20, 0) end),
    awful.key({ modkey, "Shift"   }, "Down",
        function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Up",
        function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Left",
        function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Right",
        function () awful.client.moveresize( 20,   0,   0,   0) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore, "Window unhide"),

    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end, "Run lua code")
)

clientkeys = awful.util.table.join(
    keydoc.group("Client"),
    awful.key({ modkey,           }, "f",
        function (c) c.fullscreen = not c.fullscreen  end, "Fullscreen window"),
    awful.key({ modkey, "Shift"   }, "c",
        function (c) c:kill()                         end, "Kill window"),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle, "Float window"),
    awful.key({ modkey, "Control" }, "Return",
        function (c) c:swap(awful.client.getmaster()) end, "Activate master window"),
    awful.key({ modkey,           }, "o", awful.client.movetoscreen, "Move active window to another screen"),
    awful.key({ modkey,           }, "t",
        function (c) c.ontop = not c.ontop            end, "Window ontop"),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end, "Hide window"),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end, "Maximazed window")
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
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
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

require("userbind")
