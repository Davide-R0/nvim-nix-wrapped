vim.loader.enable()
do
  local ok
  ok, _G.nixInfo = pcall(require, vim.g.nix_info_plugin_name)
  if not ok then
    package.loaded[vim.g.nix_info_plugin_name] = setmetatable({}, {
      __call = function(_, default) return default end
    })
    _G.nixInfo = require(vim.g.nix_info_plugin_name)
  end
  nixInfo.isNix = vim.g.nix_info_plugin_name ~= nil
  nixInfo.lze = setmetatable(require('lze'), getmetatable(require('lzextras')))
  function nixInfo.get_nix_plugin_path(name)
    return nixInfo(nil, "plugins", "lazy", name) or nixInfo(nil, "plugins", "start", name)
  end
end

nixInfo.lze.register_handlers {
  {
    spec_field = "auto_enable",
    set_lazy = false,
    modify = function(plugin)
      if vim.g.nix_info_plugin_name then
        if type(plugin.auto_enable) == "table" then
          for _, name in pairs(plugin.auto_enable) do
            if not nixInfo.get_nix_plugin_path(name) then
              plugin.enabled = false
              break
            end
          end
        elseif type(plugin.auto_enable) == "string" then
          if not nixInfo.get_nix_plugin_path(plugin.auto_enable) then
            plugin.enabled = false
          end
        elseif type(plugin.auto_enable) == "boolean" and plugin.auto_enable then
          if not nixInfo.get_nix_plugin_path(plugin.name) then
            plugin.enabled = false
          end
        end
      end
      return plugin
    end,
  },
  {
    spec_field = "for_cat",
    set_lazy = false,
    modify = function(plugin)
      if vim.g.nix_info_plugin_name then
        if type(plugin.for_cat) == "string" then
          plugin.enabled = nixInfo(false, "settings", "cats", plugin.for_cat)
        end
      end
      return plugin
    end,
  },
  nixInfo.lze.lsp,
}

nixInfo.lze.h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixInfo.get_nix_plugin_path "nvim-lspconfig"
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
    return (ok and cfg or {}).filetypes or {}
  else
    return (vim.lsp.config[name] or {}).filetypes or {}
  end
end)

require("config.options")
require("config.keymaps")
require("config.commands")

local mod_dir_to_spec = require("lzextras").mod_dir_to_spec

local raw_specs = mod_dir_to_spec('plugins', function(nome_file)
  return nome_file ~= "dankcolors"
end)

local dankcolors_path = vim.fn.stdpath('config') .. '/lua/plugins/dankcolors.lua'
local f = io.open(dankcolors_path, "r")
if f ~= nil then
  f:close()
  local ok, res = pcall(dofile, dankcolors_path)
  if ok and type(res) == "table" then
    for _, spec in ipairs(res) do
      -- CONVERSIONE AL VOLO:
      -- 1. Rinomina il pacchetto da "RRethy/base16-nvim" a "base16-nvim"
      if spec[1] == "RRethy/base16-nvim" then
        spec[1] = "base16-nvim"
      end
      -- 2. Sposta config in after
      if spec.config then
        spec.after = spec.config
        spec.config = nil
      end
      table.insert(raw_specs, spec)
    end
  else
    vim.notify("Errore nel caricare " .. dankcolors_path, vim.log.levels.ERROR)
  end
end

local specs = {}
for _, file_specs in ipairs(raw_specs) do
  -- Se il file restituisce una lista di spec (es: return { { "plug1" }, { "plug2" } })
  -- dobbiamo iterare su di essa e aggiungerla piatta.
  if file_specs[1] and type(file_specs[1]) == "table" then
    for _, spec in ipairs(file_specs) do
      table.insert(specs, spec)
    end
  else
    -- Altrimenti se è una spec singola
    table.insert(specs, file_specs)
  end
end

-- 3. Passiamo la lista completata a lze!
nixInfo.lze.load(specs)

require("config.transparency")
