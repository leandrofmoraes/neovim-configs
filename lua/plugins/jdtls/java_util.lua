local M = {}

local home_dir = os.getenv("HOME")
-- local home_dir = vim.env.HOME

----------------------------------------------------------------

-- Função utilitária para extensão/override de configurações
-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
function M.extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
  end
  return config
end

----------------------------------------------------------------

--- Get plugin options safely
--- @param name string
--- @return table
function M.get_plugin_opts(name)
  local plugins = require("lazy.core.config").plugins
  local plugin = plugins[name]
  if not plugin then return {} end

  local opts = plugin.opts
  if type(opts) == "function" then
    local success, result = pcall(opts, plugin._.spec)
    return success and result or {}
  end
  return opts or {}
end

----------------------------------------------------------------

local _has_plugin_cache = {}
--- Check if a plugin is installed
--- @param plugin_name string
--- @return boolean
function M.has_plugin(plugin_name)
  if _has_plugin_cache[plugin_name] == nil then
    local ok, lazy_config = pcall(require, "lazy.core.config")
    _has_plugin_cache[plugin_name] = ok and lazy_config.plugins[plugin_name] ~= nil
  end
  return _has_plugin_cache[plugin_name]
end

----------------------------------------------------------------

-- Cache para caminhos do Mason
local _mason_package_paths = {}

--- Get installed Mason package path
--- @param package_name string
--- @return string|nil
function M.get_mason_package_path(package_name)
  local mason_registry = require("mason-registry")

  if not _mason_package_paths[package_name] then
    local ok, pkg = pcall(mason_registry.get_package, package_name)
    if ok and pkg:is_installed() then
      _mason_package_paths[package_name] = pkg:get_install_path()
    end
  end
  return _mason_package_paths[package_name]
end

----------------------------------------------------------------

--- Get Java debug bundles
--- @return table
local function get_java_debug_bundles()
  local debug_path = M.get_mason_package_path("java-debug-adapter")
  if not debug_path then return {} end

  -- local debug_jars = vim.split(vim.fn.glob(debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1), "\n")
  local debug_jars = vim.split(vim.fn.glob(debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
  -- local debug_jars = vim.split(vim.fn.glob(debug_path .. "/extension/server/*.jar"), "\n")
  return vim.tbl_filter(function(jar)
    return vim.fn.filereadable(jar) == 1
  end, debug_jars)
end

--- Get Java test bundles
--- @return table
local function get_java_test_bundles()
  local test_path = M.get_mason_package_path("java-test")
  if not test_path then return {} end

  local test_jars = vim.split(vim.fn.glob(test_path .. "/extension/server/*.jar"), "\n")

  local vscode_java_test = vim.split(
    vim.fn.glob(home_dir .. ".vscode/extensions/vscjava.vscode-java-test-*/server/*.jar"), "\n")
  if #vscode_java_test > 0 then
    vim.list_extend(test_jars, vscode_java_test)
  end

  return vim.tbl_filter(function(jar)
    return vim.fn.filereadable(jar) == 1
  end, test_jars)
end
----------------------------------------------------------------

--- Get all required bundles for JDTLS
--- @param opts table
--- @return table
function M.get_bundles(opts)
  -- Find the extra bundles that should be passed on the jdtls command-line
  local bundles = {} ---@type string[]

  -- Add Spring Boot extensions if available
  -- vim.list_extend(bundles, require("spring_boot").java_extensions())
  local ok, spring_boot = pcall(require, "spring_boot")
  if ok and type(spring_boot.java_extensions) == "function" then
    vim.list_extend(bundles, spring_boot.java_extensions())
  end

  -- Add debug/test bundles if DAP is enabled
  if opts.dap and M.has_plugin("nvim-dap") then
    vim.list_extend(bundles, get_java_debug_bundles())

    -- java-test also depends on java-debug-adapter.
    -- if opts.test and mason_registry.is_installed("java-test") then
    if opts.test and M.get_mason_package_path("java-test") then
      vim.list_extend(bundles, get_java_test_bundles())
    end
  end

  return bundles
end

----------------------------------------------------------------

--- Get Lombok agent path with fallback
--- @return string
local function get_lombok_agent()
  -- Try Mason first
  local jdtls_path = M.get_mason_package_path("jdtls")
  if jdtls_path then
    local lombok_jar = jdtls_path .. "/lombok.jar"
    if vim.fn.filereadable(lombok_jar) == 1 then
      return lombok_jar
    else
      vim.notify("Lombok not found in Mason package", vim.log.levels.ERROR)
    end
  end

  -- Fallback to Maven
  if not home_dir then
    vim.notify("Variável de ambiente HOME não está definida", vim.log.levels.ERROR)
    return ""
  end

  local lombok_latest = home_dir .. "/.m2/repository/org/projectlombok/lombok/lombok-edge.jar"
  if vim.fn.filereadable(lombok_latest) == 1 then
    return lombok_latest
  end

  -- Error handling
  vim.notify("Lombok not found! Install via Mason (jdtls) or Maven", vim.log.levels.ERROR)
  return ""
end

----------------------------------------------------------------

--- Build full JDTLS command
-- - @param fname string
--- @param opts table
--- @return table
function M.build_full_cmd(opts)
  if not opts or not opts.root_dir or not opts.project_name then
    vim.notify("JDTLS: Incomplete configuration", vim.log.levels.ERROR)
    return {}
  end

  -- local root_dir = opts.root_dir
  local root_dir = opts.root_dir()
  local project_name = opts.project_name(root_dir)
  -- local project_name = M.get_project_name(root_dir)

  local cmd = vim.deepcopy(opts.cmd)
  local lombok_agent = get_lombok_agent()

  local equinox_launcher = vim.fn.glob(home_dir ..
    "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
  if equinox_launcher == "" then
    error("Eclipse Equinox Launcher JAR não encontrado! Verifique a instalação do jdtls.")
  end

  if project_name then
    vim.list_extend(cmd, {
      "java", -- or '/path/to/java11_or_newer/bin/java'
      -- "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      -- "-Djava.awt.headless=true",  -- Remove dependências GUI
      "-Dlog.protocol=true",
      "-Dlog.level=ALL", -- "INFO", "WARN", "ERROR" or "ALL"
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "--jvm-arg=-javaagent:" .. lombok_agent,
      "-jar", equinox_launcher,
      "-configuration", opts.jdtls_config_dir(project_name),
      "-data", opts.jdtls_workspace_dir(project_name),
    })
  end

  return cmd
end

function M.enable_debugger(opts)
  if not opts.dap or not M.has_plugin("nvim-dap") then
    vim.notify("nvim-dap is not installed or DAP is not enabled", vim.log.levels.WARN)
    return
  end

  local keymaps = require("plugins.jdtls.java_keymaps")

  -- Verificação centralizada dos pacotes Mason
  local debug_adapter_installed = M.get_mason_package_path("java-debug-adapter")
  local test_adapter_installed = M.get_mason_package_path("java-test")

  -- Configuração do DAP: Se o adaptador de debug estiver instalado, configura o DAP.

  -- Crie um augroup para evitar múltiplas instâncias do autocmd
  local jdtls_dap_grp = vim.api.nvim_create_augroup("JdtlsDapSetup", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = jdtls_dap_grp,
    -- pattern = "*.java",
    pattern = "jdtls_project_loaded",
    once = true,
    callback = function()
      if debug_adapter_installed then
        local ok, jdtls = pcall(require, "jdtls")
        if ok then
          jdtls.setup_dap(opts.dap or {})

          if test_adapter_installed then
            -- Requerir o módulo jdtls.dap separadamente para configurar os testes
            local ok_dap, jdtls_dap = pcall(require, "jdtls.dap")
            if ok_dap then
              -- vim.defer_fn(function()
              jdtls_dap.setup_dap_main_class_configs()
              -- end, 3000) -- 3000ms de delay
            else
              vim.notify("Error! module 'jdtls.dap' is required", vim.log.levels.ERROR)
            end
          end
        end
      end
    end
  })

  keymaps.dap_keymaps(opts)
end

----------------------------------------------------------------

return M
