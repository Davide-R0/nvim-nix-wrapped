return {
  "obsidian.nvim",

  for_cat = "obsidian",
  auto_enable = false,
  lazy = true,

  ft = { "markdown" },
  cmd = { "Obsidian" },

  keys = {
    { "<leader>os",   "<cmd>Obsidian search<cr>",             desc = "[O]bsidian [S]earch" },
    { "<leader>oo",   "<cmd>Obsidian quick_switch<cr>",       desc = "[O]bsidian [O]pen Note" },
    { "<leader>on",   "<cmd>Obsidian new<cr>",                desc = "[O]bsidian [N]ew Note" },
    { "<leader>ot",   "<cmd>Obsidian template<cr>",           desc = "[O]bsidian [T]emplate" },
    { "<leader>ob",   "<cmd>Obsidian backlinks<cr>",          desc = "[O]bsidian [B]acklinks" },
    { "<leader>ol",   "<cmd>Obsidian links<cr>",              desc = "[O]bsidian [L]inks" },
    { "<leader>otg",  "<cmd>Obsidian tags<cr>",               desc = "[O]bsidian [T]a[G]s" },
    { "<leader>od",   "<cmd>Obsidian dailies<cr>",            desc = "[O]bsidian [D]ailies" },
    { "<leader>odtd", "<cmd>Obsidian today<cr>",              desc = "[O]bsidian Today" },
    { "<leader>ody",  "<cmd>Obsidian yesterday<cr>",          desc = "[O]bsidian Yesterday" },
    { "<leader>odtm", "<cmd>Obsidian tomorrow<cr>",           desc = "[O]bsidian Tomorrow" },
    { "<leader>orn",  "<cmd>Obsidian rename<cr>",             desc = "[O]bsidian [R]ename note and links" },
    { "<leader>opi",  "<cmd>Obsidian paste_img<cr>",          desc = "[O]bsidian [P]aste [I]mage" },
    { "<leader>og",   "<cmd>Obsidian open<cr>",               desc = "[O]bsidian [G]ui open" },
    { "<leader>ow",   "<cmd>Obsidian workspace<cr>",          desc = "[O]bsidian [W]orkspace Switch" },
    { "gf",           "<cmd>Obsidian follow_link vsplit<cr>", desc = "Follow Anchor Link" },
    { "<leader>ovs",  "<cmd>Obsidian follow_link vsplit<cr>", desc = "Open link in vsplit" },
    { "<leader>ohs",  "<cmd>Obsidian follow_link hsplit<cr>", desc = "Open link in hsplit" },
    { "<leader>ol",   "<cmd>Obsidian link<cr>",               mode = "v",                                 desc = "Link selection" },
    { "<leader>onl",  "<cmd>Obsidian link_new<cr>",           mode = "v",                                 desc = "New note from selection" },
    {
      "<leader>ona",
      function()
        local title = vim.fn.input("Titolo Atlas: ")
        if title ~= "" then
          vim.cmd("Obsidian new atlas " .. title)
          vim.defer_fn(function() vim.cmd("Obsidian template atlas_template.md") end, 100)
        end
      end,
      desc = "[O]bsidian [N]ew [A]tlas"
    },
    {
      "<leader>oni",
      function()
        local title = vim.fn.input("Titolo Icebox: ")
        if title ~= "" then
          vim.cmd("Obsidian new icebox " .. title)
          vim.defer_fn(function() vim.cmd("Obsidian template icebox_template.md") end, 100)
        end
      end,
      desc = "[O]bsidian [N]ew [I]cebox"
    },
    {
      "<leader>onn",
      function()
        local title = vim.fn.input("Titolo Atomic note: ")
        if title ~= "" then
          vim.cmd("Obsidian new note " .. title)
          vim.defer_fn(function() vim.cmd("Obsidian template atomic_note_template.md") end, 100)
        end
      end,
      desc = "[O]bsidian [N]ew atomic [N]ote"
    },
  },

  after = function()
    vim.ui.open = (function(overridden)
      return function(uri, opt)
        local is_uri = uri:match("^%a+://")
        if is_uri then
          opt = { cmd = { "brave" } }
        elseif vim.endswith(uri, ".pdf") then
          opt = { cmd = { "zathura" } }
        elseif vim.endswith(uri, ".png") or vim.endswith(uri, ".jpg") or vim.endswith(uri, ".jpeg") or vim.endswith(uri, ".gif") then
          opt = { cmd = { "imv" } }
        elseif vim.endswith(uri, ".mp4") or vim.endswith(uri, ".mkv") then
          opt = { cmd = { "mpv" } }
        elseif vim.fn.isdirectory(uri) == 1 then
          opt = { cmd = { "alacritty", "-e", "yazi" } }
        end

        return overridden(uri, opt)
      end
    end)(vim.ui.open)

    require('obsidian').setup({
      legacy_commands = false,
      opts = { legacy_commands = false, },
      log_level = vim.log.levels.TRACE,
      ui = {
        enable = false,
      },
      workspaces = {
        {
          name = "Omnis",
          path = "~/00_Omnis",
          overrides = {
            notes_subdir = "04_atomic_notes",
            new_notes_location = "notes_subdir",
            templates = {
              folder = "04_atomic_notes/obsidian_templates",
              date_format = "%Y-%m-%d",
              time_format = "%H:%M",
              substitutions = {},
            },
            daily_notes = {
              folder = "02_planning/01_daily",
              date_format = "%Y-%m-%d",
              alias_format = "%B %-d, %Y",
              default_tags = { "daily-notes", "planning" },
              template = "daily_note_template.md"
            },
            attachments = {
              folder = "05_resources/03_pictures",
              img_name_func = function() return string.format("%s-", os.time()) end,
              img_text_func = function(client, path)
                path = client:vault_relative_path(path) or path
                return string.format("![%s](%s)", tostring(path.name), tostring(path))
              end,
            },
            note_path_func = function(spec)
              local path
              local vault_root = vim.fn.expand("~/00_Omnis/")

              local title = tostring(spec.id)
              if title:match("^atlas") then
                path = vault_root .. "01_atlas/" .. tostring(spec.id)
              elseif title:match("^icebox") then
                path = vault_root .. "03_icebox/" .. tostring(spec.id)
              elseif title:match("^note") then
                path = vault_root .. "04_atomic_notes/" .. tostring(spec.id)
              elseif title:sub(1, 1) == "." then
                local current_buffer_dir = vim.fn.expand("%:p:h")
                if current_buffer_dir:match("^oil://") then
                  current_buffer_dir = current_buffer_dir:gsub("^oil://", "")
                end
                path = (current_buffer_dir == "" and vim.fn.getcwd() or current_buffer_dir) .. "/" .. tostring(spec.id)
              else
                path = tostring(spec.dir / tostring(spec.id))
              end

              return vim.fs.normalize(tostring(path)) .. ".md"
            end,
          },
        },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      new_notes_location = "notes_subdir",
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "_" .. suffix
      end,
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,
      preferred_link_style = "markdown",
      frontmatter = {
        enabled = true,
        func = function(note)
          if note.title then
            note:add_alias(note.title)
          end
          local out = { id = note.id, aliases = note.aliases, tags = note.tags }
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end
      },
      open = {
        use_advanced_uri = false,
        func = function(uri)
          vim.ui.open(uri, { cmd = { "open", "-a", "/Applications/Obsidian.app" } })
        end
      },
      picker = {
        name = "telescope.nvim",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-x>",
          insert_tag = "<C-l>",
        },
      },
      search = {
        max_lines = 1000,
        sort_by = "modified",
        sort_reversed = true,
      },
      open_notes_in = "current",
      callbacks = {
        post_setup = function()
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function() vim.opt_local.conceallevel = 2 end,
          })
        end,
        enter_note = function(client, note) end,
        leave_note = function(client, note) end,
        pre_write_note = function(client, note) end,
        post_set_workspace = function(client, workspace) end,
      },
    })

    -- TODO: OLD
    --vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "[O]bsidian [S]earch", })
    --vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian quick_switch<cr>", { desc = "[O]bsidian [O]pen Note" })
    --vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "[O]bsidian [N]ew Note" })
    --vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian template<cr>", { desc = "[O]bsidian [T]emplate" })
    --vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "[O]bsidian [B]acklinks" })
    --vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "[O]bsidian [L]inks" })
    --vim.keymap.set("n", "<leader>otg", "<cmd>Obsidian tags<cr>", { desc = "[O]bsidian [T]a[G]s" })
    --vim.keymap.set("n", "<leader>od", "<cmd>Obsidian dailies<cr>", { desc = "[O]bsidian [D]ailies" })
    --vim.keymap.set("n", "<leader>odtd", "<cmd>Obsidian today<cr>", { desc = "[O]bsidian [D]ailies" })
    --vim.keymap.set("n", "<leader>ody", "<cmd>Obsidian yesterday<cr>", { desc = "[O]bsidian [D]ailies" })
    --vim.keymap.set("n", "<leader>odtm", "<cmd>Obsidian tomorrow<cr>", { desc = "[O]bsidian [D]ailies" })
    --vim.keymap.set("n", "<leader>orn", "<cmd>Obsidian rename<cr>", { desc = "[O]bsidian [R]ename note and links" })
    --vim.keymap.set("n", "<leader>opi", "<cmd>Obsidian paste_img<cr>", { desc = "[O]bsidian [P]aste [I]mage" })
    --vim.keymap.set("n", "<leader>og", "<cmd>Obsidian open<cr>", { desc = "[O]bsidian [G]ui open" })
    --vim.keymap.set("n", "<leader>ow", "<cmd>Obsidian workspace<cr>", { desc = "[O]bsidian [W]orkspace Switch" })
    --vim.keymap.set("n", "gf", "<cmd>Obsidian follow_link vsplit<cr>", { desc = "Follow Anchor Link" })
    --vim.keymap.set("n", "<leader>ovs", "<cmd>Obsidian follow_link vsplit<cr>", { desc = "Open link in vsplit" })
    --vim.keymap.set("n", "<leader>ohs", "<cmd>Obsidian follow_link hsplit<cr>", { desc = "Open link in hsplit" })

    --vim.keymap.set("v", "<leader>ol", "<cmd>Obsidian link<cr>", { desc = "Link selection" })
    --vim.keymap.set("v", "<leader>onl", "<cmd>Obsidian link_new<cr>", { desc = "New note from selection" })

    --vim.keymap.set("n", "<leader>ona", function()
    --  local title = vim.fn.input("Titolo Atlas: ")
    --  if title ~= "" then
    --    vim.cmd("Obsidian new atlas " .. title)
    --    vim.defer_fn(function()
    --      vim.cmd("Obsidian template atlas_template.md")
    --    end, 100)
    --  end
    --end, { desc = "[O]bsidian [N]ew [A]tlas" })

    --vim.keymap.set("n", "<leader>oni", function()
    --  local title = vim.fn.input("Titolo Icebox: ")
    --  if title ~= "" then
    --    vim.cmd("Obsidian new icebox " .. title)
    --    vim.defer_fn(function()
    --      vim.cmd("Obsidian template icebox_template.md")
    --    end, 100)
    --  end
    --end, { desc = "[O]bsidian [N]ew [I]cebox" })

    --vim.keymap.set("n", "<leader>onn", function()
    --  local title = vim.fn.input("Titolo Atomic note: ")
    --  if title ~= "" then
    --    vim.cmd("Obsidian new note " .. title)
    --    vim.defer_fn(function()
    --      vim.cmd("Obsidian template atomic_note_template.md")
    --    end, 100)
    --  end
    --end, { desc = "[O]bsidian [N]ew atomic [N]ote" })
  end,
}
