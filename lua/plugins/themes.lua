return {
  -- tokyonight.nvim
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    -- NOTE: Remove this once issue is fixed
    -- Related: https://github.com/folke/tokyonight.nvim/issues/452
    commit = 'e1e8ff2c8ff2bdc90ce35697291a5917adc8db5c',
    opts = {
      style = 'night',
      transparent = true,
      lualine_bold = true,
      terminal_colors = true,
      on_highlights = require('utils.colorscheme'),
    },
    config = function(_, opts)
      local tokyonight = require('tokyonight')
      tokyonight.setup(opts)
      tokyonight.load()
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        transparent_background = true,
        -- custom_highlights = require("utils.colorscheme"),
      }
    end,
  },

  {
    'craftzdog/solarized-osaka.nvim',
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },
  -- {
  --   "nvchad/base46",
  --   build = function()
  --     require("base46").load_all_highlights()
  --   end,
  -- },
}
