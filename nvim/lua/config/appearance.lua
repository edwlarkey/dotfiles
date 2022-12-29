local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local scheme = "gruvbox"

if file_exists(os.getenv( "HOME" ).."/light") then
  vim.o.background = "light"
  scheme = "everforest"
else
  vim.o.background = "dark"
end


if scheme == "everforest" then
  vim.g.everforest_background = 'soft'
  vim.g.everforest_enable_italic = 1
  vim.g.everforest_sign_column_background = 'grey'
  vim.g.everforest_ui_contrast = 'low'
  vim.g.everforest_better_performance = 1
  vim.cmd[[colorscheme everforest]]
elseif scheme == "gruvbox" then
  vim.g.gruvbox_material_foreground = 'original'
  vim.g.gruvbox_material_background = 'soft'
  vim.g.gruvbox_material_sign_column_background = 'grey'
  vim.g.gruvbox_material_better_performance = 1
  vim.cmd[[colorscheme gruvbox]]
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
end
