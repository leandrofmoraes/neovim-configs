-- Define os sinais para os diagnósticos
-- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
-- for type, icon in pairs(signs) do
--   local hl = "DiagnosticSign" .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
-- end

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    -- "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- "nvim-java/nvim-java",
    -- "mason.nvim",
  },
  -- config = function()
  -- require('lspconfig.ui.windows').default_options.border = 'rounded'
  opts = {
    inlay_hints = {
      enabled = true,
      exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
    },
    -- provide the code lenses.
    code_lens_refresh = true,
    codelens = { enabled = true },
    -- add any global capabilities here
    -- servers = {
    --   marksman = {},
    -- },
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
  },

  -- nlsp_settings = {
  --   setup = {
  --     config_home = join_paths(config_dir, "lsp-settings"),
  --     -- set to false to overwrite schemastore.nvim
  --     append_default_schemas = true,
  --     ignored_servers = {},
  --     loader = "json",
  --   },
  -- },

  -- null_ls = {
  --   setup = {
  --     debug = false,
  --   },
  --   config = {},
  -- },

  -- templates_dir = join_paths(runtime_dir, "site", "after", "ftplugin"),

  -- automatic_configuration = {
  --   ---@usage list of servers that the automatic installer will skip
  --   skipped_servers = skipped_servers,
  --   ---@usage list of filetypes that the automatic installer will skip
  --   skipped_filetypes = skipped_filetypes,
  -- },
  -- },

  -- config = function()
  config = function()
    -- local lspconfig = require('lspconfig')
    local configure_server = require("plugins.lsp.lsp_attach").configure_server

    -- load custom server configurations
    configure_server('arduino_language_server', require("plugins.lsp.languages.arduino_language_server").arduino)
    -- configure_server( 'marksman', require("plugins.lsp.languages.marksman").markdown)

    local servers = {
      --   ["yamlls"]   = require("plugins.lsp.languages.yamlls").yaml,
      ['marksman'] = require("plugins.lsp.languages.marksman").markdown,
      ['lua_ls'] = require("plugins.lsp.languages.lua_ls").lua,
      ['hyprls'] = require("plugins.lsp.languages.hyprls").hyprls,
      -- ['clangd'] = require("plugins.lsp.languages.clangd").clangd,
      ['cmake'] = require("plugins.lsp.languages.cmake").cmake,
      ['html'] = require("plugins.lsp.languages.html").html,
      ['emmet_ls'] = require("plugins.lsp.languages.emmet_ls").emmet,
      ["vtsls"] = require("plugins.lsp.languages.vtsls").vtsls,
      ['bashls'] = require("plugins.lsp.languages.bashls").bashls,
      ['taplo'] = require("plugins.lsp.languages.taplo").taplo,
      ['sqlls'] = require("plugins.lsp.languages.sqlls").sqlls,
      ['jsonls'] = require("plugins.lsp.languages.jsonls").jsonls,
      ['yamlls'] = require("plugins.lsp.languages.yamlls").yamlls,
      ['lemminx'] = require("plugins.lsp.languages.lemminx").lemminx,
      ['tailwindcss'] = require("plugins.lsp.languages.tailwindcss").tailwindcss,
      ['dockerls'] = require("plugins.lsp.languages.dockerls").dockerls,
      ['docker_compose_language_service'] =
          require("plugins.lsp.languages.docker_compose_language_service").docker_compose_language_service,
      -- configure_server( 'angularls', require("plugins.lsp.languages.angularls").angularls) -- Uncomment this line to enable Angular Language Server
      ['eslint'] = {
        filetypes = {
          'graphql',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        settings = { format = false },
        on_attach = function(_, bufnr)
          vim.keymap.set(
            'n',
            '<leader>ce',
            '<cmd>EslintFixAll<cr>',
            { desc = 'Fix all ESLint errors', buffer = bufnr }
          )
        end,
      },
    }

    -- Estado para evitar reconfigurações repetidas

    local clients_configured = {}

    vim.lsp.handlers['client/registerCapability'] = (function(overridden)
      return function(err, res, ctx)
        local result = overridden(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)

        if not client or clients_configured[client.id] then
          return result
        end

        local server_config = servers[client.name]
        if server_config then
          local ok, err_msg = pcall(configure_server, client.name, server_config)
          if ok then
            clients_configured[client.id] = true
          else
            vim.notify(("Erro ao configurar LSP %s: %s"):format(
              client.name, tostring(err_msg)), vim.log.levels.ERROR)
          end
        end

        return result
      end
    end)(vim.lsp.handlers['client/registerCapability'])
  end,
}
