hl.window_rule({
  name = "windowrule-1",
  suppress_event = "maximize",
  opacity = "0.97 0.9",
  match = { class = ".*" }
})

hl.window_rule({
  name = "windowrule-2",
  no_focus = true,
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }
})

hl.window_rule({
  name = "windowrule-3",
  tag = "+chromium-based-browser",
  match = { class = "([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)" }
})

hl.window_rule({
  name = "windowrule-4",
  tag = "+firefox-based-browser",
  match = { class = "(Firefox|zen|librewolf)" }
})

hl.window_rule({
  name = "windowrule-5",
  tile = true,
  opacity = "1 0.97",
  match = { tag = "chromium-based-browser" }
})

hl.window_rule({
  name = "windowrule-6",
  opacity = "1 0.97",
  match = { tag = "firefox-based-browser" }
})

hl.window_rule({
  name = "windowrule-7",
  opacity = "1.0 1.0",
  match = { initial_title = "(youtube\\.com_/|app\\.zoom\\.us_/wc/home)" }
})

hl.window_rule({
  name = "windowrule-8",
  float = true,
  opacity = "1 1",
  idle_inhibit = "fullscreen",
  match = { class = "steam" }
})

hl.window_rule({
  name = "windowrule-9",
  center = true,
  size = "1100 700",
  match = { class = "steam", title = "Steam" }
})

hl.window_rule({
  name = "windowrule-10",
  size = "460 800",
  match = { class = "steam", title = "Friends List" }
})

hl.window_rule({
  name = "windowrule-11",
  float = true,
  match = { class = "pavucontrol" }
})

hl.window_rule({
  name = "windowrule-12",
  float = true,
  match = { class = "mpv" }
})

hl.window_rule({
  no_dim = true,
  no_shadow = true,
  opacity = "1.0 override",
  match = { class = "mpv" }
})

hl.window_rule({
  name = "ghostty-workspace",
  workspace = "2",
  match = { class = "com\\.mitchellh\\.ghostty" }
})

hl.window_rule({
  name = "obsidian-workspace",
  workspace = "3",
  match = { class = "obsidian" }
})

hl.window_rule({
  name = "thunar-workspace",
  workspace = "5",
  float = true,
  center = true,
  size = "1200 800",
  match = { class = "thunar" }
})
