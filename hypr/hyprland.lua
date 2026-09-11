pcall(dofile, os.getenv("HOME") .. "/.local.monitors.lua")

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("mako")
  -- hl.exec_cmd("waybar")
  hl.exec_cmd("quickshell")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
  ecosystem = {
    no_update_news = true,
  },
  input = {
    kb_layout = "us",
    kb_options = "ctrl:nocaps",
    kb_rules = "",
    kb_variant = "",
    kb_model = "",
    repeat_delay = 200,
    repeat_rate = 40,
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
    },
  },
  cursor = {
    no_hardware_cursors = 1,
  },
  gestures = {
    workspace_swipe_create_new = false,
    workspace_swipe_distance = 200,
  },
})

hl.device({
  name = "logitech-ergo-m575",
  scroll_method = "on_button_down",
  scroll_button = 276,
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

require("bindings")
require("decoration")
require("windows")
