return {
  'nvim-lualine/lualine.nvim',

  name = 'lualine.nvim',

  enabled = true, --se il plugin è gestito da nix lazy non deve scaricarlo

  dependencies ={ 'nvim-tree/nvim-web-devicons', name = 'nvim-web-devicons', enabled = vim.g.have_nerd_font },
  --dependencies = { 'nvim-tree/nvim-web-devicons' },

  build = require('nixCatsUtils').lazyAdd ':TSUpdate',

  lazy = false, -- false = the plugin is loaded at startup | true = the plugin is loaded when needed

  config = function()
    local auto_theme = require('lualine.themes.auto')

    local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }
    for _, mode in ipairs(modes) do
      if auto_theme[mode] then
        if auto_theme[mode].c then auto_theme[mode].c.bg = "NONE" end
        --if auto_theme[mode].x then auto_theme[mode].x.bg = "NONE" end
      end
    end

    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = auto_theme, --"auto", --bubbles_theme
        component_separators = '',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 
          { 'mode', right_padding = 2 },

        },
        lualine_b = { 
          'filename', 
          'branch', 
          'diff', 
          'diagnostics',
        },
        lualine_c = {

          {'filename', path = 1},
          '%=', --[[ add your center compoentnts here in place of this comment ]]

        },
        lualine_y = { 'progress',  },
        lualine_z = { { 'location', left_padding = 2 }, },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {'oil', 'fzf', 'fugitive', 'nvim-dap-ui'},

    })
  end,
}
