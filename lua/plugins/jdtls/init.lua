return {
  {
    "mfussenegger/nvim-jdtls",
    enabled = true,
    dependencies = {
      "folke/which-key.nvim",
    },
    ft = { "java" },
    opts = function()
      return {
        filetypes = { 'java' },
        -- How to find the root dir for a given filename. The default comes from
        -- lspconfig which provides a function specifically for java projects.
        -- root_dir = require("lspconfig").jdtls.document_config.default_config.root_dir,
        -- root_dir = require('lspconfig.configs.jdtls').default_config.root_dir(),
        -- root_dir = require("lspconfig.server_configurations.jdtls").default_config.root_dir,
        -- root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
        -- root_dir = vim.fs.root(0, {".git", "mvnw", "gradlew"}),
        -- root_dir = root_markers or vim.fn.getcwd(),
        -- root_dir = function()
        root_dir = function()
          -- local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
          -- local fname = vim.api.nvim_buf_get_name(0)
          local root_markers = {
            -- Multi-module projects
            -- '.git',
            'build.gradle',
            'build.gradle.kts',
            -- Single-module projects
            'build.xml',           -- Ant
            'pom.xml',             -- Maven
            'settings.gradle',     -- Gradle
            'settings.gradle.kts', -- Gradle
          }
          -- return require("lspconfig").jdtls.document_config.default_config.root_dir,
          local root = vim.fs.root(0, root_markers)
          -- if root then
          -- return vim.fs.dirname(root)
          return root
          -- else
          -- Se não encontrar um root baseado nos marcadores, usa o diretório atual
          -- return vim.fn.getcwd()
          -- return vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
          -- end

          -- return vim.fs.root(0, root_markers)
        end,

        -- How to find the project name for a given root dir.
        -- project_name = function(root_dir)
        --   -- return vim.fs.basename(root_dir)
        --   return root_dir and vim.fs.basename(root_dir)
        -- end,
        -- local fname = vim.api.nvim_buf_get_name(args.buf)
        --   local root_dir = require('lspconfig.configs.jdtls').default_config.root_dir(fname)
        --   local project_name = root_dir and vim.fs.basename(root_dir)
        --   if project_name then
        --   vim.list_extend(cmd, {
        --     '-data',
        --     vim.fn.stdpath 'cache' .. '/jdtls/' .. project_name .. '/workspace',
        --   })
        -- end

        single_file_support = true,
        project_name = function(root_dir)
          -- -- Uncomment if you want to use the parent directory name as the project name. (Util in sigle_file projects)
          -- if not root_dir then
          --   return vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
          -- end

          -- Is Eclipse workspace?
          -- if vim.fn.isdirectory(root_dir .. "/.metadata") == 1 then
          --   return vim.fs.basename(root_dir:match("(.*)/workspace$") or root_dir)
          -- end

          -- Or Maven/Gradle projects
          return vim.fs.basename(root_dir)
          -- return root_dir and vim.fs.basename(root_dir)
        end,

        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          -- return "/tmp/nvim/jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,

        -- How to run jdtls. This can be overridden to a full java command-line
        -- if the Python wrapper script doesn't suffice.
        cmd = { vim.fn.exepath("jdtls") },
        -- These depend on nvim-dap, but can additionally be disabled by setting false here.
        dap = { hotcodereplace = "auto", config_overrides = {} },
        dap_main = {},
        test = true,
        -- settings = {
        --   java = {
        --   },
        -- },
      }
    end,
    config = function()
      -- delegate to lsp_attach
      local config = require("plugins.jdtls.java_config").get_config()
      require("plugins.lsp.lsp_attach").configure_server("jdtls", config)
    end
  },
}
