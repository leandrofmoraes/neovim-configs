return {
  {
    "williamboman/mason.nvim",
    -- dependencies = {
    -- "williamboman/mason-lspconfig.nvim",
    -- 	"WhoIsSethDaniel/mason-tool-installer.nvim",
    -- },

    -- config = function()
    --   local mason = require("mason")
    --   mason.setup({
    -- build = function()
    --   pcall(function()
    --     require("mason-registry").refresh()
    --   end)
    -- end,
    -- lazy = true,
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    opts = {
      ---@type string[]
      ensure_installed = {
        -- Formatters
        "stylua",               -- Lua
        -- "prettier",                 -- JavaScript/TypeScript/HTML/CSS
        "shfmt",                -- Shell
        "beautysh",             -- Shell
        "clang-format",         -- C/C++
        "cmakelang",            -- CMake
        "mdformat",             -- Markdown
        "yamlfmt",              -- YAML
        -- Linters
        "eslint_d",             -- JavaScript/TypeScript
        "hadolint",             -- Docker
        "shellcheck",           -- Shell
        "yamllint",             -- YAML
        -- "markdownlint",             -- Markdown
        "markdownlint-cli2",    -- Markdown
        "markdown-toc",         -- Markdown
        "jsonlint",             -- JSON
        "cpplint",              -- C++
        "editorconfig-checker", -- EditorConfig
        "stylelint",            -- CSS
        -- Debuggers
        "codelldb",             -- C/C++/Rust
        "java-debug-adapter",   -- Java
        "java-test",            -- Java
        "js-debug-adapter",     -- JavaScript/TypeScript
        -- Tools diversas
        "glow",                 -- Visualizador Markdown
      },
      -- ---@type boolean
      -- automatic_installation = true,
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "double",
        width = 0.8,
        height = 0.8,
      },
    },
    -- config = function(_, opts)
    --   require("mason").setup(opts)
    -- end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- lazy = true,
    -- event = "BufReadPre", -- or "BufReadPre" | "User FileOpened", "VeryLazy"
    dependencies = "mason.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    opts = {
      ensure_installed = {
        -- LSP Servers
        "bashls",   -- Bash
        "clangd",   -- C/C++
        "cssls",    -- CSS
        "dockerls", -- Docker
        "html",     -- HTML
        "emmet_ls", -- Emmet
        "jdtls",    -- Java
        "jsonls",   -- JSON
        "lua_ls",   -- Lua
        "hyprls",
        "eslint",
        "marksman",
        "docker_compose_language_service",
        "lemminx",
        "taplo",
        "html",
        "cmake",
        "sqlls",       -- SQL
        "tailwindcss", -- Tailwind CSS
        "vimls",       -- VimScript
        "vtsls",       -- JavaScript/TypeScript
        -- "volar",                    -- Vue (substituto do vtsls)
        "yamlls",      -- YAML
      },
      -- },
      -- config = function()
      --   require("mason-lspconfig").setup()
      --   -- automatic_installation is handled by lsp-manager
      --   local settings = require "mason-lspconfig.settings"
      --   settings.current.automatic_installation = false
      -- end,
      automatic_installation = true,

    }
  },
  -- { "tamago324/nlsp-settings.nvim",    cmd = "LspSettings", lazy = true },
  -- { "jose-elias-alvarez/null-ls.nvim", lazy = true },

  {
    enabled = false,
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- you can turn off/on auto_update per tool
        -- LSPs
        "bashls",
        "lua_ls",
        "vimls",
        "lua_ls",
        "clangd",
        -- Formatters/Linters
        "stylua",
        -- "prettier",
        -- "eslint_d",
        -- "marksman",
        -- 'shfmt',
        -- Debuggers
      },
    },
    auto_update = true,
    run_on_start = true,
    start_delay = 3000,  -- 3 second delay
    debounce_hours = 12, -- at least 5 hours between attempts to install/update
    integrations = {
      ['mason-lspconfig'] = true,
      ['mason-null-ls'] = true,
      ['mason-nvim-dap'] = true,
    }
  }
}
