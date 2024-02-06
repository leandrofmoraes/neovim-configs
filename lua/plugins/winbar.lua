return {
  -- {
  --   "Bekaboo/dropbar.nvim",
  --   name = "dropbar",
  --   event = { "BufReadPost", "BufNewFile" },
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   opts = {
  --     bar = {
  --       sources = function(buf, _)
  --         local sources = require "dropbar.sources"
  --         local utils = require "dropbar.utils"
  --
  --         local filename = {
  --           get_symbols = function(buff, win, cursor)
  --             local path = sources.path.get_symbols(buff, win, cursor)
  --             return { path[#path] }
  --           end,
  --         }
  --
  --         if vim.bo[buf].ft == "markdown" then
  --           return {
  --             filename,
  --             utils.source.fallback {
  --               sources.treesitter,
  --               sources.markdown,
  --               sources.lsp,
  --             },
  --           }
  --         else
  --           return {
  --             filename,
  --             utils.source.fallback {
  --               sources.lsp,
  --               sources.treesitter,
  --             },
  --           }
  --         end
  --       end,
  --     },
  --   }
  -- },

  -- nvim-navic
  {
    enabled = false,
    'SmiteshP/nvim-navic',
    requires = 'neovim/nvim-lspconfig',
    event = 'LspAttach',
    -- event = 'User FileOpened',
    opts = {
      highlight = true,
      lsp = { auto_attach = true },
      lazy_update_context = true,
      icons = require('core.icons').kind,
      -- icons = {
      --   Array = ' ',
      --   Boolean = ' ',
      --   Class = ' ',
      --   Color = ' ',
      --   Constant = ' ',
      --   Constructor = ' ',
      --   Copilot = ' ',
      --   Enum = ' ',
      --   EnumMember = ' ',
      --   Event = ' ',
      --   Field = ' ',
      --   File = ' ',
      --   Folder = ' ',
      --   Function = ' ',
      --   Interface = ' ',
      --   Key = ' ',
      --   Keyword = ' ',
      --   Method = ' ',
      --   Module = ' ',
      --   Namespace = ' ',
      --   Null = ' ',
      --   Number = ' ',
      --   Object = ' ',
      --   Operator = ' ',
      --   Package = ' ',
      --   Property = ' ',
      --   Reference = ' ',
      --   Snippet = ' ',
      --   String = ' ',
      --   Struct = ' ',
      --   Text = ' ',
      --   TypeParameter = ' ',
      --   Unit = ' ',
      --   Value = ' ',
      --   Variable = ' ',
      -- },
      on_attach = function(client, bufnr)
        local navic = require('nvim-navic')
        -- navic.attach(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
      end,
    },
  },

  -- {
  --   'LunarVim/breadcrumbs.nvim',
  --   dependencies = { 'SmiteshP/nvim-navic' },
  --   -- event = 'User FileOpened',
  --   opts = {
  --     lsp = {
  --       auto_attach = true,
  --     },
  --   },
  -- },

  {
    enabled = false,
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      -- 'nvim-tree/nvim-web-devicons', -- optional dependency
    },
    event = 'LspAttach',
    opts = {
      attach_navic = false,
      exclude_filetypes = {
        'gitcommit',
        'toggleterm',
        'nvim-tree',
      },
    },
  },
}
