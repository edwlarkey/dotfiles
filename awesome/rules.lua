local awful = require("awful")
awful.rules = require("awful.rules")
local beautiful = require("beautiful")

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          keys = clientkeys,
          buttons = none} },
      -- For browser
    { rule_any = { class = {"Iceweasel", "Chromium", "Firefox"} },
      properties = { tag = tags[1][1] } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "HipChat" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Spotify" },
      properties = { tag = tags[1][9] } },

}
-- }}}

