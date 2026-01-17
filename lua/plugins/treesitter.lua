return {
    'nvim-treesitter/nvim-treesitter',

    name = 'nvim-treesitter',

    build = require('nixCatsUtils').lazyAdd ':TSUpdate',

    branch = 'main',

    lazy = false,

    config = function(_, opts)
        ---@param buf integer
        ---@param language string
        local function treesitter_try_attach(buf, language)
            -- check if parser exists and load it
            if not vim.treesitter.language.add(language) then
                return false
            end
            -- enables syntax highlighting and other treesitter features
            vim.treesitter.start(buf, language)

            -- enables treesitter based folds
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

            -- enables treesitter based indentation
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            return true
        end

        local installable_parsers = require("nvim-treesitter").get_available()
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local buf, filetype = args.buf, args.match
                local language = vim.treesitter.language.get_lang(filetype)
                if not language then
                    return
                end

                if not treesitter_try_attach(buf,language) then
                    if vim.tbl_contains(installable_parsers, language) then
                        -- not already installed, so try to install them via nvim-treesitter if possible
                        require("nvim-treesitter").install(language):await(function()
                            treesitter_try_attach(buf, language)
                        end)
                    end
                end
            end,
        })
        --  ---@param buf integer
        --  ---@param language string
        --  local function treesitter_try_attach(buf, language)
            --    -- check if parser exists and load it
            --    if not vim.treesitter.language.add(language) then
            --      return
            --    end
            --    -- enables syntax highlighting and other treesitter features
            --    vim.treesitter.start(buf, language)

            --    -- enables treesitter based folds
            --    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

            --    -- enables treesitter based indentation
            --    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            --  end

            --  local available_parsers = require("nvim-treesitter").get_available()
            --  vim.api.nvim_create_autocmd("FileType", {
                --    callback = function(args)
                    --      local buf, filetype = args.buf, args.match
                    --      local language = vim.treesitter.language.get_lang(filetype)
                    --      if not language then
                    --        return
                    --      end

                    --      local installed_parsers = require("nvim-treesitter").get_installed("parsers")

                    --      if vim.tbl_contains(installed_parsers, language) then
                    --        -- enable the parser if it is installed
                    --        treesitter_try_attach(buf, language)
                    --      elseif vim.tbl_contains(available_parsers, language) then
                    --        -- if a parser is available in `nvim-treesitter` enable it after ensuring it is installed
                    --        require("nvim-treesitter").install(language):await(function()
                        --          treesitter_try_attach(buf, language)
                        --        end)
                        --      else
                        --        -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
                        --        treesitter_try_attach(buf, language)
                        --      end
                        --    end,
                        --  })
                    end,

                    --config = function()
                        --        require('nvim-treesitter.configs').setup({
                            --            -- NOTA: Highlight e Indent devono essere TRUE per funzionare!
                            --            -- L'unica cosa da NON fare su NixOS è scaricare i parser (ensure_installed).
                            --            highlight = { enable = true },
                            --            indent    = { enable = true },
                            --
                            --            -- AGGIUNTA FONDAMENTALE PER NIXOS
                            --            -- Impedisce a Neovim di provare a scaricare parser mancanti all'apertura di un file
                            --            auto_install = false,
                            --            
                            --            -- Lascia vuoto, perché i parser li devi elencare nel flake.nix!
                            --            ensure_installed = {}, 
                            --        })
                            --    end,

                        }
