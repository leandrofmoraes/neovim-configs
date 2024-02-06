return{
  -- mini.animate
  {
    enabled = false,
    'echasnovski/mini.animate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = function()
      local animate = require('mini.animate')
      return {
        -- This is already handled by windows.nvim
        resize = { enable = false },
        open = { enable = false },
        close = { enable = false },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
  },

  -- mini.indentscope
  {
    'echasnovski/mini.indentscope',
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
        callback = function()
          ---@diagnostic disable-next-line: inject-field
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { symbol = '│', options = { try_as_border = true } },
  },

  -- mini.bufremove
  {
    'echasnovski/mini.bufremove',
  },

  -- mini.move
  {
    'echasnovski/mini.move',
    config = true,
    keys = {
      { '<A-h>', mode = { 'n', 'v' }, desc = 'Block left' },
      { '<A-j>', mode = { 'n', 'v' }, desc = 'Block down' },
      { '<A-k>', mode = { 'n', 'v' }, desc = 'Block up' },
      { '<A-l>', mode = { 'n', 'v' }, desc = 'Block right' },
    },
  },

  -- mini.splitjoin
  {
    enabled = false,
    'echasnovski/mini.splitjoin',
    keys = {
      {
        'g/j',
        function() return require('mini.splitjoin').join() end,
        desc = 'Join',
      },
      {
        'g/s',
        function() return require('mini.splitjoin').split() end,
        desc = 'Split',
      },
    },
  },

  -- mini.trailspace
  --{ 'echasnovski/mini.trailspace', event = 'InsertEnter', config = true },

}
