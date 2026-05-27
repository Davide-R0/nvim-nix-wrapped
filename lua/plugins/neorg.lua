return {
  {
    "neorg",
    auto_enable = true,
    event = "DeferredUIEnter",
    version = "*",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.esupports.hop"] = {},
        ["core.concealer"] = {
          config = {
            icon_preset = "varied",
          },
        },
        ["core.ui"] = {},
        ["core.ui.calendar"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              personale = "~/Norg",
            },
            index = "index.norg",
            default_workspace = "personale",
          },
        },
        ["core.todo-introspector"] = {},
        ["core.latex.renderer"] = {},
        ["core.integrations.treesitter"] = {},
        ["core.export.html"] = {},
        ["core.export.markdown"] = {},
        ["core.qol.toc"] = {},
        ["core.integrations.nvim-cmp"] = {},
        ["core.integrations.telescope"] = {},
        ["core.journal"] = {
          config = {
            workspace = "personale",
          },
        },
        ["core.tangle"] = {
          config = { tangle_on_write = true }
        },
      },
    },
  },
  {
    "plenary.nvim",
    auto_enable = true,
    dep_of = { "neorg" }
  },
  {
    "neorg-telescope",
    auto_enable = true,
    dep_of = { "neorg" }
  }
}
