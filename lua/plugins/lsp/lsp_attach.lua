-- nvim/lua/plugins/config/lsp.lua

-- local diagnostic_icons = require('utils.icons').diagnostics
local methods = vim.lsp.protocol.Methods

local M = {}

-- Função safe_on_attach: garante que on_attach seja executado apenas uma vez por buffer
local function safe_on_attach(client, buf, opts)
  opts = vim.tbl_extend('force', {
    log_level = vim.log.levels.ERROR,
    notify = true,
    silent = false,
  }, opts or {})

  -- Verifica se o cliente é válido e se já foi processado
  if not client or vim.b[buf].lsp_attached then
    return false, 'Client invalid or already attached'
  end
  --
  -- if vim.b[buf].lsp_attached then
  --   return
  -- end

  -- on_attach(client, buf)
  -- local ok, err = pcall(M.on_attach, client, buf)
  local ok, err = pcall(function()
    local args = { data = { client_id = client.id }, buf = buf }
    -- local lsp_diagnostics = require("plugins.config.diagnostics")
    local lsp_keymaps = require('plugins.lsp.lsp_keymaps')
    local lsp_autocmds = require('plugins.lsp.lsp_autocmds')

    lsp_keymaps.attach(args)
    lsp_autocmds.attach(args)

    vim.b[buf].lsp_attached = true
  end)

  if not ok and opts.notify then
    vim.schedule(function()
      vim.notify(string.format('LSP attach error [%s] (buf %d): %s', client.name, buf, err), opts.log_level)
    end)
  end

  return ok, err
end

-- ============================================================================
-- Atualiza os mapeamentos quando capacidades dinâmicas são registradas.
-- Update mappings when registering dynamic capabilities.

-- Guarda a implementação original do handler de registro de capacidades
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
-- Sobrescreve o handler para executar on_attach quando novas capacidades são registradas
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local current_buf = vim.api.nvim_get_current_buf()

  safe_on_attach(client, current_buf)

  -- Chama a implementação original para manter o comportamento padrão
  return register_capability(err, res, ctx)
end

-- Configura o autocomando para LspAttach
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    safe_on_attach(client, args.buf)
  end,
})

-- ============================================================================
--- Configura um servidor LSP com suas configurações e aplica as capabilities.
-------------------------------------------------------------------------------
--- Configures the given server with its settings and applying the regular
---@param server string
---@param settings? table
function M.configure_server(server, settings)
  -- local capabilities = require("config.lsp_capabilities")
  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  -- local default_capabilities = require('lspconfig').util.default_config
  local lsp_handlers = require('plugins.lsp.handlers')
  local lsp_diagnostics = require('plugins.lsp.diagnostics')

  default_capabilities.textDocument.completion.completionItem = {
    documentationFormat = { 'markdown', 'plaintext' },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      },
    },
  }

  -- Setup handlers and diagnostics config
  lsp_handlers.setup()
  lsp_diagnostics.setup()

  local active_completion = vim.g.my_active_completion or 'blink' -- "blink" | "nvim-cmp"

  -- if active_completion == 'blink' then
  --   local ok, blink = pcall(require, 'blink') -- ajuste conforme a API do blink
  --
  --   if ok and blink.setup_capabilities then
  --     default_capabilities =
  --         vim.tbl_deep_extend('force', default_capabilities, blink.get_lsp_capabilities(default_capabilities))
  --   end
  -- elseif active_completion == 'nvim-cmp' then
  --   local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  --   if ok then
  --     -- capabilities = cmp_nvim_lsp.default_capabilities()
  --     default_capabilities = vim.tbl_deep_extend('force', default_capabilities, cmp_nvim_lsp.default_capabilities())
  --   end
  -- end
  --
  if active_completion == 'blink' then
    local ok, blink_cmp = pcall(require, 'blink.cmp') -- ajuste conforme a API do blink
    if ok and type(blink_cmp.get_lsp_capabilities) == 'function' then
      -- default_capabilities = blink_cmp.get_lsp_capabilities(default_capabilities)
      vim.tbl_deep_extend('force', default_capabilities, blink_cmp.get_lsp_capabilities(default_capabilities))
    else
      vim.notify('[LSP] blink.cmp not available or missing get_lsp_capabilities', vim.log.levels.DEBUG)
    end
  elseif active_completion == 'nvim-cmp' then
    local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if ok and type(cmp_nvim_lsp.default_capabilities) == 'function' then
      default_capabilities = vim.tbl_deep_extend('force', default_capabilities, cmp_nvim_lsp.default_capabilities())
      -- default_capabilities = cmp_nvim_lsp.default_capabilities()
    end
  end

  -- Attach callbacks
  -- vim.api.nvim_create_autocmd("LspAttach", {
  --   group = lsp_autocmds.lsp_attach_augroup_id,
  --   callback = function(args)
  -- lsp_autocmds.attach(args)
  -- lsp_mappings.attach(args)
  --   end,
  -- })

  -- require('lspconfig')[server].setup(
  --   vim.tbl_deep_extend('error', { capabilities = capabilities, silent = true }, settings or {})
  -- )
  -- A special case for jdtls
  if server == 'jdtls' then
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = function()
        local config = require('plugins.jdtls.java_config').get_config()
        local extend_or_override = require('plugins.jdtls.java_util').extend_or_override

        -- config.capabilities = vim.tbl_deep_extend("keep", default_capabilities, config.capabilities or {})
        config.capabilities = vim.tbl_deep_extend("keep", require('jdtls').extendedClientCapabilities,
          config.capabilities or {})

        extend_or_override(config, { on_attach = safe_on_attach })
        require('jdtls').start_or_attach(config)
      end,
    })
  else
    --   require('lspconfig')[server].setup(vim.tbl_deep_extend('force', {
    --     capabilities = default_capabilities,
    --     on_attach = M.safe_on_attach,
    --     flags = { debounce_text_changes = 150 },
    --   }, settings or {}))

    vim.lsp.config(server, vim.tbl_deep_extend('force', {
      capabilities = default_capabilities,
      on_attach = safe_on_attach,
      flags = { debounce_text_changes = 150 },
    }, settings or {}))

    vim.lsp.enable(server)
    -- return
  end
end

return M
