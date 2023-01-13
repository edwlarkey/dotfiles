vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("edwlarkey.lazy")
require("edwlarkey.options")
require("edwlarkey.commands")
require("edwlarkey.keymaps").setup.regular()
require("edwlarkey.cheatsheet")

-- vim.cmd([[source ~/.config/nvim/oldinit.vim]])
