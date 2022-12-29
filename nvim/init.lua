vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.lazy")
require("config.options")
require("config.appearance")
require("config.keymaps").setup.regular()
-- require("config.lsp")
require("config.cheatsheet")

vim.cmd [[source ~/.config/nvim/oldinit.vim]]
