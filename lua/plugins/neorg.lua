return {
  {
    "neorg",

    for_cat = "neorg",
    auto_enable = false,
    lazy = true,

    ft = { "norg" },
    cmd = { "Neorg" },

    version = "*",

    after = function(plugin)
      require("neorg").setup(plugin.opts)

      vim.keymap.set("n", "gd", "<CR>", { buffer = 0, remap = true, desc = "Follow Neorg Link (Simula <CR>)" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "norg",
        callback = function(args)
          vim.keymap.set("n", "gd", "<CR>", { buffer = args.buf, remap = true, desc = "Follow Neorg Link (Simula <CR>)" })
        end,
      })
    end,
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
    "neorg-telescope",
    enabled = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "neorg" }
  }
}
