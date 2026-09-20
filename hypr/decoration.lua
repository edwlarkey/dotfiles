hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 5,
    col = {
      active_border = "rgb(cccccc)",
      inactive_border = "rgb(888888)",
    },
    resize_on_border = true,
    allow_tearing = false,
    layout = "scrolling",
  },
  scrolling = {
    fullscreen_on_one_column = true,
    column_width = 0.9,
    direction = "right",
  },
  decoration = {
    rounding = 0,
    inactive_opacity = 0.75,
    shadow = {
      enabled = true,
      range = 2,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },
  animations = {
    enabled = true,
  },
  dwindle = {
    preserve_split = true,
    force_split = 2,
  },
  master = {
    new_status = "master",
  },
  misc = {
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
    disable_splash_rendering = true,
    focus_on_activate = true,
  },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = false, speed = 0, bezier = "ease" })

--
-- hyprbars
--
-- hl.config({
--   plugin = {
--     hyprbars = {
--       -- Matches the real height in the screenshot
--       bar_height = 25,
--
--       -- Soft Platinum gray from the screenshot
--       bar_color = "rgb(d4d4d4)",
--
--       -- Title styling
--       col = {
--         text = "rgb(000000)",
--       },
--       bar_text_size = 15,
--       bar_text_font = "ChicagoFLF", -- Chicago / Charcoal looks best
--       bar_text_align = "center",
--       bar_title_enabled = true,
--
--       -- Classic Mac layout
--       bar_buttons_alignment = "left",
--
--       bar_part_of_window = true,
--       bar_blur = false,
--
--       -- Double-click title bar = zoom
--       on_double_click = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
--     },
--   },
-- })
--
-- -- Close box (left) – small empty square like the real one
-- hl.plugin.hyprbars.add_button({
--   bg_color = "rgb(e8e8e8)",
--   fg_color = "rgb(000000)",
--   size = 20,
--   icon = "□",
--   action = "hyprctl dispatch 'hl.dsp.window.close()'",
-- })
--
-- -- Zoom box (right) – classic box-within-a-box
-- hl.plugin.hyprbars.add_button({
--   bg_color = "rgb(e8e8e8)",
--   fg_color = "rgb(000000)",
--   size = 20,
--   icon = "▢",
--   action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
-- })
