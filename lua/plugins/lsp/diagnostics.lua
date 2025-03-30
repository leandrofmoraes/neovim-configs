local M = {}
local icons = require("utils.icons").diagnostics

-- Diagnostic signs and highlight group
local diagnostics_signs = {
  [vim.diagnostic.severity.ERROR] = {
    sign = string.format("%s ", icons.Error),
    hl_group = "DiagnosticSignError",
  },
  [vim.diagnostic.severity.WARN] = {
    sign = string.format("%s ", icons.Warning),
    hl_group = "DiagnosticSignWarn",
  },
  [vim.diagnostic.severity.HINT] = {
    sign = string.format("%s ", icons.Hint),
    hl_group = "DiagnosticSignHint",
  },
  [vim.diagnostic.severity.INFO] = {
    sign = string.format("%s ", icons.Information),
    hl_group = "DiagnosticSignInfo",
  },
}
-- for type, icon in pairs(signs) do
--   local hl = 'DiagnosticSign' .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
-- end


---@param diagnostic lsp.Diagnostic
local diagnostics_prefix = function(diagnostic)
  local severity = diagnostics_signs[diagnostic.severity]
  return severity.sign, severity.hl_group
end

function M.setup()
-- local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
  local signs = { text = {} }
  for severity, config in pairs(diagnostics_signs) do
    signs.text[severity] = config.sign
  end

  -- Global diagnostic config
  vim.diagnostic.config({
    signs = signs,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = diagnostics_prefix, -- or "●"
    },
    float = {
      max_width = 85,
      max_height = 30,
      border = "rounded",
      prefix = diagnostics_prefix,
      scope = "line",
      source = true,
    },
    update_in_insert = false,
    -- underline = true,
    underline = {
      -- Do not underline text when severity is low (INFO or HINT).
      severity = { min = vim.diagnostic.severity.WARN },
    },
    severity_sort = true,
  })
end

return M
