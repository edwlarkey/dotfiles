vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("edwlarkey.lazy")
require("edwlarkey.options")
require("edwlarkey.commands")
require("edwlarkey.filetype")
require("edwlarkey.lsp")
require("edwlarkey.keymaps").setup.regular()
require("edwlarkey.textcal")
