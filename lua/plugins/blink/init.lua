-- Blink-cmp configuration. To activate, set: vim.g.my_active_completion = "blink"
-- For more information, see: https://cmp.saghen.dev/configuration/reference.html
local config = require("plugins.blink.blink_config")

return {
  {
    'saghen/blink.cmp',
    version = '0.*',
    cond = vim.g.my_active_completion == "blink", --Condição de carregamento
    dependencies = {
      "LuaSnip",
      "moyiz/blink-emoji.nvim",
      "MahanRahmati/blink-nerdfont.nvim",
      "dmitmel/cmp-digraphs", --source in compatbility mode with nvim-cmp
      "folke/lazydev.nvim",
      "rafamadriz/friendly-snippets",
      'ribru17/blink-cmp-spell',
      { 'L3MON4D3/LuaSnip',                version = 'v2.*' },
      {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
          { 'tpope/vim-dadbod',                     lazy = true },
          { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
        },
        cmd = {
          'DBUI',
          'DBUIToggle',
          'DBUIAddConnection',
          'DBUIFindBuffer',
        },
        init = function()
          -- Your DBUI configuration
          vim.g.db_ui_use_nerd_fonts = 1
        end,
      },
      { "giuxtaposition/blink-cmp-copilot" },
      -- { "tzachar/cmp-tabnine" },
      -- {
      --   'Kaiser-Yang/blink-cmp-dictionary',
      --   dependencies = {
      --     'nvim-lua/plenary.nvim',
      --     -- {'jeffa5/wordnet-ls', build = "cargo build --release",}
      --   }
      -- },
      {
        "saghen/blink.compat",
        version = '*',
        -- version = '2.3.0',
        lazy = true,
        opts = {
          -- Configuração mais explícita para integração com cmp-digraphs
          sources = {
            cmp_tabnine = { name = "cmp_tabnine" },
            digraphs = {
              name = "digraphs",
              -- priority = 30,  -- Prioridade similar ao cmp
              -- opts = {
              --   cache_digraphs_on_start = true,
              -- }
            },
          }
        }
      },
    },
    build = 'cargo +nightly build --release',
    -- event = 'InsertEnter',
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      keymap = {
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Right>'] = { 'accept', 'fallback' },
        ['<C-\\>'] = { 'hide', 'fallback' },
        ['<C-n>'] = { 'select_next', 'show' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<C-p>'] = { 'select_prev' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      },
      completion = {
        list = {
          max_items = 10,
          -- Insert items while navigating the completion list.
          selection = {
            preselect = false,
            auto_insert = false,

            -- or a function
            -- preselect = function(ctx)
            --     return not require('blink.cmp').snippet_active({ direction = 1 })
            -- end,
            -- auto_insert = function(ctx) return vim.bo.filetype ~= 'markdown' end,
          },
          cycle = {
            -- When `true`, calling `select_next` at the _bottom_ of the completion list
            -- will select the _first_ completion item.
            from_bottom = true,
            -- When `true`, calling `select_prev` at the _top_ of the completion list
            -- will select the _last_ completion item.
            from_top = true,
          },
        },
        menu = {
          -- auto_show = false,
          scrollbar = true,
          border = 'rounded',
          draw = {
            treesitter = { 'lsp' }, -- Use treesitter to highlight the label text for the given list of sources
            -- columns = { { "kind_icon", "kind" }, { "label", "label_description", gap = 1 } },
          }
        },
        documentation = config.documentation,
        ghost_text = {
          -- enabled = true,
          enabled = vim.g.ai_cmp or true,
          -- show_with_selection = true,
          -- show_without_selection = false,
          -- show_with_menu = false -- only show when menu is closed
          -- show_without_menu = true,
          -- hl_group = "CmpGhostText"  -- Garanta que o highlight existe
        },
        accept = {
          -- Write completions to the `.` register
          dot_repeat = true,
          -- Create an undo point when accepting a completion item
          create_undo_point = true,
          -- How long to wait for the LSP to resolve the item with additional information before continuing as-is
          resolve_timeout_ms = 100,
          -- Experimental auto-brackets support
          auto_brackets = {
            -- Whether to auto-insert brackets for functions
            enabled = true,
            -- Default brackets to use for unknown languages
            default_brackets = { '(', ')' },
            -- Overrides the default blocked filetypes
            override_brackets_for_filetypes = {},
            -- Synchronously use the kind of the item to determine if brackets should be added
            kind_resolution = {
              enabled = true,
              blocked_filetypes = { 'typescriptreact', 'javascriptreact', 'vue' },
            },
            -- Asynchronously use semantic token to determine if brackets should be added
            semantic_token_resolution = {
              enabled = true,
              -- blocked_filetypes = { 'java' },
              -- How long to wait for semantic tokens to return before assuming no brackets should be added
              timeout_ms = 400,
            },
          },
        },
      },
      snippets = {
        preset = 'default', -- 'default' | 'luasnip' | 'mini_snippets'
        -- Function to use when expanding LSP provided snippets
        expand = function(snippet) vim.snippet.expand(snippet) end,
        -- Function to use when checking if a snippet is active
        active = function(filter) return vim.snippet.active(filter) end,
        -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
        jump = function(direction) vim.snippet.jump(direction) end,
      },
      -- Disable command line completion:
      cmdline = { enabled = true },
      sources = {
        default = config.default_sources,
        providers = config.providers,
        -- per_filetype = {
        --   sql = { 'snippets', 'dadbod', 'buffer' },
        --   emoji = { 'markdown', 'config', 'text' },
        --   nerdfont = { 'markdown', 'config', 'text' },
        --   digraphs = { 'markdown', 'text' },
        -- },
      },
      signature = { enabled = true },
      appearance = {
        highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
        -- use_nvim_cmp_as_default = false,
        kind_icons = require("utils.icons").kind,
        nerd_font_variant = "mono",

        -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
        -- kind_icons = {
        --   Copilot = "",
        --   Text = '󰉿',
        --   Method = '󰊕',
        --   Function = '󰊕',
        --   Constructor = '󰒓',
        --
        --   Field = '󰜢',
        --   Variable = '󰆦',
        --   Property = '󰖷',
        --
        --   Class = '󱡠',
        --   Interface = '󱡠',
        --   Struct = '󱡠',
        --   Module = '󰅩',
        --
        --   Unit = '󰪚',
        --   Value = '󰦨',
        --   Enum = '󰦨',
        --   EnumMember = '󰦨',
        --
        --   Keyword = '󰻾',
        --   Constant = '󰏿',
        --
        --   Snippet = '󱄽',
        --   Color = '󰏘',
        --   File = '󰈔',
        --   Reference = '󰬲',
        --   Folder = '󰉋',
        --   Event = '󱐋',
        --   Operator = '󰪚',
        --   TypeParameter = '󰬛',
        -- },
      },
    },
  },
}
