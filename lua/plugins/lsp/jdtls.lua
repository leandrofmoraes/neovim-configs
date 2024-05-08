local Util = require("lazyvim.util")

-- This is the same as in lspconfig.server_configurations.jdtls, but avoids
-- needing to require that when this module loads.
local java_filetypes = { "java" }

-- Add files/folders here that indicate the root of a project
-- local root_markers = {'.git', 'mvnw', 'gradlew'}
-- local root_markers = {'gradlew', 'pom.xml', '.git'}

local fname = vim.api.nvim_buf_get_name(0)
-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
local function extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
  end
  return config
end


-- local home = os.getenv('HOME')

return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "folke/which-key.nvim",
      "LazyVim/LazyVim",
    },
    ft = java_filetypes,
    opts = function()
      -- config = function()

      return {
        -- How to find the root dir for a given filename. The default comes from
        -- lspconfig which provides a function specifically for java projects.
        root_dir = require("lspconfig.server_configurations.jdtls").default_config.root_dir,
        -- root_dir = root_markers or vim.fn.getcwd(),

        -- How to find the project name for a given root dir.
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,

        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,

        -- How to run jdtls. This can be overridden to a full java command-line
        -- if the Python wrapper script doesn't suffice.
        cmd = {
          vim.fn.exepath("jdtls"),
          -- "jdtls",
          -- "--jvm-arg=" .. string.format("-javaagent:%s", vim.fn.expand "$MASON/share/jdtls/lombok.jar"),
        },
        full_cmd = function(opts)
          -- local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd = vim.deepcopy(opts.cmd)
          local home_dir = os.getenv('HOME')

          -- local get_lombok_javaagent = function()
          --   local fn = vim.fn
          --   local is_file_exist = function(path)
          --     local f = io.open(path, 'r')
          --     return f ~= nil and io.close(f)
          --   end
          --   local lombok_dir = os.getenv('HOME') .. "/.m2/repository/org/projectlombok/lombok/"
          --   local lombok_versions = io.popen('ls -1 "' .. lombok_dir .. '" | sort -r')
          --   if lombok_versions ~= nil then
          --     local lb_i, lb_versions = 0, {}
          --     for lb_version in lombok_versions:lines() do
          --       lb_i = lb_i + 1
          --       lb_versions[lb_i] = lb_version
          --     end
          --     lombok_versions:close()
          --     if next(lb_versions) ~= nil then
          --       local lombok_jar = fn.expand(string.format('%s%s/*.jar', lombok_dir, lb_versions[1]))
          --       if is_file_exist(lombok_jar) then
          --         return string.format('--jvm-arg=-javaagent:%s', lombok_jar)
          --       end
          --     end
          --   end
          --   return ''
          -- end
          --
          -- local lombok_javaagent = get_lombok_javaagent()

          if project_name then
            vim.list_extend(cmd, {
              "java", -- or '/path/to/java11_or_newer/bin/java'
              -- 'jdtls',
              -- depends on if `java` is in your $PATH env variable and if it points to the right version.
              "-Declipse.application=org.eclipse.jdt.ls.core.id1",
              "-Dosgi.bundles.defaultStartLevel=4",
              "-Declipse.product=org.eclipse.jdt.ls.core.product",
              "-Dlog.protocol=true",
              "-Dlog.level=ALL",
              "-Xms1g",
              "--add-modules=ALL-SYSTEM",
              "--add-opens",
              "java.base/java.util=ALL-UNNAMED",
              "--add-opens",
              "java.base/java.lang=ALL-UNNAMED",
              -- "--jvm-arg=-javaagent:" .. home_dir .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
              -- "--jvm-arg=-javaagent:" .. home_dir .. "/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar",
              "--jvm-arg=-javaagent:" .. home_dir .. "/.m2/repository/org/projectlombok/lombok/lombok-edge.jar",
              -- "-jar" .. home_dir .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
              -- "-jar",
              -- vim.fn.glob(home_dir .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar"),
              "-configuration",
              opts.jdtls_config_dir(project_name),
              "-data",
              opts.jdtls_workspace_dir(project_name),
            })
          end

          return cmd
        end,

        -- These depend on nvim-dap, but can additionally be disabled by setting false here.
        dap = { hotcodereplace = "auto", config_overrides = {} },
        test = true,
      }
    end,
    config = function()
      local opts = Util.opts("nvim-jdtls") or {}

      -- Find the extra bundles that should be passed on the jdtls command-line
      -- if nvim-dap is enabled with java debug/test.
      local mason_registry = require("mason-registry")
      local bundles = {} ---@type string[]
      if opts.dap and Util.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
        local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
        local java_dbg_path = java_dbg_pkg:get_install_path()
        local jar_patterns = {
          java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
        }
        -- java-test also depends on java-debug-adapter.
        if opts.test and mason_registry.is_installed("java-test") then
          local java_test_pkg = mason_registry.get_package("java-test")
          local java_test_path = java_test_pkg:get_install_path()
          vim.list_extend(jar_patterns, {
            java_test_path .. "/extension/server/*.jar",
          })
        end
        for _, jar_pattern in ipairs(jar_patterns) do
          for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
            table.insert(bundles, bundle)
          end
        end
      end

      -- local is_file_exist = function(path)
      --   local f = io.open(path, 'r')
      --   return f ~= nil and io.close(f)
      -- end
      --
      -- local home_dir = os.getenv('HOME')
      -- local get_lombok_javaagent = function()
      --   local lombok_dir = home_dir..'/.m2/repository/org/projectlombok/lombok/'
      --   local lombok_versions = io.popen('ls -1 "' .. lombok_dir .. '" | sort -r')
      --   if lombok_versions ~= nil then
      --     local lb_i, lb_versions = 0, {}
      --     for lb_version in lombok_versions:lines() do
      --       lb_i = lb_i + 1
      --       lb_versions[lb_i] = lb_version
      --     end
      --     lombok_versions:close()
      --     if next(lb_versions) ~= nil then
      --       local lombok_jar = vim.fn.expand(string.format('%s%s/*.jar', lombok_dir, lb_versions[1]))
      --       if is_file_exist(lombok_jar) then
      --         return string.format('--jvm-arg=-javaagent:%s', lombok_jar)
      --       end
      --     end
      --   end
      --   return ''
      -- end
      --
      -- local lombok_javaagent = get_lombok_javaagent()
      -- if (lombok_javaagent ~= '') then
      --   table.insert(opts.cmd, lombok_javaagent)
      -- end


      local function attach_jdtls()
        -- local fname = vim.api.nvim_buf_get_name(0)

        -- Configuration can be augmented and overridden by opts.jdtls
        local config = extend_or_override({
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          -- root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
          init_options = {
            bundles = bundles,
          },
          -- enable CMP capabilities
          capabilities = require("cmp_nvim_lsp").default_capabilities(),

          eclipse = {
            downloadSources = true,
          },
          maven = {
            downloadSources = true,
            updateSnapshots = true
          },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*"
            },
            overwrite = false,
            guessMethodArguments = true,
          };
          sources = {
            organizeImports = {
              starThreshold = 9999;
              staticStarThreshold = 9999;
            }
          };
          codeGeneration = {
            generateComments = true,
            useBlocks = true,
            hashCodeEquals = {
              userIntanceOf = true
            },
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
              codeStyle = "STRING_BUILDER_CHAINED"
            }
          };
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          inlayHints = {
            parameterNames = {
              enabled = true,
            },
          },
          --NOTE: experimental
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          -- format = {
          --   settings = {
          --     url = vim.fn.stdpath('config') .. '/rules/eclipse-java-google-style.xml',
          --     profile = 'GoogleStyle'
          --   }
          -- }
          -- signatureHelp = { enabled = true },
        }, opts.jdtls)

        -- Existing server will be reused if the root_dir matches.
        require("jdtls").start_or_attach(config)
        -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
      end

      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = java_filetypes,
        callback = attach_jdtls,
      })

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        -- pattern = { "*.java" },
        pattern = java_filetypes,
        callback = function()
          local _, _ = pcall(vim.lsp.codelens.refresh)
        end,
      })

      -- Setup keymap and dap after the lsp is fully attached.
      -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
      -- https://neovim.io/doc/user/lsp.html#LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            local wk = require("which-key")
            wk.register({
              ["<leader>c"] = { "+code" },
              ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Actions" },
              ['<leader>cA'] = {
                function()
                  return require('actions-preview').code_actions()
                end,
                "Action Preview"
              },
              ["<leader>cx"] = { name = "+extract" },
              ["<leader>cxv"] = { require("jdtls").extract_variable_all, "Extract Variable" },
              ["<leader>cxc"] = { require("jdtls").extract_constant, "Extract Constant" },
              ["gu"] = { require("jdtls").super_implementation, "Goto Super" },
              -- ["gU"] = { require("jdtls.tests").goto_subjects, "Goto Subjects" },
              ["<leader>co"] = { require("jdtls").organize_imports, "Organize Imports" },
              ["<leader>cr"] = { "<cmd>lua _RUN_CODE()<cr>", "Run Code" },
              ["<leader>ci"] = { "<cmd>lua _JAVA_TOGGLE()<cr>", "JShell" }
            }, { mode = "n", buffer = args.buf })
            wk.register({
              -- ["<leader>a"]  = { name = "+code" },
              ['<leader>c'] = { '+code' },
              ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Actions" },
              ['<leader>cA'] = {
                function()
                  return require('actions-preview').code_actions()
                end,
                "Action Preview"
              },
              ["<leader>cx"] = { name = "+extract" },
              ["<leader>cxm"] = {
                [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                "Extract Method",
              },
              ["<leader>cxv"] = {
                [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
                "Extract Variable",
              },
              ["<leader>cxc"] = {
                [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                "Extract Constant",
              },
            }, { mode = "v", buffer = args.buf })
            if opts.dap and Util.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
              -- custom init for Java debugger
              require("jdtls").setup_dap(opts.dap)
              require("jdtls.dap").setup_dap_main_class_configs()

              -- Java Test require Java debugger to work
              if opts.test and mason_registry.is_installed("java-test") then
                -- custom keymaps for Java test runner (not yet compatible with neotest)
                wk.register({
                  ["<leader>ct"] = { name = "+test" },
                  ["<leader>ctT"] = { require("jdtls.dap").test_class, "Run All Test" },
                  ["<leader>ctn"] = { require("jdtls.dap").test_nearest_method, "Run Nearest Test" },
                  ["<leader>ctt"] = { require("jdtls.dap").pick_test, "Run Test" },
                  ["<leader>ctc"] = { require('java').dap.config_dap, "Dap Config" },
                  ["<leader>ctr"] = { require('java').test.run_current_class, "Run Curr. Class" },
                  ["<leader>ctd"] = { require('java').test.debug_current_class, "Debug Curr. Class" },
                  ["<leader>ctR"] = { require('java').test.run_current_method, "Run Curr. Method" },
                  ["<leader>ctD"] = { require('java').test.debug_current_method, "Debug Curr. Method" },
                  ["<leader>ctv"] = { require('java').test.view_last_report, "View Report" },
                }, { mode = "n", buffer = args.buf })
              end
            end

            -- local lsp_signature = require("lsp_signature")
            -- local lsp_signature_setup = {
            -- }
            -- lsp_signature.on_attach(lsp_signature_setup, args.buf)

            -- User can set additional keymaps in opts.on_attach

            local _, _ = pcall(vim.lsp.codelens.refresh)

            if opts.on_attach then
              opts.on_attach(args)
            end
          end
        end
      })
      -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
      attach_jdtls()
    end
  },
  {
    'nvim-java/nvim-java',
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      }
    },
  }
}
