-- cmp_config.lua
-- Para ativar, defina: vim.g.my_active_completion = "nvim-cmp" em core.options
return {
  { --* the completion engine *--
    -- "iguanacucumber/magazine.nvim",
      'hrsh7th/nvim-cmp',
    --   -- commit = 'abacd4cb7ffd640b558845b617cfca1692dcb1a6',
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
    cond = vim.g.my_active_completion == "nvim-cmp",
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-nvim-lua', -- Completa para API do Neovim
      'hrsh7th/cmp-nvim-lsp', -- Integração com LSP
      'hrsh7th/cmp-cmdline', -- Complemento para a linha de comando
      'hrsh7th/cmp-buffer',   -- Completa texto do buffer -- source for text in buffer

      -- With magazine.nvim
      -- { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      -- { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
      -- { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
      -- { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },

      'hrsh7th/cmp-calc', -- Complemento de cálculos
      'hrsh7th/cmp-path',     -- Completa caminhos de arquivos -- source for file system paths
      'windwp/nvim-autopairs', -- Auto-inserção de pares (parênteses, aspas, etc.)
      'onsails/lspkind.nvim', -- Ícones no estilo VSCode -- vs-code like pictograms
      'saadparwaiz1/cmp_luasnip', -- Suporte para LuaSnip -- For luasnip users.
      -- 'hrsh7th/cmp-nvim-lsp-signature-help',
      'dmitmel/cmp-digraphs',
      "folke/lazydev.nvim",
      -- Suporte para vsnip -- For vsnip users
      -- 'hrsh7th/cmp-vsnip',
      -- 'hrsh7th/vim-vsnip',
      {
        'rafamadriz/friendly-snippets', -- useful snippets
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
      { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp', version = 'v2.*', config = true },
    },
    config = function()
      -- Chama a configuração modular definida em config/cmp_config.lua
      require("plugins.nvim-cmp.cmp_config").setup()
    end,
  }
}
