local function cheatsheet()
  require("plenary.popup").create({
    "gD         - Go to Declaration",
    "gd         - Show Definition",
    "K          - Hover",
    "gI         - Implementation",
    "gr         - References",
    "gl         - Open Float",
    "<leader>D  - Go to type definition",
    "<leader>lf - Format",
    "<leader>tf - Toggle Autoformat",
    "<leader>la - Code Action",
    "]d - Go to next diagnostic",
    "[d - Go to previous diagnostic",
    "<leader>cr - Refresh code lens",
    "<leader>cl - Run code lens",
    "<leader>lr - Rename",
    "<leader>ls - Show signature",
    "<leader>lq - Set loclist",
    "<leader>hb - Blame",
    "<leader>hB - Blame Full",
    "<leader>hD - Diff This ~",
    "<leader>hD - Diff This",
    "<leader>hp - Preview Hunk",
  }, {
    border = true,
    pos = "center",
    title = "Cheatsheet",
    line = 0,
    col = 0,
    minwidth = 50,
    minheight = 1,
    time = 5000,
  })
end

vim.api.nvim_create_user_command("Cheatsheet", cheatsheet, { nargs = 0 })

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "gh", "<cmd> Cheatsheet<CR>", opts)
