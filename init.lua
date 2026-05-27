-- init.lua

-- [1. MANTIENI IL SETUP INIZIALE DEL TEMPLATE]
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

-- [2. MANTIENI GLI HANDLERS (auto_enable, for_cat, ecc.)]
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

-- [3. IMPOSTAZIONI GLOBALI]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("config.options")
require("config.keymaps")

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
      table.insert(raw_specs, spec)
    end
  else
    vim.notify("Errore nel caricare " .. dankcolors_path, vim.log.levels.ERROR)
  end
end

table.insert(raw_specs, {
  "trigger_colorscheme",
  event = "VimEnter",
  load = function(_name)
    vim.schedule(function()
      vim.cmd.colorscheme(nixInfo("onedark_dark", "settings", "colorscheme"))
    end)
  end
})

-- Deduplicate specs and merge dep_of lists
local specs = {}
local seen_plugins = {}

local function merge_lists(t1, t2)
  if not t1 then return t2 end
  if not t2 then return t1 end
  local res = {}
  local seen = {}
  for _, v in ipairs(t1) do
    if not seen[v] then
      table.insert(res, v)
      seen[v] = true
    end
  end
  for _, v in ipairs(t2) do
    if not seen[v] then
      table.insert(res, v)
      seen[v] = true
    end
  end
  return res
end

for _, spec in ipairs(raw_specs) do
  local name = spec[1] or spec.name
  if name then
    if not seen_plugins[name] then
      seen_plugins[name] = spec
      table.insert(specs, spec)
    else
      local existing = seen_plugins[name]
      
      -- Merge dep_of
      if spec.dep_of then
        existing.dep_of = merge_lists(existing.dep_of, spec.dep_of)
      end
      
      -- Merge on_plugin
      if spec.on_plugin then
        existing.on_plugin = merge_lists(existing.on_plugin, spec.on_plugin)
      end
      
      -- Prefer the spec that has an `after`, `before` or `opts` if the existing doesn't
      if not existing.after and spec.after then existing.after = spec.after end
      if not existing.before and spec.before then existing.before = spec.before end
      if not existing.opts and spec.opts then existing.opts = spec.opts end
      if not existing.ft and spec.ft then existing.ft = spec.ft end
      if not existing.cmd and spec.cmd then existing.cmd = spec.cmd end
      if not existing.event and spec.event then existing.event = spec.event end
    end
  else
    table.insert(specs, spec)
  end
end

-- 3. Passiamo la lista completata a lze!
nixInfo.lze.load(specs)

require("config.transparency")
