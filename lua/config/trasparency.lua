vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- 1. FUNZIONE SICURA PER LA TRASPARENZA
    -- Questa funzione legge il colore esistente e rimuove SOLO lo sfondo,
    -- preservando il colore del testo (fg), il grassetto, ecc.
    local function set_transparent(group)
      -- Ottieni le proprietà attuali del gruppo (risolvendo i link)
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      if not hl or vim.tbl_isempty(hl) then return end
      -- Imposta solo lo sfondo a NONE, mantenendo il resto (hl.fg, hl.bold, ecc.)
      hl.bg = "NONE"
      hl.ctermbg = "NONE"
      -- Riapplica il gruppo modificato
      vim.api.nvim_set_hl(0, group, hl)
    end

    -- 2. LISTA DEI GRUPPI DA RENDERE TRASPARENTI
    -- Can be fouded with: Telescope hilights
    local groups = {
      -- === BASE EDITOR ===
      "Normal", "NormalNC", "Comment", "Constant", "Special", "Identifier",
      "Statement", "PreProc", "Type", "Underlined", "Todo", "String", "Function",
      "Conditional", "Repeat", "Operator", "Structure", "LineNr", "NonText",
      "SignColumn", "CursorLine", "CursorLineNr", "StatusLine", "StatusLineNC",
      "EndOfBuffer",
      -- Cmp
      "CmpItemAbbr", "CmpItemAbbrDeprecated", "CmpItemAbbrMatch",
      -- === FINESTRE FLOTTANTI E MENU ===
      "NormalFloat", "FloatBorder", "Pmenu", "PmenuBorder",
      -- === TELESCOPE (Ricerca file) ===
      "TelescopeNormal",          -- Lo sfondo della finestra principale
      --"TelescopeSelection",
      -- === FIDGET (Notifiche LSP) ===
      "FidgetNormal", "FidgetBorder",
      --"FidgetTask", "FidgetTitle", 
      -- === WHICHKEY (Menu suggerimenti tasti) ===
      "WhichKey", "WhichKeyFloat", "WhichKeyGroup",
      -- === NEO-TREE / NVIM-TREE (File Explorer laterale) ===
      -- Se usi uno di questi due
      "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeWinSeparator",
      "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeWinSeparator",
      -- === LAZY (Gestore Plugin) ===
      "LazyNormal", "MasonNormal",
      -- === DIAGNOSTICA (Errori nel codice) ===
      "DiagnosticVirtualTextError", "DiagnosticVirtualTextWarn", "DiagnosticVirtualTextInfo", "DiagnosticVirtualTextHint",
      -- === TREESITTER CONTEXT (Barra in alto che fissa la funzione) ===
      "TreesitterContext", "TreesitterContextLineNumber",

      "GitSignsAdd", "GitSignsChange", "GitSignsDelete", "GitSignsUntracked", "GitSignsStagedAdd",
      -- === GIT SIGNS (Segni git a sinistra) ===
      "SignColumn", "CursorLineSign", "FoldColumn",
      -- 2. I GRUPPI PADRE (Da cui GitSigns eredita)
      "DiffAdd", "DiffChange", "DiffDelete", "DiffText", "SignColumn", "GitSignsAdd", "GitSignsChange", "GitSignsDelete",
      -- Varianti (ChangeDelete, TopDelete, ecc.)
      "GitSignsChangedelete", "GitSignsTopdelete", "GitSignsUntracked", "GitSignsStagedAdd",
      -- Numeri di riga (se evidenziati)
      "GitSignsAddNr", "GitSignsChangeNr", "GitSignsDeleteNr", "GitSignsChangedeleteNr", "GitSignsTopdeleteNr", "GitSignsUntrackedNr",
      -- Linea intera (raro, ma a volte capita)
      "GitSignsAddLn", "GitSignsChangeLn", "GitSignsDeleteLn", "GitSignsChangedeleteLn", "GitSignsTopdeleteLn", "GitSignsUntrackedLn", "GitSignsPreview", "GitSignsPreviewBorder",
      -- Varianti di linea
      "GitSignsAddLn", "GitSignsChangeLn", "GitSignsDeleteLn", 
      -- 3. VARIANTI "STAGED" (File già aggiunti con git add)
      -- Anche se chiedevi degli unstaged, è meglio pulire anche questi per coerenza
      "GitSignsStagedAdd", "GitSignsStagedChange", "GitSignsStagedDelete", "GitSignsStagedChangedelete", "GitSignsStagedTopdelete", "GitSignsStagedAddNr", "GitSignsStagedChangeNr", "GitSignsStagedDeleteNr",
      "GitSignsAddCul", "GitSignsChangeCul", "GitSignsDeleteCul", "GitSignsChangedeleteCul", "GitSignsTopdeleteCul", "GitSignsUntrackedCul",

    }

    -- Applica la trasparenza sicura
    for _, group in ipairs(groups) do
      set_transparent(group)
    end

    -- "LazyButtonActive": Il bottone/tab selezionato. 
    -- Lo linkiamo a "Visual" (solitamente grigio/blu scuro nel tuo tema) o "CursorLine"
    vim.api.nvim_set_hl(0, "LazyButtonActive", { link = "Visual" })
    -- "LazyH1": I titoli principali. Lo linkiamo a "Title" o "Special" del tema
    vim.api.nvim_set_hl(0, "LazyH1", { link = "Title" })
    -- "LazySpecial": Testi speciali (spesso viola). Lo linkiamo a "Constant" o "String"
    vim.api.nvim_set_hl(0, "LazySpecial", { link = "Constant" })
    -- Assicura che quando selezioni qualcosa nei menu, si veda bene
    vim.api.nvim_set_hl(0, "PmenuSel", { link = "Visual" })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "Visual" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE", ctermbg = "NONE" })

    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineSign", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE", ctermbg = "NONE" })

    vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "GitSignsUntracked", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { bg = "NONE", ctermbg = "NONE" })

  end,
})

-- Force the execution
vim.cmd("doautocmd ColorScheme")
