return {
  "Julian/lean.nvim",

  event = { "BufReadPre *.lean", "BufNewFile *.lean" },

  dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim", },

  opts = {
    mappings = true,

    ft = {
      nomodifiable = {}
    },

    -- Abbreviazioni (Unicode)
    abbreviations = {
      enable = true,
      extra = { wknight = '♘' },
      leader = '\\',
    },

    -- Infoview (La finestra laterale)
    infoview = {
      autoopen = true,
      width = 40,
      height = 20,
      orientation = "auto",
      horizontal_position = "bottom",
      separate_tab = false,
      indicators = "auto",
    },

    -- Barre di progresso
    progress_bars = {
      enable = true,
      character = '│',
      priority = 10,
    },

    -- Redirect errori
    stderr = {
      enable = true,
      height = 5,
      on_lines = nil,
    },
  }
}
