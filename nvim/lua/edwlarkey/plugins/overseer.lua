local M = {
  "stevearc/overseer.nvim",
  dependencies = { "ibhagwan/fzf-lua", "stevearc/dressing.nvim" },
  opts = {
    component_aliases = {
      default = {
        { "display_duration", detail_level = 2 },
        "on_output_summarize",
        "on_exit_set_status",
        "on_complete_notify",
        "on_complete_dispose",
      },
    },
  },
}

return M
