return {
  "codecompanion.nvim",

  for_cat = "ai",
  auto_enable = false,
  lazy = true,

  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionAdd",
  },

  -- I TRIGGER: Scorciatoie da tastiera (estratte dall'after)
  keys = {
    {
      "<C-s>",
      "<cmd>CodeCompanionActions<cr>",
      mode = { "n", "v" },
      desc = "CodeCompanion Actions"
    },
    {
      "<leader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = { "n", "v" },
      desc = "Toggle CodeCompanion Chat"
    },
    {
      "ga",
      "<cmd>CodeCompanionAdd<cr>",
      mode = "v",
      desc = "Add to CodeCompanion"
    },
  },

  after = function()
    local function get_gemini_key()
      local env_file = vim.fn.expand("~/.config/nvim/.env")
      if vim.fn.filereadable(env_file) == 1 then
        for line in io.lines(env_file) do
          local key, value = line:match("([^=]+)=(.+)")
          if key == "GEMINI_API_KEY" then
            return value
          end
        end
      end
      return ""
    end

    require("codecompanion").setup({
      strategies = {
        chat = { adapter = "gemini" },
        agent = { adapter = "gemini" },
        inline = { adapter = "gemini" },
      },
      adapters = {
        http = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = { api_key = get_gemini_key() }
            })
          end,
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = "http://localhost:11434",
              },
              schema = {
                model = {
                  default = "thirdeyeai/DeepSeek-R1-Distill-Qwen-7B-uncensored:Q4_0",
                },
                num_ctx = {
                  default = 8192,
                },
              },
            })
          end,
        },
      },
    })

    -- TODO: old
    --vim.keymap.set({ "n", "v" }, "<C-s>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    --vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    --vim.keymap.set("v", "ga", "<cmd>CodeCompanionAdd<cr>", { noremap = true, silent = true })
  end,
}
