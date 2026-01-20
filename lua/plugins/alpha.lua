return {
  'goolord/alpha-nvim',

  dependencies = { 'nvim-tree/nvim-web-devicons', name = 'nvim-web-devicons', enabled = vim.g.have_nerd_font },

  lazy = false,

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- FUNZIONE PER GENERARE LA MUCCA
    local function get_cow_header()
      -- Esegue il comando di sistema e cattura l'output
      -- Nota: Se fortune o cowsay non sono installati, ritorna un fallback
      if vim.fn.executable("fortune") == 0 or vim.fn.executable("cowsay") == 0 then
        return {
          "  Cowsay o Fortune non trovati!  ",
          "  Aggiungili al tuo flake.nix  ",
        }
      end

      local safe_cows = {
        "default", "bud-frogs", "bunny", "cheese", "cower", "daemon", "dragon-and-cow",
        "elephant-in-snake", "elephant", "eyes", "flaming-sheep", "ghostbusters",
        "hellokitty", "kitty", "koala", "kosh", "luke-koala",
        "milk", "moose", "pony", "ren", "sheep", "skeleton", "snowman",
        "stegosaurus", "stimpy", "supermilker", "three-eyes", "turkey", "turtle",
        "tux", "vader", "vader-koala", "www"
      }

      -- Nota: Se vuoi SOLO quelli piccolissimi, rimuovi "stegosaurus" e "mech-and-cow" dalla lista sopra.

      -- Pesca un animale a caso dalla lista sicura
      math.randomseed(os.time())
      local random_cow = safe_cows[math.random(#safe_cows)]

      -- COSTRUZIONE COMANDO
      -- -W 30:  Forza la nuvoletta ad andare a capo ogni 30 caratteri (evita larghezze eccessive)
      -- -f ...: Usa l'animale scelto
      local cmd = string.format("fortune | cowsay -f %s -W 30", random_cow)
      -- Esegue il comando pipe
      --local cmd = [[fortune | cowsay -f $(cowsay -l | sed '1d' | tr ' ' '\n' | grep -v "^$" | shuf -n 1)]]

      local handle = io.popen(cmd)
      --local handle = io.popen("fortune | cowsay")
      local result = handle:read("*a")
      handle:close()

      if result == nil then return {} end
      -- Trasforma la stringa unica in una tabella di righe (come vuole Alpha)
      local lines = vim.split(result, "\n", { trimempty = true })
      if #lines == 0 then return black_hole_art end
      --local lines = {}
      --for s in result:gmatch("[^\r\n]+") do
      --  table.insert(lines, s)
      --end
      return lines
    end

    -- 1. L'IMMAGINE DEL BUCO NERO
    local black_hole_art = {
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢠⢀⡐⢄⢢⡐⢢⢁⠂⠄⠠⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⡄⣌⠰⣘⣆⢧⡜⣮⣱⣎⠷⣌⡞⣌⡒⠤⣈⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠒⠊⠀⠀⠀⠀⢀⠢⠱⡜⣞⣳⠝⣘⣭⣼⣾⣷⣶⣶⣮⣬⣥⣙⠲⢡⢂⠡⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⢀⠢⣑⢣⠝⣪⣵⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣯⣻⢦⣍⠢⢅⢂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⢆⡱⠌⣡⢞⣵⣿⣿⣿⠿⠛⠛⠉⠉⠛⠛⠿⢷⣽⣻⣦⣎⢳⣌⠆⡱⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠂⠠⠌⢢⢃⡾⣱⣿⢿⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢻⣏⠻⣷⣬⡳⣤⡂⠜⢠⡀⣀⠀⠀⡀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢀⠂⣌⢃⡾⢡⣿⢣⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡇⡊⣿⣿⣾⣽⣛⠶⣶⣬⣭⣥⣙⣚⢷⣶⠦⡤⢀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢁⠂⠰⡌⡼⠡⣼⢃⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣾⡿⠿⣛⣯⡴⢏⠳⠁⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠠⠑⡌⠀⣉⣾⣩⣼⣿⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣠⣤⣤⣿⣿⣿⣿⡿⢛⣛⣯⣭⠶⣞⠻⣉⠒⠀⠂⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⢀⣀⡶⢝⣢⣾⣿⣼⣿⣿⣿⣿⣿⣀⣼⣀⣀⣀⣤⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⠿⡛⠏⠍⠂⠁⢠⠁⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠠⢀⢥⣰⣾⣿⣯⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⣽⠟⣿⠐⠨⠑⡀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⡐⢢⣟⣾⣿⣿⣟⣛⣿⣿⣿⣿⢿⣝⠻⠿⢿⣯⣛⢿⣿⣿⣿⡛⠻⠿⣛⠻⠛⡛⠩⢁⣴⡾⢃⣾⠇⢀⠡⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠈⠁⠊⠙⠉⠩⠌⠉⠢⠉⠐⠈⠂⠈⠁⠉⠂⠐⠉⣻⣷⣭⠛⠿⣶⣦⣤⣤⣴⣴⡾⠟⣫⣾⣿⡏⠀⠂⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢻⢿⢶⣤⣬⣉⣉⣭⣤⣴⣿⣿⡿⠃⠄⡈⠁⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠘⢊⠳⠭⡽⣿⠿⠿⠟⠛⠉⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠁⠈⠐⠀⠘⠀⠈⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    }


    local version = vim.version()
    local version_text = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
    local version_widget = {
      type = "text",
      val = "Neovim " .. version_text,
      opts = {
        position = "center",
        hl = "Comment",
      }
    }

    -- Theme color
    local theme_colors = { "String", "Function", "Type", "Keyword", "Constant", "Number", "Identifier", "Statement", "Title", "Operator" }
    math.randomseed(os.time())
    local random_hl = theme_colors[math.random(#theme_colors)]

    dashboard.section.header.val = get_cow_header()

    dashboard.section.header.opts.hl = random_hl

    -- Imposta l'header dinamico
    ---- Imposta i colori dell'header (puoi usare "Statement", "String", "Constant")
    --dashboard.section.header.opts.hl = "Statement"

    -- I TUOI BOTTONI
    dashboard.section.buttons.val = {
      dashboard.button("n", "  New File", ":enew<CR>"),
      dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
      dashboard.button("g", "󰈭  Find Word", ":Telescope live_grep<CR>"),
      dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
      dashboard.button("s", "  Settings", ":Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>"),
      --dashboard.button("u", "󰇚  Update Plugins", ":Lazy<CR>"),
      dashboard.button("q", "➜  Quit", ":qa<CR>"),
    }

    -- FOOTER (Opzionale: mostra info su quanti plugin hai caricato)

    local function footer()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      return "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
    end
    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = "Comment"

    -- LAYOUT (Spaziatura)
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
      { type = "padding", val = 1 },
      version_widget,
    }

    alpha.setup(dashboard.config)
  end,
}
