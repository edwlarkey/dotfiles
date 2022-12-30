require("config.options")
require("config.commands")
require("config.lazy")
require("config.keymaps").setup.regular()
require("config.cheatsheet")

vim.cmd([[source ~/.config/nvim/oldinit.vim]])
