return {
  "lervag/vimtex",

   -- Commands:\ll start or stop compiling
   --          \lc clear the file
   --          \lv forward search in the pdf preview (also from pdf to code)
   --          \lt show a window with table of content of the document
   --          \le close essor window

  lazy = false, -- VimTeX si carica automaticamente sui file .tex, meglio non lazy-loadarlo manualmente

  init = function()
    -- Le configurazioni di VimTeX devono andare in 'init', non in 'config',
    -- perché devono esistere PRIMA che il plugin si carichi.
    -- Usa Zathura come visualizzatore (richiede zathura e xdotool installati nel sistema/nix)
    vim.g.vimtex_view_method = "zathura"
    -- Opzionale: impedisce a VimTeX di aprirsi automaticamente se ci sono errori non fatali
    vim.g.vimtex_quickfix_mode = 0
  end,
  config = function()
    -- Qui puoi mettere codice che deve girare DOPO il caricamento, se serve.
    -- Di solito per VimTeX non serve nulla qui.
  end
}
