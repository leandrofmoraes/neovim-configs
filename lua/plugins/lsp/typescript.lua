-- local lspconfig = require('lspconfig')
return {

  -- add typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          -- keys = {
          --   {
          --     "<leader>Jo",
          --     function()
          --       vim.lsp.buf.code_action({
          --         apply = true,
          --         context = {
          --           only = { "source.organizeImports.ts" },
          --           diagnostics = {},
          --         },
          --       })
          --     end,
          --     desc = "Organize Imports",
          --   },
          --   {
          --     "<leader>JR",
          --     function()
          --       vim.lsp.buf.code_action({
          --         apply = true,
          --         context = {
          --           only = { "source.removeUnused.ts" },
          --           diagnostics = {},
          --         },
          --       })
          --     end,
          --     desc = "Remove Unused Imports",
          --   },
          -- },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
    },
  },

  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --
  --   -- local lspconfig = require "user.lspconfig"
  --   config = {
  --     on_attach = function(client, bufnr)
  --       lspconfig.on_attach(client, bufnr)
  --       client.server_capabilities.documentFormattingProvider = false
  --       client.server_capabilities.documentRangeFormattingProvider = false
  --     end,
  --     capabilities = lspconfig.common_capabilities(),
  --     -- settings = {
  --     -- spawn additional tsserver instance to calculate diagnostics on it
  --     separate_diagnostic_server = true,
  --     expose_as_code_action = "all",
  --     -- tsserver_plugins = {},
  --     tsserver_max_memory = "auto",
  --     -- complete_function_calls = true,
  --     include_completions_with_insert_text = true,
  --     -- code_lens = "all",
  --     -- disable_member_code_lens = true,
  --
  --     -- described below
  --     -- tsserver_format_options = {},
  --
  --     tsserver_file_preferences = {
  --       includeInlayParameterNameHints = "all", -- "none" | "literals" | "all";
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayVariableTypeHints = true,
  --       includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayEnumMemberValueHints = true,
  --
  --       includeCompletionsForModuleExports = true,
  --       quotePreference = "auto",
  --
  --       -- autoImportFileExcludePatterns = { "node_modules/*", ".git/*" },
  --     },
  --
  --     jsx_close_tag = {
  --       enable = true,
  --       filetypes = { "javascriptreact", "typescriptreact" },
  --     },
  --   },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            -- 💀 Make sure to update this path to point to your installation
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
}
