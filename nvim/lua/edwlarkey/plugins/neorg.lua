return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  -- ft = "norg",
  -- cmd = "Neorg",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {},
        ["core.journal"] = {
          config = {
            workspace = "notes",
            strategy = "flat",
            toc_format = function(entries)
              -- Convert the entries into a certain format
              local months_text = {
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December",
              }

              local output = {}
              local current_year
              local current_month
              for _, entry in ipairs(entries) do
                -- Don't print the year if it hasn't changed
                if not current_year or current_year < entry[1] then
                  current_year = entry[1]
                  table.insert(output, "* " .. current_year)
                end

                -- Don't print the month if it hasn't changed
                if not current_month or current_month ~= entry[2] then
                  current_month = entry[2]
                  table.insert(output, "** " .. months_text[current_month])
                end

                -- Prints the file link
                table.insert(output, string.format("   - %s", entry[4]) .. string.format("[%s]", entry[5]))
              end

              return output
            end,
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/txt",
            },
            default_workspace = "notes",
            autochdir = true,
          },
        },
        ["core.summary"] = {
          config = {
            strategy = "default",
          }
        },
        ["core.esupports.metagen"] = {
          config = {
            type = "auto",
            template = {
              -- The title field generates a title for the file based on the filename.
              {
                "title",
                function()
                  return vim.fn.expand("%:p:t:r")
                end,
              },

              -- The description field is always kept empty for the user to fill in.
              { "description", "" },

              -- The authors field is autopopulated by querying the current user's system username.
              { "authors",     "edwlarkey" },

              -- The categories field is always kept empty for the user to fill in.
              { "categories",  "" },

              -- The created field is populated with the current date as returned by `os.date`.
              {
                "created",
                function()
                  return os.date("%Y-%m-%d")
                end,
              },

              -- When creating fresh, new metadata, the updated field is populated the same way
              -- as the `created` date.
              {
                "updated",
                function()
                  return os.date("%Y-%m-%d")
                end,
              },

              -- The version field determines which Norg version was used when
              -- the file was created.
              { "version", require("neorg.core.config").version },
            },
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
            name = "[Norg]",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.concealer"] = {
          config = {
            folds = false,
            icon_preset = "diamond",
            icons = {
              todo = {
                undone = {
                  enabled = true,
                  icon = " ",
                  query = "(todo_item_undone) @icon",
                },
              },
            },
          },
        },
      },
    })
  end,
}
