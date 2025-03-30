return {
  -- mini.animate
  {
    'echasnovski/mini.animate',
    enabled = false,
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
    enabled = false,
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
    enabled = false,
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
  {
    'echasnovski/mini.surround',
    enabled = true,
    version = '*', -- or '*' for stable
    lazy = false,

    opts = {
      -- Add custom surroundings to be used on top of builtin ones. For more
      -- information with examples, see `:h MiniSurround.config`.
      custom_surroundings = nil,

      -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
      highlight_duration = 500,
      mappings = {
        add = 'gza',            -- Add surrounding in Normal and Visual modes
        delete = 'gzd',         -- Delete surrounding
        find = 'gzf',           -- Find surrounding (to the right)
        find_left = 'gzF',      -- Find surrounding (to the left)
        highlight = 'gzh',      -- Highlight surrounding
        replace = 'gzr',        -- Replace surrounding
        update_n_lines = 'gzn', -- Update `n_lines`
      },
      -- keys = {
      --   { "gs", "", desc = "+surround" },
      -- },
      -- Number of lines within which surrounding is searched
      n_lines = 20,

      -- Whether to respect selection type:
      -- - Place surroundings on separate lines in linewise mode.
      -- - Place surroundings on each line in blockwise mode.
      respect_selection_type = false,

      -- How to search for surrounding (first inside current line, then inside
      -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
      -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
      -- see `:h MiniSurround.config`.
      search_method = 'cover',

      -- Whether to disable showing non-error feedback
      -- This also affects (purely informational) helper messages shown after
      -- idle time if user input is required.
      silent = false,
    },
    keys = {
      { 'gza', mode = { 'n', 'v' },            desc = 'Add surrounding' },
      { 'gzd', desc = 'Delete surrounding' },
      { 'gzf', desc = 'Find right surrounding' },
      { 'gzF', desc = 'Find left surrounding' },
      { 'gzh', desc = 'Highlight surrounding' },
      { 'gzr', desc = 'Replace surrounding' },
      { 'gzn', desc = 'Updated n_lines' },
    },
  },

  -- mini.splitjoin
  -- {
  --   enabled = false,
  --   'echasnovski/mini.splitjoin',
  --   keys = {
  --     {
  --       'g/j',
  --       function() return require('mini.splitjoin').join() end,
  --       desc = 'Join',
  --     },
  --     {
  --       'g/s',
  --       function() return require('mini.splitjoin').split() end,
  --       desc = 'Split',
  --     },
  --   },
  -- },

  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      local devicons = "nvim-web-devicons"
      package.preload[devicons] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded[devicons]
      end
    end,
  },
  -- mini.trailspace
  --{ 'echasnovski/mini.trailspace', event = 'InsertEnter', config = true },

}
