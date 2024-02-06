return{
  -- zen-mode.nvim
  {
    enabled = false,
    'folke/zen-mode.nvim',
    dependencies = {
      {
        'folke/twilight.nvim',
        keys = { { '<leader>t', '<cmd>Twilight<CR>', desc = 'Toggle twilight.nvim' } },
        config = true,
      },
    },
    opts = { plugins = { kitty = { enabled = true, font = '+4' } } },
    -- stylua: ignore
    keys = { { '<leader>z', function() return require('zen-mode').toggle() end, desc = 'Toggle zen-mode.nvim' } },
  },
}
