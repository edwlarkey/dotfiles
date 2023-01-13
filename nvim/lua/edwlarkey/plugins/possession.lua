return {
  "gennaro-tedesco/nvim-possession",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  opts = {
    sessions = {
      sessions_path = vim.fn.stdpath("data") .. "/session/",
      sessions_variable = "session",
      sessions_icon = "📌",
    },
    fzf_winopts = {
      hl = { normal = "Normal" },
      border = "rounded",
      height = 0.5,
      width = 0.25,
      preview = {
        horizontal = "down:40%",
      },
    },
  },
}
