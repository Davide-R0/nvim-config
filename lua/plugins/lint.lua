return {
  { -- Linting
    'mfussenegger/nvim-lint',

    -- NOTE: nixCats: return true only if category is enabled, else false
    enabled = true,--require('nixCatsUtils').enableForCategory("kickstart-lint")

    event = { 'BufReadPre', 'BufNewFile' },

    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        markdown = { 'markdownlint' }, -- Also grammar checking
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
        lua = { 'selene' },
        python = { 'flake8' },
        nix = { 'statix', 'deadnix' },
        cpp = { 'cppcheck' },
        c = { 'cppcheck' },
        -- Per i file di testo generici
        --text = { 'vale' },  -- Normal text files
        tex = { 'chktex' }, -- For latex
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- CONFIGURAZIONE AVANZATA ARGOMENTI
      -- Prendiamo la definizione base di selene
      local selene = lint.linters.selene
      -- Definiamo un percorso per una config globale (es. nella tua cache o config dir)
      local global_selene_conf = vim.fn.stdpath("config") .. "/spell/selene.toml"
      -- Creiamo il file se non esiste (così non devi gestirlo manualmente)
      if vim.fn.filereadable(global_selene_conf) == 0 then
        local f = io.open(global_selene_conf, "w")
        if f then
          -- Scriviamo la config "hardcoded" nel file
          f:write('std = "vim"\n[config]\nglobals = ["vim", "nixCats", "require"]')
          f:close()
        end
      end
      -- Diciamo a selene di usare SEMPRE questo file, ovunque tu sia
      -- "vim.list_extend" serve per non cancellare gli argomenti di default
      selene.args = vim.list_extend({ "--config", global_selene_conf }, selene.args)


      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
