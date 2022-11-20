require('mkdnflow').setup()
require('markdown-index').setup()
require('neorg').setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.journal"] = {
      config = {
        strategy = "flat",
      }
    },
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          notes = "~/txt",
        }
      }
    },
    ["core.norg.esupports.metagen"] = {
      config = {
        type = "auto"
      }
    },
    ["core.norg.completion"] = {
       config = {
         engine = "nvim-cmp"
       }
    },
    ["core.norg.concealer"] = {
       config = {
         folds = false
       }
    },
  }
}
