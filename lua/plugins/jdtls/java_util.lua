local M = {}

local home_dir = os.getenv("HOME") or vim.env.HOME

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

--- Get installed Mason package path (compatible com mason v1.x e v2.x)
--- @param package_name string
--- @return string|nil
function M.get_mason_package_path(package_name)
  if _mason_package_paths[package_name] then
    return _mason_package_paths[package_name]
  end

  -- Tenta usar a registry do mason de forma segura
  local ok, registry = pcall(require, "mason-registry")
  if ok and registry then
    local success, pkg = pcall(registry.get_package, package_name)
    if success and pkg then
      -- API antiga (mason < 2.0) tinha get_install_path()
      if type(pkg.get_install_path) == "function" then
        local s, path = pcall(function() return pkg:get_install_path() end)
        if s and path and path ~= "" then
          _mason_package_paths[package_name] = path
          return path
        end
      end
      -- caso não exista get_install_path, vamos cair nos fallbacks abaixo
    end
  end

  -- Fallbacks: $MASON ou stdpath('data') .. '/mason'
  local mason_root = vim.fn.expand("$MASON")
  if mason_root == "" then
    mason_root = vim.fn.stdpath("data") .. "/mason"
  end

  -- Primeiro tenta layout 'packages/<pkg>'
  local packages_path = mason_root .. "/packages/" .. package_name
  if vim.fn.isdirectory(packages_path) == 1 then
    _mason_package_paths[package_name] = packages_path
    return packages_path
  end

  -- Depois tenta 'share/<pkg>' (comum em mason v2)
  local share_path = mason_root .. "/share/" .. package_name
  if vim.fn.isdirectory(share_path) == 1 then
    _mason_package_paths[package_name] = share_path
    return share_path
  end

  -- Por fim, tenta caminhos históricos usados por algumas configs
  local legacy_path = vim.fn.expand("~/.local/share/nvim/mason/packages/" .. package_name)
  if vim.fn.isdirectory(legacy_path) == 1 then
    _mason_package_paths[package_name] = legacy_path
    return legacy_path
  end

  return nil
end

----------------------------------------------------------------

--- Get Java debug bundles
--- @return table
local function get_java_debug_bundles()
  local debug_path = M.get_mason_package_path("java-debug-adapter")
  if not debug_path then return {} end

  -- Tenta localizar os jars dentro do pacote (plugins/extensions)
  local pattern1 = debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
  local pattern2 = debug_path .. "/**/*.jar"

  local debug_jars = {}
  local glob1 = vim.fn.glob(pattern1)
  if glob1 and glob1 ~= "" then
    debug_jars = vim.split(glob1, "\n")
  else
    local glob2 = vim.fn.glob(pattern2)
    if glob2 and glob2 ~= "" then
      debug_jars = vim.split(glob2, "\n")
    end
  end

  return vim.tbl_filter(function(jar)
    return vim.fn.filereadable(jar) == 1
  end, debug_jars)
end

--- Get Java test bundles
--- @return table
local function get_java_test_bundles()
  local test_path = M.get_mason_package_path("java-test")
  if not test_path then return {} end

  local test_jars = {}
  local glob1 = vim.fn.glob(test_path .. "/extension/server/*.jar")
  if glob1 and glob1 ~= "" then
    test_jars = vim.split(glob1, "\n")
  end

  -- Também tenta pegar jars do vscode-java-test (caso o usuário tenha instalado no VSCode)
  local vscode_java_test = vim.fn.glob(home_dir .. "/.vscode/extensions/vscjava.vscode-java-test-*/server/*.jar")
  if vscode_java_test and vscode_java_test ~= "" then
    vim.list_extend(test_jars, vim.split(vscode_java_test, "\n"))
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
  local bundles = {} ---@type string[]

  -- Spring Boot extensions (se existir)
  local ok, spring_boot = pcall(require, "spring_boot")
  if ok and type(spring_boot.java_extensions) == "function" then
    vim.list_extend(bundles, spring_boot.java_extensions())
  end

  -- Se DAP habilitado, adiciona debug/test bundles
  if opts.dap and M.has_plugin("nvim-dap") then
    vim.list_extend(bundles, get_java_debug_bundles())

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
  -- Tenta via Mason
  local jdtls_path = M.get_mason_package_path("jdtls")
  if jdtls_path then
    local lombok_jar = jdtls_path .. "/lombok.jar"
    if vim.fn.filereadable(lombok_jar) == 1 then
      return lombok_jar
    else
      vim.notify("Lombok not found in Mason package", vim.log.levels.WARN)
    end
  end

  -- Fallback para Maven local (~/.m2)
  if not home_dir or home_dir == "" then
    vim.notify("Variável de ambiente HOME não está definida", vim.log.levels.ERROR)
    return ""
  end

  local lombok_latest = home_dir .. "/.m2/repository/org/projectlombok/lombok/lombok-edge.jar"
  if vim.fn.filereadable(lombok_latest) == 1 then
    return lombok_latest
  end

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

  local root_dir = opts.root_dir()
  local project_name = opts.project_name(root_dir)
  local cmd = vim.deepcopy(opts.cmd)
  local lombok_agent = get_lombok_agent()

  -- Tenta localizar equinox launcher dentro do pacote jdtls obtido via Mason
  local jdtls_pkg_path = M.get_mason_package_path("jdtls")
  local equinox_glob = nil
  if jdtls_pkg_path then
    equinox_glob = vim.fn.glob(jdtls_pkg_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  else
    equinox_glob = vim.fn.glob(home_dir ..
    "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
  end

  if equinox_glob == "" then
    error("Eclipse Equinox Launcher JAR não encontrado! Verifique a instalação do jdtls.")
  end

  local equinox_launcher = equinox_glob

  if project_name then
    vim.list_extend(cmd, {
      "java",
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
      "--jvm-arg=-javaagent:" .. (lombok_agent or ""),
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

  -- Crie um augroup para evitar múltiplas instâncias do autocmd
  local jdtls_dap_grp = vim.api.nvim_create_augroup("JdtlsDapSetup", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = jdtls_dap_grp,
    pattern = "jdtls_project_loaded",
    once = true,
    callback = function()
      if debug_adapter_installed then
        local ok, jdtls = pcall(require, "jdtls")
        if ok then
          jdtls.setup_dap(opts.dap or {})

          if test_adapter_installed then
            local ok_dap, jdtls_dap = pcall(require, "jdtls.dap")
            if ok_dap then
              jdtls_dap.setup_dap_main_class_configs()
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
