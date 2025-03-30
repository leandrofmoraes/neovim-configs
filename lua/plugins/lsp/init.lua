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

    -- local servers = {
    --   ["yamlls"]   = require("plugins.lsp.languages.yamlls").yaml,
    -- }
    --
    -- for server, configs in pairs(servers) do
    --   configure_server(server, configs)
    -- end

    -- Managing language servers individually

    -- configure_server( 'marksman', require("plugins.lsp.languages.marksman").markdown)
    configure_server('marksman', require("plugins.lsp.languages.marksman").markdown)

    configure_server('lua_ls', require("plugins.lsp.languages.lua_ls").lua)

    configure_server('hyprls', require("plugins.lsp.languages.hyprls").hyprls)

    configure_server('clangd', require("plugins.lsp.languages.clangd").clangd)

    configure_server('cmake', require("plugins.lsp.languages.cmake").cmake)

    configure_server('html', require("plugins.lsp.languages.html").html)

    configure_server('emmet_ls', require("plugins.lsp.languages.emmet_ls").emmet)

    configure_server("vtsls", require("plugins.lsp.languages.vtsls").vtsls)

    configure_server('bashls', require("plugins.lsp.languages.bashls").bashls)

    configure_server('taplo', require("plugins.lsp.languages.taplo").taplo)

    configure_server('sqlls', require("plugins.lsp.languages.sqlls").sqlls)

    configure_server('jsonls', require("plugins.lsp.languages.jsonls").jsonls)

    configure_server('yamlls', require("plugins.lsp.languages.yamlls").yamlls)

    configure_server('lemminx', require("plugins.lsp.languages.lemminx").lemminx)

    configure_server('tailwindcss', require("plugins.lsp.languages.tailwindcss").tailwindcss)

    configure_server('dockerls', require("plugins.lsp.languages.dockerls").dockerls)

    configure_server(
      'docker_compose_language_service',
      require("plugins.lsp.languages.docker_compose_language_service").docker_compose_language_service
    )

    -- configure_server("arduino-language-server", require("plugins.lsp.languages.arduino_language_server").arduino)

    -- configure_server( 'angularls', require("plugins.lsp.languages.angularls").angularls) -- Uncomment this line to enable Angular Language Server
    -- configure_server( 'pyright', require("plugins.lsp.languages.pyright").pyright) -- Uncomment this line to enable Pyright Language Server

    configure_server('eslint', {
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
    })

    -- if Util.lsp.get_config("denols") and Util.lsp.get_config("tsserver") then
    --   local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
    --   Util.lsp.disable("tsserver", is_deno)
    --   Util.lsp.disable("denols", function(root_dir)
    --     return not is_deno(root_dir)
    --   end)
    -- end

    -- rust_analyzer
    -- lspconfig.rust_analyzer.setup({
    --   capabilities = capabilities,
    --   -- Server-specific settings. See `:help lspconfig-setup`
    --   settings = {
    --     ['rust-analyzer'] = {},
    --   },
    -- })

    -- tsserver
    -- lspconfig.tsserver.setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   -- settings = {
    --   --   completions = {
    --   --     completeFunctionCalls = true
    --   --   }
    --   -- }
    -- })

    -- -- html
    -- lspconfig.html.setup({
    --   capabilities = capabilities,
    -- })
  end,
}
