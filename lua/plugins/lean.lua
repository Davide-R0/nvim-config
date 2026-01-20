return {
  "Julian/lean.nvim",

  event = { "BufReadPre *.lean", "BufNewFile *.lean" },

  dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim", },

  opts = {
    -- 1. Mappings (specifici del plugin, non LSP)
    mappings = true,

    -- 2. RIMUOVI IL BLOCCO LSP DA QUI!
    -- lsp = { ... }  <-- VIA QUESTO

    -- 3. Filetypes
    ft = {
      nomodifiable = {}
    },

    -- 4. Abbreviazioni (Unicode)
    abbreviations = {
      enable = true,
      extra = { wknight = '♘' },
      leader = '\\',
    },

    -- 5. Infoview (La finestra laterale)
    infoview = {
      autoopen = true,
      width = 50,
      height = 20,
      orientation = "auto",
      horizontal_position = "bottom",
      separate_tab = false,
      indicators = "auto",
    },

    -- 6. Barre di progresso
    progress_bars = {
      enable = true,
      character = '│',
      priority = 10,
    },

    -- 7. Redirect errori
    stderr = {
      enable = true,
      height = 5,
      on_lines = nil,
    },
  }
}
