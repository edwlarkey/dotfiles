local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

if file_exists(os.getenv("HOME") .. "/light") then
  config.color_scheme = "OneHalfLight"
else
  config.color_scheme = "Gruvbox dark, medium (base16)"
end

config.enable_tab_bar = false
config.scrollback_lines = 10000

-- config.font = wezterm.font("Hack Nerd Font Mono")
config.font = wezterm.font("BlexMono Nerd Font", { weight = "Medium" })
-- config.font = wezterm.font("IntoneMono Nerd Font")
config.font_size = 16

return config
