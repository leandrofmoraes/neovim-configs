--------------------------------------------------------------------------------
-- Arquivo principal de configuração do NeoVim
-- NeoVim's main configuration file
--------------------------------------------------------------------------------

-- Ativa o vim.loader se disponível (requer NeoVim v0.10+ para melhorar o carregamento)
-- Enable vim.loader if available (requires NeoVim v0.10+ for better loading)
-- if vim.loader then
--   vim.loader.enable()
-- end

pcall(require, "core")

--------------------------------------------------------------------------------
-- Função safe_require: Tenta carregar módulos com tratamento de erros (Redefinido em "core/safe_require.lua")
-- safe_require function: Attempts to load modules with error handling (Redefined in "core/safe_require.lua")
--------------------------------------------------------------------------------
-- local function safe_require(module)
--   local ok, mod = pcall(require, module)
--   if not ok then
--     -- vim.notify("Erro ao carregar o módulo: " .. module, vim.log.levels.ERROR)
--     vim.notify("Erro ao carregar o módulo: " .. module .. "\n" .. mod, vim.log.levels.ERROR)
--     return nil
--   end
--   return mod
-- end

--------------------------------------------------------------------------------
-- Carregar módulos essenciais (Responsabilidade reatribuída em "core.init.lua")
-- Loading core modules (Reassigned responsibility in "core.init.lua")
--------------------------------------------------------------------------------

-- -- Safely require files
-- -- safe_require("core")
-- safe_require("core.options")
-- safe_require("core.keymaps")
-- safe_require("core.autocommands")
-- safe_require("core.lazy")
-- -- safe_require("core.functions")
-- -- Adicione aqui outros módulos essenciais conforme necessário

--------------------------------------------------------------------------------
-- (Opcional) Carregar configurações de ambiente, se houver
-- (Optional) Load environment settings if any
--------------------------------------------------------------------------------
-- pcall(require, "config.env")

--------------------------------------------------------------------------------
-- (Opcional) Funções globais de debug para facilitar a depuração
-- _G.dd = function(...) require("snacks.debug").inspect(...) end
-- _G.bt = function(...) require("snacks.debug").backtrace() end
-- _G.p  = function(...) require("snacks.debug").profile(...) end
-- vim.print = _G.dd

--------------------------------------------------------------------------------
-- Exemplo: Autocomando para executar ações após o carregamento lazy ("VeryLazy" event)
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VeryLazy",
--   callback = function()
--     local util = safe_require("util")
--     if util and type(util.version) == "function" then
--       util.version()
--     end
--   end,
-- })
