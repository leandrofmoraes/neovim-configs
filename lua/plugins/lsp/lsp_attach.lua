-- nvim/lua/plugins/config/lsp.lua

-- local diagnostic_icons = require('utils.icons').diagnostics
local methods = vim.lsp.protocol.Methods

local M = {}

-- Desabilita inlay hints inicialmente (pode ser habilitado via comando customizado)
-- Disable inlay hints initially (and enable if needed with my ToggleInlayHints command).
-- vim.g.inlay_hints = false

-- ============================================================================
-- Funções de configuração do on_attach
-- ============================================================================
-- Configura os keymaps e autocommands do LSP para o buffer.
-- Sets up LSP keymaps and autocommands for the given buffer.

-- -- Configura os keymaps básicos para o LSP.
-- local function setup_base_keymaps(client, bufnr)
--   ---@param lhs string
--   ---@param rhs string|function
--   ---@param desc string
--   ---@param mode? string|string[]
--   local function keymap(lhs, rhs, desc, mode)
--     mode = mode or 'n'
--     vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
--   end

-- Exemplos de keymaps para LSP:
-- keymap("<leader>cd", vim.lsp.buf.definition, "Go to Definition")
-- keymap("K", vim.lsp.buf.hover, "Hover Documentation")
-- keymap("<leader>cr", vim.lsp.buf.references, "Go to References")
-- keymap("<leader>ci", vim.lsp.buf.implementation, "Go to Implementation")
-- keymap("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")

-- if client:supports_method(methods.textDocument_codeAction) then
--   keymap("<leader>ca", vim.lsp.buf.code_action, "Code Actions")
-- end
-- Anexa o lightbulb (se disponível) para ações de código
-- require('lightbulb').attach_lightbulb(bufnr, client.id)
-- pcall(function() require("lightbulb").attach_lightbulb(bufnr, client.id) end)

-- keymap('gra', '<cmd>FzfLua lsp_code_actions<cr>', 'vim.lsp.buf.code_action()', { 'n', 'x' })
-- keymap('grr', '<cmd>FzfLua lsp_references<cr>', 'vim.lsp.buf.references()')
-- keymap('gy', '<cmd>FzfLua lsp_typedefs<cr>', 'Go to type definition')
-- keymap('<leader>fs', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
--
-- keymap('<leader>fS', function()
--     -- Disable the grep switch header.
--     require('fzf-lua').lsp_live_workspace_symbols { no_header_i = true }
-- end, 'Workspace symbols')

-- keymap('[d', function() vim.diagnostic.jump { count = -1 } end, 'Previous diagnostic')
-- keymap(']d', function() vim.diagnostic.jump { count = 1 } end, 'Next diagnostic')
-- keymap('[e', function()
--     vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
-- end, 'Previous error')
-- keymap(']e', function()
--     vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
-- end, 'Next error')
-- end


-- Se o cliente suportar definição, utiliza fzf-lua para definições
-- if client:supports_method(methods.textDocument_definition) then
--   keymap('gd', function() require('fzf-lua').lsp_definitions { jump1 = true } end, 'Go to definition')
--   keymap('gD', function() require('fzf-lua').lsp_definitions { jump1 = false } end, 'Peek definition')
-- end

-- if client:supports_method(methods.textDocument_signatureHelp) then
--   local blink_window = require 'blink.cmp.completion.windows.menu'
--   local blink = require 'blink.cmp'
--
--   keymap('<C-k>', function()
--     -- Close the completion menu first (if open).
--     if blink_window.win:is_open() then
--       blink.hide()
--     end
--
--     vim.lsp.buf.signature_help()
--   end, 'Signature help', 'i')
-- end
-- end

-- Configura recursos dinâmicos (document highlight, inlay hints, etc.).
-- local function setup_dynamic_features(client, bufnr)
--   -- Autocomandos para destacar referências no buffer
--   if client:supports_method(methods.textDocument_documentHighlight) then
--
--     -- local under_cursor_highlights_group = vim.api.nvim_create_augroup('cursor_highlights', { clear = false })
--     local group = vim.api.nvim_create_augroup("cursor_highlights", { clear = false })
--
--     vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
--       group = group,
--       desc = 'Highlight references under the cursor',
--       buffer = bufnr,
--       callback = vim.lsp.buf.document_highlight,
--     })
--     vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
--       group = group,
--       desc = 'Clear highlight references',
--       buffer = bufnr,
--       callback = vim.lsp.buf.clear_references,
--     })
--   end

-- Configuração de inlay hints, se habilitados
-- if client:supports_method(methods.textDocument_inlayHint) and vim.g.inlay_hints then
-- local inlay_hints_group = vim.api.nvim_create_augroup('toggle_inlay_hints', { clear = false })

-- Initial inlay hint display.
-- Idk why but without the delay inlay hints aren't displayed at the very start.
-- vim.defer_fn(function()
--   local mode = vim.api.nvim_get_mode().mode
--   vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = bufnr })
-- end, 500)

-- vim.api.nvim_create_autocmd('InsertEnter', {
--   group = inlay_hints_group,
--   desc = 'Enable inlay hints',
--   buffer = bufnr,
--   callback = function()
--     if vim.g.inlay_hints then
--       vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('InsertLeave', {
--   group = inlay_hints_group,
--   desc = 'Disable inlay hints',
--   buffer = bufnr,
--   callback = function()
--     if vim.g.inlay_hints then
--       vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
--     end
--   end,
-- })

--     local group = vim.api.nvim_create_augroup("lsp_inlay_hints", { clear = false })
--     vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
--       group = group,
--       buffer = bufnr,
--       desc = "Toggle inlay hints",
--       callback = function()
--         if vim.g.inlay_hints then
--           vim.lsp.inlay_hint.enable(not vim.api.nvim_get_mode().mode:match("i"), { bufnr = bufnr })
--         end
--       end,
--     })
--   end
-- end


-- ============================================================================
-- Configurações de diagnósticos e handlers
-- Define the diagnostic signs.
-- ============================================================================
-- for severity, icon in pairs(diagnostic_icons) do
--   local hl = 'DiagnosticSign' .. severity:sub(1, 1) .. severity:sub(2):lower()
--   vim.fn.sign_define(hl, { text = icon, texthl = hl })
-- end
--
-- -- Função de formatação para virtual text (definida FORA do bloco de config)
-- local format_diagnostic_message = function(diagnostic)
--   -- Use shorter, nicer names for some sources:
--   local special_sources = {
--     ['Lua Diagnostics.'] = 'lua',
--     ['Lua Syntax Check.'] = 'lua',
--   }
--
--   local message = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
--   if diagnostic.source then
--     message = string.format('%s %s', message, special_sources[diagnostic.source] or diagnostic.source)
--   end
--   if diagnostic.code then
--     message = string.format('%s[%s]', message, diagnostic.code)
--   end
--
--   return message .. ' '
-- end

-- Diagnostic configuration.
-- vim.diagnostic.config({
--   virtual_text = {
--     prefix = '',
--     spacing = 2,
--     format = format_diagnostic_message
--   },
--   float = {
--     border = 'rounded',
--     source = 'if_many',
--     -- Show severity icons as prefixes.
--     prefix = function(diag)
--       local level = vim.diagnostic.severity[diag.severity]
--       local prefix = string.format(' %s ', diagnostic_icons[level])
--       return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
--     end,
--   },
--   -- Disable signs in the gutter.
--   signs = false,
-- })

-- Sobrescreve o handler de virtual text para exibir o diagnóstico mais severo primeiro.
-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
-- local show_handler = vim.diagnostic.handlers.virtual_text.show
-- assert(show_handler)
-- local hide_handler = vim.diagnostic.handlers.virtual_text.hide
-- vim.diagnostic.handlers.virtual_text = {
--   show = function(ns, bufnr, diagnostics, opts)
--     table.sort(diagnostics, function(diag1, diag2)
--       return diag1.severity > diag2.severity
--     end)
--     return show_handler(ns, bufnr, diagnostics, opts)
--   end,
--   hide = hide_handler,
-- }

-- ============================================================================
-- Sobrescrita Condicional de hover e signature_help
-- ============================================================================

-- Se lspsaga não estiver instalado, sobrescreve hover e signature_help para incluir bordas.
-- local has_lspsaga, _ = pcall(require, "ray-x/lsp_signature.nvim")
--  if not has_lspsaga then
--    local orig_hover = vim.lsp.buf.hover
--    ---@diagnostic disable-next-line: duplicate-set-field
--    vim.lsp.buf.hover = function()
--      return orig_hover({
--        border = 'rounded',
--        max_height = math.floor(vim.o.lines * 0.5),
--        max_width = math.floor(vim.o.columns * 0.4),
--      })
--   end
--
--   -- Personaliza a função signature_help de forma similar
--    local signature_help = vim.lsp.buf.signature_help
--    ---@diagnostic disable-next-line: duplicate-set-field
--    vim.lsp.buf.signature_help = function()
--      return signature_help({
--        border = 'rounded',
--        max_height = math.floor(vim.o.lines * 0.5),
--        max_width = math.floor(vim.o.columns * 0.4),
--      })
--    end
--  end

-- Sobrescreve stylize_markdown para utilizar Treesitter
-- --- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
-- ---@param bufnr integer
-- ---@param contents string[]
-- ---@param opts table
-- ---@return string[]
-- ---@diagnostic disable-next-line: duplicate-set-field
-- vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
--   contents = vim.lsp.util._normalize_markdown(contents, {
--     width = vim.lsp.util._make_floating_popup_size(contents, opts),
--   })
--   vim.bo[bufnr].filetype = 'markdown'
--   vim.treesitter.start(bufnr)
--   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)
--
--   return contents
-- end

--- Função principal on_attach.
-- function M.on_attach(client, bufnr)
--   -- Evita execução duplicada: se já foi executado para esse buffer, retorna.
--   if vim.b[bufnr].lsp_attached then
--     return
--   end
--
--   local args = { data = { client_id = client.id }, buf = bufnr }
--   -- local lsp_diagnostics = require("plugins.config.diagnostics")
--   local lsp_mappings = require("plugins.lsp.mappings")
--   local lsp_autocmds = require("plugins.lsp.autocmds")
--
--   -- Configura keymaps buffer-local
--   lsp_mappings.attach(args)
--   lsp_autocmds.attach(args)
--
--   -- Caso tenha configurações dinâmicas separadas:
--   -- require("plugins.config.dynamic").attach(client, bufnr)
--
--   -- Diagnósticos geralmente são globais, mas se necessário,
--   -- você pode fazer ajustes específicos aqui também.
--
--   -- if client.name == "tsserver" then
--   --   -- Configurações específicas para TypeScript, se necessário.
--   -- end
--   vim.b[bufnr].lsp_attached = true
-- end

-- Função safe_on_attach: garante que on_attach seja executado apenas uma vez por buffer
local function safe_on_attach(client, buf, opts)
  opts = vim.tbl_extend("force", {
    log_level = vim.log.levels.ERROR,
    notify = true,
    silent = false,
  }, opts or {})

  -- Verifica se o cliente é válido e se já foi processado
  if not client or vim.b[buf].lsp_attached then
    return false, "Client invalid or already attached"
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
    local lsp_keymaps = require("plugins.lsp.lsp_keymaps")
    local lsp_autocmds = require("plugins.lsp.lsp_autocmds")

    lsp_keymaps.attach(args)
    lsp_autocmds.attach(args)

    vim.b[buf].lsp_attached = true
  end)

  if not ok and opts.notify then
    vim.schedule(function()
      vim.notify(string.format(
        "LSP attach error [%s] (buf %d): %s",
        client.name,
        buf,
        err
      ), opts.log_level)
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
  local lsp_handlers = require("plugins.lsp.handlers")
  local lsp_diagnostics = require("plugins.lsp.diagnostics")

  default_capabilities.textDocument.completion.completionItem = {
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

  -- Setup handlers and diagnostics config
  lsp_handlers.setup()
  lsp_diagnostics.setup()

  local active_completion = vim.g.my_active_completion or "blink" -- "blink" | "nvim-cmp"

  if active_completion == "blink" then
    local ok, blink = pcall(require, "blink") -- ajuste conforme a API do blink

    if ok and blink.setup_capabilities then
      default_capabilities = vim.tbl_deep_extend(
        "force",
        default_capabilities,
        blink.get_lsp_capabilities(default_capabilities)
      )
    end
  elseif active_completion == "nvim-cmp" then
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
      -- capabilities = cmp_nvim_lsp.default_capabilities()
      default_capabilities = vim.tbl_deep_extend(
        "force",
        default_capabilities,
        cmp_nvim_lsp.default_capabilities()
      )
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
  if server == "jdtls" then
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = function()
        local config = require("plugins.jdtls.java_config").get_config()
        local extend_or_override = require("plugins.jdtls.java_util").extend_or_override

        -- extend_or_override(config, { on_attach { capabilities = default_capabilities })
        config.capabilities = vim.tbl_deep_extend("keep", default_capabilities, config.capabilities or {})

        extend_or_override(config, { on_attach = M.safe_on_attach })
        require("jdtls").start_or_attach(config)
      end
    })
  else
    require('lspconfig')[server].setup(
      vim.tbl_deep_extend("force", {
        capabilities = default_capabilities,
        on_attach = M.safe_on_attach,
        flags = { debounce_text_changes = 150 },
      }, settings or {})
    )
  end
end

return M
