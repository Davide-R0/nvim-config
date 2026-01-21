return {
  'nvim-telescope/telescope.nvim',

  event = 'VimEnter',

  branch = '0.1.x',

  dependencies = {
    'nvim-lua/plenary.nvim',
    { 
      -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      -- NOTE: nixCats: use lazyAdd to only run build steps if nix wasnt involved.
      -- because nix already did this.
      build = require('nixCatsUtils').lazyAdd 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      -- NOTE: nixCats: use lazyAdd to only add this if nix wasnt involved.
      -- because nix built it already, so who cares if we have make in the path.
      cond = require('nixCatsUtils').lazyAdd(function()
        return vim.fn.executable 'make' == 1
      end),
    },

    -- UI Select (Menu stile Code Actions)
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

    -- Media Files (Immagini/PDF)
    { 'nvim-telescope/telescope-media-files.nvim' },

    -- manix search
    'mrcjkb/telescope-manix',

    -- For undo
    -- { 'debugloop/telescope-undo.nvim' },
  },

  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local builtin = require('telescope.builtin')

    telescope.setup {
      defaults = {
        initial_mode = "normal",
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous, -- Muovi su
            ['<C-j>'] = actions.move_selection_next,     -- Muovi giù
            ['<C-u>'] = actions.preview_scrolling_up,    -- Scroll anteprima su
            ['<C-d>'] = actions.preview_scrolling_down,  -- Scroll anteprima giù
          },
          n = {
             ['q'] = actions.close,
          },
        },
        -- Layout (Opzionale)
        -- layout_config = {
        --   horizontal = { preview_width = 0.55 },
        -- },
      },

      -- Config extension
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        media_files = {
          filetypes = {"png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf", "svg"},
          find_cmd = "fd",
        }
      },
    }

    -- Loading extension
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension, 'media_files')
    pcall(telescope.load_extension, 'manix')
    -- pcall(telescope.load_extension, 'undo')

    -- ==========================================
    -- KEYBINDINGS
    -- ==========================================
    vim.keymap.set('n', '<leader>nm', function() telescope.extensions.manix.manix() end, { desc = '[N]ix [M]anix Options' })

    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    -- Old keybindings
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files (Alias)' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Grep (Alias)' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers (Alias)' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help (Alias)' })
    vim.keymap.set('n', '<leader>ld', builtin.diagnostics, { desc = 'Lsp Diagnostics (Alias)' })
    -- Media Files
    vim.keymap.set('n', '<leader>fm', ':Telescope media_files<CR>', { desc = 'Find Media' })

    -- Configurazione avanzata per ricerca nel buffer corrente 
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 0,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- Shortcut file config neovim
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
