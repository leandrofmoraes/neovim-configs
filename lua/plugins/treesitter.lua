return {
  -- nvim-treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      ensure_installed = {
        'lua',
        'luadoc',
        'luap',
        'cpp',
        'java',
        'markdown',
        'markdown_inline',
        'git_config',
        'git_rebase',
        'gitcommit',
        'gitignore',
        -- 'gitattributes',
        'diff',
        -- 'vim',
        'vimdoc',
        -- 'regex',
        'bash',
        'toml',
        'ssh_config',
      },
      -- highlight = { enable = true },
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
          -- Languages that have a single comment style
          typescript = "// %s",
          css = "/* %s */",
          scss = "/* %s */",
          html = "<!-- %s -->",
          svelte = "<!-- %s -->",
          vue = "<!-- %s -->",
          json = "",
        },
      },
      -- indent = { enable = true },
      indent = { enable = true, disable = { "yaml", "python" } },
      autotag = { enable = false },

      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      -- vim-matchup config
      matchup = { enable = true, include_match_words = true, enable_quotes = true },

    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      -- Use the bash ts parser for zsh
      vim.treesitter.language.register('bash', 'zsh')
    end,
  },

  -- nvim-treesitter-context
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   dependencies = 'nvim-treesitter/nvim-treesitter',
  --   event = { 'BufReadPost', 'BufNewFile' },
  --   config = true,
  -- },

  -- vim-matchup
  {
    'andymass/vim-matchup',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_matchparen_deferred = 1
    end,
  },

  -- treesj
  {
    -- enabled = false,
    'Wansmer/treesj',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = { max_join_length = 500 },
    keys = {
      -- stylua: ignore start
      { 'g/m', function() return require('treesj').toggle() end, desc = 'Toggle' },
      { 'g/j', function() return require('treesj').join() end,   desc = 'Join' },
      { 'g/s', function() return require('treesj').split() end,  desc = 'Split' },
      -- stylua: ignore end
    },
  },

  -- rainbow-delimiters.nvim
  {
    --   'hiphish/rainbow-delimiters.nvim',
    'HiPhish/rainbow-delimiters.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
  },

  -- { "p00f/nvim-ts-rainbow" },

  -- indent-blankline.nvim
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    commit = "3d08501caef2329aba5121b753e903904088f7e6", -- release v3.5.4
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = { char = '│', tab_char = '│' },
      scope = { enabled = false },
      exclude = { filetypes = { 'lazy', 'dashboard', 'mason' } },
    },
  },
}
