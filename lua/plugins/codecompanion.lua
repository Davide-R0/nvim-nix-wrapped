return {
  "olimorris/codecompanion.nvim",

  dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim" },

  config = function()
    local function get_gemini_key()
      local env_file = vim.fn.expand("~/.config/nvim/.env") -- Cambia il percorso se serve
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
        -- 'chat': Quando apri la finestra di chat laterale
        chat = {
          adapter = "gemini", -- Cambia in "gemini" se preferisci Google
        },

        -- 'agent': Per task complessi che richiedono tools
        agent = {
          adapter = "gemini",
        },

        -- For Lean
        -- Qui diciamo: Se il file è di tipo 'lean', usa il modello matematico!
        --inline = function(context)
        --  if context.filetype == "lean" then
        --    return "lean_math"
        --  end
        --  return "ollama" -- fallback per gli altri file
        --end,
        -- 'inline': Quando chiedi di generare codice nel buffer
        inline = {
          adapter = "gemini", -- Cambia in "gemini" se preferisci Google
        },
      },

      -- CONFIGURAZIONE ADAPTER (I Motori AI)
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = "http://localhost:11434", -- Porta standard di Ollama
            },
            schema = {
              model = {
                default = "thirdeyeai/DeepSeek-R1-Distill-Qwen-7B-uncensored:Q4_0", --deepseek-r1:7b", -- O qwen2.5-coder:7b
              },
              num_ctx = {
                default = 8192, -- Importante per Lean che è verboso
              },
            },
          })
        end,
        --gemini = function()
        --  return require("codecompanion.adapters").extend("gemini", {
        --    env = {
        --      api_key = get_gemini_key(),
        --    },
        --    schema = {
        --      model = {
        --        default = "gemini-1.5-flash",
        --      },
        --    },
        --  })
        --end,
        -- 1. OLLAMA (Locale)
        --ollama = function()
        --  return require("codecompanion.adapters").extend("ollama", {
        --    env = {
        --      url = "http://localhost:11434", -- Porta standard di Ollama
        --    },
        --    schema = {
        --      model = {
        --        -- Modello consigliato per il coding (leggero e potente)
        --        -- Ricordati di fare: ollama pull deepseek-coder:6.7b
        --        default = "deepseek-coder:6.7b", 
        --      },
        --    },
        --  })
        --end,

        -- 2. GEMINI (Google - Richiede API Key)
        --gemini = function()
        --  return require("codecompanion.adapters").extend("gemini", {
        --    env = {
        --      -- NON METTERE LA CHIAVE QUI! Usa una variabile d'ambiente.
        --      -- Lancia nvim così: GEMINI_API_KEY="tua_chiave" nvim
        --      api_key = "cmd:echo $GEMINI_API_KEY", 
        --    },
        --    schema = {
        --      model = {
        --        default = "gemini-1.5-flash", -- Modello veloce ed economico (spesso gratis)
        --      },
        --    },
        --  })
        --end,

        -- Lean ai
        --lean_math = function()
        --  return require("codecompanion.adapters").extend("ollama", {
        --    name = "lean_math",
        --    schema = {
        --      model = {
        --        default = "deepseek-math:7b-instruct",
        --      },
        --    },
        --    env = {
        --      url = "http://localhost:11434",
        --    },
        --    -- Prompt di sistema per forzarlo a essere un esperto Lean
        --    system_prompt = [[
        --      Sei un assistente esperto nel theorem prover Lean 4.
        --      Rispondi solo con codice Lean valido o spiegazioni brevi.
        --      Quando suggerisci tattiche, usa la sintassi di Lean 4.
        --    ]],
        --  })
        --end,
      },
    })

    -- MAPPATURE TASTI
    -- Ctrl+a apre il menu delle azioni AI
    vim.keymap.set({ "n", "v" }, "<C-s>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    -- Leader+a apre la chat laterale
    vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    -- Leader+ai aggiunge codice inline
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionAdd<cr>", { noremap = true, silent = true })
  end,
}
