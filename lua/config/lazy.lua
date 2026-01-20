-- Funzione per gestire il percorso del lockfile con nixCats
local function getlockfilepath()
  if require('nixCatsUtils').isNixCats and nixCats.settings and type(nixCats.settings.unwrappedCfgPath) == 'string' then
    return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
  else
    return vim.fn.stdpath 'config' .. '/lazy-lock.json'
  end
end

local lazyOptions = {
  lockfile = getlockfilepath(),
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙', keys = '🗝', plugin = '🔌',
      runtime = '💻', require = '🌙', source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
    border = "rounded",
    size = { width = 0.6, height = 0.6 },
  },
  checker = { enabled = false, notify = false },
  change_detection = { enabled = false, notify = false },
  pkg = { enabled = false },
  rocks = { enabled = false },
  performance = { rtp = { reset = false } },
  readme = {
    enabled = false,
    root = vim.fn.stdpath("state") .. "/lazy/readme",
    files = { "README.md", "lua/**/README.md" },
    skip_if_doc_exists = true,
  },
}

-- 2. Imposta la Leadsr Key prima di caricare lazy
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- 3. Imposta se abbiamo una Nerd Font (usando nixCats)
vim.g.have_nerd_font = nixCats('have_nerd_font')

-- Configurazione e installazione dei plugin TRAMITE IL WRAPPER NIXCATS.
-- Ora che il flake.nix è corretto, questo funzionerà come previsto.
local specs = {
  { import = 'plugins', exclude = 'dankcolors' },
}

-- Carica dinamicamente il tema dankcolors dalla directory di configurazione.
-- Questo permette al tema di essere aggiornato da tool esterni (es. mautagen)
-- a runtime, senza dover rebuildare la configurazione Nix.
local dankcolors_path = vim.fn.stdpath('config') .. '/lua/plugins/dankcolors.lua'
local f = io.open(dankcolors_path, "r")
if f ~= nil then
  f:close()
  -- pcall per eseguire il file in modo sicuro
  local ok, res = pcall(dofile, dankcolors_path)
  if ok and type(res) == "table" then
    -- dankcolors.lua restituisce una lista di specifiche di plugin
    for _, spec in ipairs(res) do
      table.insert(specs, spec)
    end
  elseif not ok then
    vim.notify("Errore nel caricare " .. dankcolors_path .. ": " .. tostring(res), vim.log.levels.ERROR)
  end
end

require('nixCatsUtils.lazyCat').setup(
  nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, -- Trova lazy.nvim da Nix
  specs,
  lazyOptions
)
