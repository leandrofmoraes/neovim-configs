local M = {}

--------------------------------------------------------------------------------
-- Função safe_require: Tenta carregar módulos com tratamento de erros
-- safe_require function: Attempts to load modules with error handling
--------------------------------------------------------------------------------
function M.safe_require(module)
  local ok, mod = pcall(require, module)
  if not ok then
    -- vim.notify("Error on load " .. module, vim.log.levels.ERROR)
    vim.notify("Error on load " .. module .. "\n" .. mod, vim.log.levels.ERROR)
    return nil
  end
  return mod
end

---@type fun(module: string): any
return M

-- return {
--     safe_require = safe_require
-- }
