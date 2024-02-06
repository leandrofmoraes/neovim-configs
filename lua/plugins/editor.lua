return {
  -- todo-comments.nvim
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
    keys = {
      -- stylua: ignore start
      { ']t', function() return require('todo-comments').jump_next() end, desc = 'Jump to next todo comment' },
      { '[t', function() return require('todo-comments').jump_prev() end, desc = 'Jump to previous todo comment' },
      -- stylua: ignore end
    },
  },

  {
    -- Lazy loaded by Comment.nvim pre_hook
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },

  -- nvim-autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      disable_filetype = { 'TelescopePrompt', 'text' },
      disable_in_macro = false,
      check_ts = true,
    },
  },
  { 'machakann/vim-sandwich' },
  {
    'tpope/vim-surround',
  },

  -- vim-illuminate
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      -- providers = { 'lsp', 'treesitter', 'regex' },
      large_file_cuttoff = 2000,
      large_file_overrides = { providers = { 'lsp' } },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
      local function map(key, dir, buffer)
        vim.keymap.set('n', key, function()
          require('illuminate')['goto_' .. dir .. '_reference'](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
      end
      map(']]', 'next')
      map('[[', 'prev')
      -- Set it after loading ftplugins
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map(']]', 'next', buffer)
          map('[[', 'prev', buffer)
        end,
      })
    end,
    keys = { { ']]', desc = 'Next Reference' }, { '[[', desc = 'Prev Reference' } },
  },

  -- vim-cool
  { 'romainl/vim-cool',      keys = { '/', '?', '*', '#', 'g*', 'g#', 'n', 'N' } },
  -- HACK: There doesn't seem to be an autocommand event to detect when you start
  -- searching, so this will have to do until I can find an event for that or until neovim creates that event
  -- Related: https://github.com/neovim/neovim/issues/18879

  -- toggleterm.nvim
  { import = 'plugins.toggleterm' },

  -- BufOnly.nvim
  { 'numToStr/BufOnly.nvim',       keys = { { '<leader>bD', '<cmd>BufOnly<CR>', desc = 'Delete all other buffers' } } },

  -- highlight-undo.nvim
  { 'tzachar/highlight-undo.nvim', keys = { 'u', '<C-r>' },                                                           config = true },

  -- undotree
  {
    'mbbill/undotree',
    keys = { { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = 'Open undo tree' } },
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
    end,
  },

  -- better-escape.nvim
  {
    'max397574/better-escape.nvim',
    event = 'InsertCharPre',
    opts = {
      mapping = { 'jj', 'jk' },
      keys = function()
        return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
      end,
      timeout = 300,
    },
  },

  -- persistence.nvim
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      -- stylua: ignore start
      { '<leader>qs', function() return require('persistence').load() end,                desc = 'Restore the session for the current dir' },
      { '<leader>ql', function() return require('persistence').load({ last = true }) end, desc = 'Restore the last session' },
      { '<leader>qd', function() return require('persistence').stop() end,                desc = 'Stop persistence' },
      -- stylua: ignore end
    },
  },

  -- vim-kitty
  -- { 'fladson/vim-kitty', ft = 'kitty' },

}
