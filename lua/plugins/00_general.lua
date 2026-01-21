return {
  { -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },

  { -- for notifications
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
        }
      },
    },
  },

  { -- For lua nvim config lsp
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- adds type hints for nixCats global
        { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
      },
    },
  },

  { --for some funtionalities of popup windows
    'nvim-lua/popup.nvim',
    enable = true,
    lazy = false,
  },

  { -- fuzzi finder
    'nvim-pack/nvim-spectre',
    enable = true,
    lazy = false,
  },

  {
    'mbbill/undotree',
    enable = true,
    lazy = false,
  },

  -- Git
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    }
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile", },
    -- Opzionale: per caricare l'interfaccia dello stato di git su telescope
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- Premi <leader>gg per aprire la dashboard di Git
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      -- Apre la vista diff per tutti i file modificati
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View Open" },
      -- Chiude la vista diff
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diff View Close" },
      -- Mostra la storia delle modifiche del file corrente
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = { default = { layout = "diff2_horizontal" } }
    }
  },

  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git" },
    keys = {
      -- Ottimo per vedere chi ha scritto quella riga (Git Blame) in una finestra a lato
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
    }
  },

  -- Cargo toml files
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = {
        enabled = true,
        completion = true,
        actions = true,
        hover = true,
        on_attach = function(client, bufnr)
          local crates = require("crates")
          vim.keymap.set("n", "<leader>ch", crates.open_homepage, { buffer = bufnr, desc = "Open Crate Homepage" })
          vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, { buffer = bufnr, desc = "Show Crate Versions" })
          vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { buffer = bufnr, desc = "Show Crate Features" })
        end,
      },
      popup = {
        autofocus = true,
        border = "rounded",
        show_version_date = true,
        show_dependency_version = true,
        max_height = 30,
        min_width = 20,
        padding = 1,
        keys = {
          hide = { "q", "<Esc>" },
          select = { "<CR>", "<Space>" },
          copy_value = { "yy" },
          -- Per scorrere si usano i tasti standard di vim (j/k)
        },
      },
    },
  }

}
