return {
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    name = 'gitsigns.nvim',
    opts = {
      -- signs = { add = { text = '+' }, change = { text = '~' }, delete = { text = '_' }, topdelete = { text = '‾' }, changedelete = { text = '~' }, },
    },
  },

  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim', 
    name = 'todo-comments.nvim',
    event = 'VimEnter', 
    dependencies = { 'nvim-lua/plenary.nvim' }, 
    opts = { signs = false } 
  },

  {
    "j-hui/fidget.nvim",
    name = 'fidget.nvim',
    opts = { } 
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- adds type hints for nixCats global
        { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
      },
    },
  },


}
