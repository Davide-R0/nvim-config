-- Per le funzioni set...=... in .vim
local set = vim.opt

-- This is necessary to make nvim expand the bash aliases when it execute commands
vim.o.shell = "bash"
vim.o.shellcmdflag = "-c"

-- On saving files
set.backup = false 
set.swapfile = false 
-- undoo save
set.undodir = os.getenv("HOME") .. "/.config/undodir/"
set.undofile = true

-- for obsidian preview
--set.conceallevel = 1

-- Number line option
set.nu = true
set.relativenumber = true
set.number = true

-- Set the behavior of tab
set.tabstop = 4 
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true  --per avere solo spazi e non tab

-- Reload files changed outside nvim
set.autoread = true

--Set Encoding
set.encoding = "utf-8"

-- Search hilighting
set.hlsearch = false
set.incsearch = true

-- Error flash instead of sound
set.visualbell = true

-- Enable true color (optional)
set.termguicolors = true

--Scrolling setting
set.scrolloff = 7 --lascia sempre un offset di righe
vim.signcolumn = true --Attivazione barra sinistra per gli errori e vari (magari non necessaio)

-- Setting backspace key like delite
--set.backspace = "indent", "eol", "start"

-- Autoindentation
set.autoindent = true

-- Set status line to visualize the modes
-- Hide insert, normal, visual status mode
set.showmode = false
set.showcmd = true 

-- Hilight matching parentesis..
set.showmatch = true

-- clipboard initialization
set.clipboard = "unnamedplus"

-- Enable standard hilighting of text
vim.syntax = "on"

-- Folding method
vim.foldmethod = "indent"
vim.foldnestmax = 1
vim.foldlevelstart = 1

-- Set scrool number line
--vim.scrolloff = 2

---- Standard setup ----

-- Set Python directory
-- analogo ad let g:... = /...
-- TODO:
--vim.g['python3_host_prog'] = "/usr/bin/python3"

--Deactivate perl provider
vim.g['loaded_perl_provider'] = 0
--Deactivate ruby provider
vim.g['loaded_ruby_provider'] = 0

-- Terminal
-- TODO: Ricontrollare
vim.cmd[[ 
let term_program=$TERM_PROGRAM
]]

-- glsl hiligting
vim.cmd[[ 
autocmd! BufNewFile,BufRead *.vs,*.fs,*.cp,*.vert,*.frag,*.comp set ft=glsl
]]

-- Tab space for some files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nix", "lua", "json", "jsonc", "yaml", "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "ruby" },
  callback = function(args)
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    -- Fix specifico per Nix (e altri linguaggi che usano # per i commenti)
    if args.match == "nix" or args.match == "ruby" or args.match == "python" then
      -- Disabilita smartindent (è spesso lui che spara il # a inizio riga)
      vim.opt_local.smartindent = false
      -- Rimuove la regola 0# da indentkeys (se presente)
      vim.opt_local.indentkeys:remove("0#")
      -- Rimuove la regola 0# da cinkeys (spesso usata come fallback)
      vim.opt_local.cinkeys:remove("0#")
    end
  end,
})
