vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("edwlarkey.lazy")
require("edwlarkey.options")
require("edwlarkey.commands")
require("edwlarkey.filetype")
require("edwlarkey.keymaps").setup.regular()
require("edwlarkey.textcal")
