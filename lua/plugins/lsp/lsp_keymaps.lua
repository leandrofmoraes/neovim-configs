local M = {}
-- local map = require("core.utils").map
local map = vim.keymap.set

M.attach = function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

  local bufnr = args.buf
  -- local lsp_utils = require("plugins.lsp.utils")

  map(
    { "n", "v" },
    "<Leader>ca",
    vim.lsp.buf.code_action,
    { buffer = bufnr, desc = "Code action" }
  )
  map(
    "n",
    "<Leader>cw",
    vim.lsp.buf.add_workspace_folder,
    { buffer = bufnr, desc = "Add workspace folder" }
  )
  map(
    "n",
    "<Leader>cW",
    vim.lsp.buf.remove_workspace_folder,
    { buffer = bufnr, desc = "Remove workspace folder" }
  )
  map("n",
    "<Leader>cp",
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    { buffer = bufnr, desc = "Print workspace folders" }
  )

  map("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  map("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })
  map(
    "n",
    "<leader>cR",
    vim.lsp.buf.rename,
    { buffer = bufnr, desc = "Rename symbol under cursor" }
  )
  map(
    "n",
    "<leader>cl",
    vim.lsp.buf.references,
    { buffer = bufnr, desc = "List all references" }
  )

  map(
    { "n", "v" },
    ";gt",
    vim.lsp.buf.code_action,
    { buffer = bufnr, desc = "Go to" }
  )
  map(
    "n",
    ";gt",
    vim.lsp.buf.type_definition,
    { buffer = bufnr, desc = "Go to type definition" }
  )
  map(
    "n",
    ";gD",
    vim.lsp.buf.declaration,
    { buffer = bufnr, desc = "Go to declaration" }
  )
  map(
    "n",
    ";gd",
    vim.lsp.buf.definition,
    { buffer = bufnr, desc = "Go to definition" }
  )
  map(
    "n",
    ";gi",
    vim.lsp.buf.implementation,
    { buffer = bufnr, desc = "Go to implementation" }
  )

  if
      client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)
  then
    map("n", "<leader>H", function()
      local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not is_enabled)
      require("fidget").notify(
        (is_enabled and "Disabled" or "Enabled") .. " inlay hint",
        vim.log.levels.INFO
      )
    end, { desc = "LSP: Toggle inlay hints" })
  end

  if client.name == "jdtls" then
    local ok, jdtls_keymaps = pcall(require, "plugins.jdtls.java_keymaps")
    if ok and jdtls_keymaps and jdtls_keymaps.jdtls_keymaps then
      -- map('n', '<leader>jc', require('jdtls').compile, { desc = 'Compile Java Workspace' })
      jdtls_keymaps.jdtls_keymaps(bufnr)
    end
  end

  require("plugins.toggleterm.toggleterm_keymaps").term_exec(client, bufnr)
end

return M
