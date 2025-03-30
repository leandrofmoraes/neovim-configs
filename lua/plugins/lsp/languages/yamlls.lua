local M = {}

M.yamlls = {
  -- Have to add this for yamlls to understand that we support line folding
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
  end,
  single_file_support = true,
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    }
  },
  settings = {
    yaml = {
      -- Using the schemastore plugin instead.
      schemastore = {
        enable = false,
        url = '',
      },
      redhat = { telemetry = { enabled = false } },
      keyOrdering = false,
      format = {
        enable = true,
      },
      validate = true,
      schemaStore = {
        -- Must disable built-in schemaStore support to use
        -- schemas from SchemaStore.nvim plugin
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
    },
  },
  -- Lazy-load schemas.
  on_new_config = function(config)
    config.settings.yaml.schemas = config.settings.yaml.schemas or {}
    vim.list_extend(config.settings.yaml.schemas, require('schemastore').yaml.schemas())
  end,
}
return M
