return {
  -- Comment.nvim
  {
    'numToStr/Comment.nvim',
    config = true,
    keys = {
      { 'gc', mode = { 'n', 'v' }, desc = 'Toggle comments' },
      { 'gb', mode = { 'n', 'v' }, desc = 'Toggle block comments' },
    },
  },

  -- mini.ai
  {
    'echasnovski/mini.ai',
    keys = { { 'a', mode = { 'x', 'o' } }, { 'i', mode = { 'x', 'o' } } },
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
        },
      }
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    -- install with yarn or npm
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- {
  --   "soulis-1256/hoverhints.nvim"
  -- },

  {
    'barrett-ruth/live-server.nvim',
    build = 'yarn global add live-server',
    config = true,
  },
  {
    'simrat39/symbols-outline.nvim',
    config = function()
      require('symbols-outline').setup()
    end,
  },
  {
    'tpope/vim-fugitive',
    cmd = {
      'G',
      'Git',
      'Gdiffsplit',
      'Gread',
      'Gwrite',
      'Ggrep',
      'GMove',
      'GDelete',
      'GBrowse',
      'GRemove',
      'GRename',
      'Glgrep',
      'Gedit',
    },
    ft = { 'fugitive' },
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      -- 'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('octo').setup()
    end,
  },
  { 'rstacruz/sparkup' },
  -- { 'mattn/emmet-vim' },
  { "olrtg/nvim-emmet" },

  {
    enabled = false,
    "lunarvim/bigfile.nvim",
    event = { "FileReadPre", "BufReadPre", "User FileOpened" },
  },
}
