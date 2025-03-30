local M = {}

local autocmd = vim.api.nvim_create_autocmd
M.lsp_attach_augroup_id = vim.api.nvim_create_augroup("user-lsp-attach", {})
M.lsp_detach_augroup_id = vim.api.nvim_create_augroup("user-lsp-detach", {})

M.attach = function(args)
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  -- Grupo para document highlight
  local highlight_augroup_id = vim.api.nvim_create_augroup("user-lsp-document-highlight", {})
  -- Grupo para CodeLens
  local codelens_augroup_id = vim.api.nvim_create_augroup("user-lsp-codelens", {})

  -- Configuração do Document Highlight
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    autocmd({ "CursorHold", "CursorHoldI" }, {
      group = highlight_augroup_id,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
      desc = "Highlights symbol under cursor",
    })

    autocmd("CursorMoved", {
      group = highlight_augroup_id,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
      desc = "Clears symbol highlighting under cursor",
    })
  end

  -- Configuração do CodeLens (versão melhorada)
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
    -- Função de refresh com tratamento de erro
    local refresh_codelens = function()
      pcall(vim.lsp.codelens.refresh)
    end

    -- Verifica se já existem autocommands para evitar duplicação
    local existing_cmds = vim.api.nvim_get_autocmds({
      group = codelens_augroup_id,
      buffer = bufnr,
    })

    if #existing_cmds == 0 then
      -- Cria autocommands para eventos relevantes
      -- autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
      autocmd({ "BufEnter", "BufWritePost" }, {
        group = codelens_augroup_id,
        buffer = bufnr,
        callback = refresh_codelens,
        desc = "Refresh CodeLens",
      })

      -- Primeiro refresh ao anexar
      refresh_codelens()
    end
  end

  -- Configuração de cleanup para ambos os grupos
  autocmd("LspDetach", {
    group = M.lsp_detach_augroup_id,
    callback = function(e)
      -- Limpa document highlight
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds({ group = highlight_augroup_id, buffer = e.buf })
      -- Limpa CodeLens
      vim.api.nvim_clear_autocmds({ group = codelens_augroup_id, buffer = e.buf })
    end,
  })
end

return M
