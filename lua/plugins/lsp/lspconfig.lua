local Util = require("lazyvim.util")
-- local config_dir = vim.call("stdpath", "config")
local runtime_dir = vim.call("stdpath", "data")

-- local skipped_servers = {
--   "angularls",
--   "ansiblels",
--   "antlersls",
--   "azure_pipelines_ls",
--   "ccls",
--   "omnisharp",
--   "cssmodules_ls",
--   "denols",
--   "docker_compose_language_service",
--   "ember",
--   "emmet_ls",
--   "eslint",
--   "eslintls",
--   "glint",
--   "golangci_lint_ls",
--   "gradle_ls",
--   "graphql",
--   "java_language_server",
--   "jedi_language_server",
--   "ltex",
--   "neocmake",
--   "ocamlls",
--   "phpactor",
--   "psalm",
--   "pylsp",
--   "pylyzer",
--   "pyre",
--   "quick_lint_js",
--   "reason_ls",
--   "rnix",
--   "rome",
--   "ruby_ls",
--   "ruff_lsp",
--   "scry",
--   "solang",
--   "solc",
--   "solidity_ls",
--   "sorbet",
--   "sourcekit",
--   "sourcery",
--   "spectral",
--   "sqlls",
--   "sqls",
--   "standardrb",
--   "stylelint_lsp",
--   "svlangserver",
--   "tflint",
--   "unocss",
--   "verible",
--   "vtsls",
--   "vuels",
-- }
-- local skipped_filetypes = { "markdown", "rst", "plaintext", "toml", "proto" }

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
  local uv = vim.loop
  local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"
  local result = table.concat({ ... }, path_sep)
  return result
end

return {
  'neovim/nvim-lspconfig',
  -- commit = '4d38bec',
  -- commit = '5e54173da4e0ffd8e9559c0a1fddfb3b7df97bec',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "mason.nvim",
    { "folke/neodev.nvim",  lazy = true,     opts = {} },
    { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
  },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        -- prefix = "icons",
      },
      severity_sort = true,
    },
    -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the inlay hints.
    -- inlay_hints = {
    --   enabled = false,
    -- },

    -- nlsp_settings = {
    --   setup = {
    --     config_home = join_paths(config_dir, "lsp-settings"),
    --     -- set to false to overwrite schemastore.nvim
    --     append_default_schemas = true,
    --     ignored_servers = {},
    --     loader = "json",
    --   },
    -- },

    null_ls = {
      setup = {
        debug = false,
      },
      config = {},
    },

    templates_dir = join_paths(runtime_dir, "site", "after", "ftplugin"),
    code_lens_refresh = true,

    -- automatic_configuration = {
    --   ---@usage list of servers that the automatic installer will skip
    --   skipped_servers = skipped_servers,
    --   ---@usage list of filetypes that the automatic installer will skip
    --   skipped_filetypes = skipped_filetypes,
    -- },
  },

  -- config = function()
  config = function(_, opts)
    local lspconfig = require('lspconfig')
    local lspui = require('lspconfig.ui.windows')
    -- local cmp_nvim_lsp = require('cmp_nvim_lsp')

    -- local capabilities = cmp_nvim_lsp.default_capabilities()
    -- setup_codelens_refresh(capabilities.client, capabilities.bufnr)

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.completion.completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }

    -- local on_attach = function(_, bufnr)
    --
    --   local lsp_signature = require("lsp_signature")
    --   local lsp_signature_setup = {
    --     hint_enable = false,
    --     handler_opts = {
    --       border = "none",
    --     },
    --     padding = " ",
    --   }
    --   lsp_signature.on_attach(lsp_signature_setup, bufnr)
    -- end

    -- local on_attach = function(client, bufnr)
    --   local status_ok, codelens_supported = pcall(function()
    --     return client.supports_method "textDocument/codeLens"
    --   end)
    --   if not status_ok or not codelens_supported then
    --     return
    --   end
    --   local group = "lsp_code_lens_refresh"
    --   local cl_events = { "BufEnter", "InsertLeave" }
    --   local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    --     group = group,
    --     buffer = bufnr,
    --     event = cl_events,
    --   })
    --
    --   if ok and #cl_autocmds > 0 then
    --     return
    --   end
    --   vim.api.nvim_create_augroup(group, { clear = false })
    --   vim.api.nvim_create_autocmd(cl_events, {
    --     group = group,
    --     buffer = bufnr,
    --     callback = vim.lsp.codelens.refresh,
    --   })
    -- end

    local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    if Util.has("neoconf.nvim") then
      local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
      require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
    end

    -- Auto Formatting
    lspconfig.autoformat = false
    -- vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])

    --LspInfo Borders
    lspui.default_options.border = 'double'

    -- Managing language servers individually
    -- pyright
    lspconfig.pyright.setup({
      capabilities = capabilities,
    })

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
    -- if Util.lsp.get_config("denols") and Util.lsp.get_config("tsserver") then
    --   local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
    --   Util.lsp.disable("tsserver", is_deno)
    --   Util.lsp.disable("denols", function(root_dir)
    --     return not is_deno(root_dir)
    --   end)
    -- end

    -- VTSLS
    lspconfig.vtsls.setup({
      capabilities = capabilities,
      ft = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      -- enabled = not env.NVIM_USER_USE_TSSERVER,
      dependencies = { "nvim-lspconfig" },
    })

    -- rust_analyzer
    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      -- Server-specific settings. See `:help lspconfig-setup`
      settings = {
        ['rust-analyzer'] = {},
      },
    })

    -- configure sql server
    lspconfig["sqlls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(_)
        return vim.loop.cwd()
      end,
    })

    lspconfig.jsonls.setup({
      capabilities = capabilities,
    })

    lspconfig.yamlls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.taplo.setup({
      capabilities = capabilities,
    })

    lspconfig.marksman.setup({
      capabilities = capabilities,
    })

    lspconfig.lemminx.setup({
      capabilities = capabilities,
    })

    -- Lua LS
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          completion = {
            callSnippet = "Replace"
          }
        },
      },
    })

    -- html
    lspconfig.html.setup({
      capabilities = capabilities,
    })

    -- configure emmet language server

    -- lspconfig.emmet_ls.setup({
    --   -- on_attach = on_attach,
    --   capabilities = capabilities,
    --   filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
    --   init_options = {
    --     html = {
    --       options = {
    --         -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
    --         ["bem.enabled"] = true,
    --       },
    --     },
    --   }
    -- })

    lspconfig.emmet_language_server.setup({
      filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
      -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
      -- **Note:** only the options listed in the table are supported.
      init_options = {
        ---@type table<string, string>
        includeLanguages = {},
        --- @type string[]
        excludeLanguages = {},
        --- @type string[]
        extensionsPath = {},
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
        preferences = {},
        --- @type boolean Defaults to `true`
        showAbbreviationSuggestions = true,
        --- @type "always" | "never" Defaults to `"always"`
        showExpandedAbbreviation = "always",
        --- @type boolean Defaults to `false`
        showSuggestionsAsSnippets = false,
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
        syntaxProfiles = {},
        --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
        variables = {},
      },
    })

    -- CSS LS
    lspconfig.cssls.setup({
      capabilities = capabilities,
    })

    -- Tailwind
    -- Support for tailwind auto completion
    -- install the tailwind server : "sudo npm install -g @tailwindcss/language-server"
    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
    })

    -- Angular
    -- lspconfig.angularls.setup({
    --   capabilities = capabilities,
    -- })

    -- Dockerfile
    lspconfig.dockerls.setup({
      capabilities = capabilities,
    })

    -- Java
    -- lspconfig.jdtls.setup({
    --   capabilities = capabilities,
      -- on_attach = on_attach,
    -- })

    -- -- -- C/C++
    lspconfig.clangd.setup({

      -- keys = {
      --   { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch source/header (C/C++)" },
      -- },
      on_attach = on_attach,
      root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
          "Makefile",
          "configure.ac",
          "configure.in",
          "config.h.in",
          "meson.build",
          "meson_options.txt",
          "build.ninja"
        )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
            fname
          ) or require("lspconfig.util").find_git_ancestor(fname)
      end,
      capabilities = {
        offsetEncoding = { "utf-16" },
        textDocument = {
          completion = {
            completionItem = {
              commitCharactersSupport = true,
              insertReplaceSupport = true,
              snippetSupport = true,
              deprecatedSupport = true,
              labelDetailsSupport = true,
              preselectSupport = false,
              resolveSupport = {
                properties = { "documentation", "detail", "additionalTextEdits" },
              },
              tagSupport = {
                valueSet = { 1 },
              },
            },
          },
        },
      },
      cmd = {
        "clangd",
        "--clang-tidy",
        "--background-index",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--enable-config",
        -- '--offset-encoding=utf-16',

        -- Resolve standard include paths for cross-compilation targets
        -- "--query-driver=/usr/sbin/arm-none-eabi-gcc,/usr/sbin/aarch64-linux-gnu-gcc",

        -- Auto-format only if .clang-format exists
        "--fallback-style=none",
        -- "--fallback-style=llvm",
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
      -- },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      }
    })


    -- lspconfig.clangd.setup({
    --   on_attach = on_attach,
    --   root_dir = function(fname)
    --     return require("lspconfig.util").root_pattern(
    --       "Makefile",
    --       "configure.ac",
    --       "configure.in",
    --       "config.h.in",
    --       "meson.build",
    --       "meson_options.txt",
    --       "build.ninja"
    --     )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
    --       fname
    --     ) or require("lspconfig.util").find_git_ancestor(fname)
    --   end,
    --   -- capabilities = require('cmp_nvim_lsp').default_capabilities(),
    --   capabilities = {
    --     offsetEncoding = { "utf-16" },
    --   },
    --   cmd = {
    --     "clangd",
    --     "--background-index",
    --     "--clang-tidy",
    --     "--header-insertion=iwyu",
    --     "--completion-style=detailed",
    --     "--function-arg-placeholders",
    --     "--fallback-style=llvm",
    --     -- '--offset-encoding=utf-16',
    --   },
    --   init_options = {
    --     usePlaceholders = true,
    --     completeUnimported = true,
    --     clangdFileStatus = true,
    --   },
    --   setup = {
    --     clangd = function(_, opts)
    --       local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
    --       require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
    --       return false
    --     end,
    --   },
    -- })

    -- Tailwind
    -- Support for tailwind auto completion
    -- install the tailwind server : "sudo npm install -g @tailwindcss/language-server"
    lspconfig.tailwindcss.setup({
      -- capabilities = capabilities,
      capabilities = capabilities,
    })

    lspconfig.bashls.setup({
      -- capabilities = capabilities,
      capabilities = capabilities,
      filetypes = { 'sh', 'zsh', 'bash' },
      cmd_env = {
        INCLUDE_ALL_WORKSPACE_SYMBOLS = true,
      },
    })
  end,
}
