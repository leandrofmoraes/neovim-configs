-- lua/lsp/lua_ls.lua
-- Configuração do servidor LuaLS para o Neovim.
-- Essa configuração integra as opções de runtime, formatação, hints e completions.
-- A atualização do workspace (bibliotecas) será feita manualmente somente se houver um
-- arquivo .luarc.json ou .luarc.jsonc, ou seja, se o lazydev estiver desativado.
local M = {}
local util = require('plugins.lsp.lsp_util')

local root_files = {
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
  '.git',
}

M.lua = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_dir = util.root_pattern(root_files),
  single_file_support = true,
  -- --- Configuração executada quando o LSP é inicializado.
  -- ---@param client vim.lsp.Client
  -- on_init = function(client)
  --   -- Obtém o diretório do workspace (primeiro folder do LSP)
  --   local workspace = client.workspace_folders
  --     and client.workspace_folders[1]
  --     and client.workspace_folders[1].name

  -- Se houver um workspace e existir um .luarc.json ou .luarc.jsonc,
  -- assumimos que lazydev está desativado e fazemos a configuração manual do workspace.
  -- if workspace and (vim.uv.fs_stat(workspace .. "/.luarc.json") or vim.uv.fs_stat(workspace .. "/.luarc.jsonc")) then
  --   client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
  --     Lua = {
  --       workspace = {
  --         checkThirdParty = false,
  --         didChangeWatchedFiles = {
  --           dynamicRegistration = false,
  --         },
  --         -- Configura as bibliotecas manualmente (lazydev não está ativo)
  --         library = {
  --           vim.env.VIMRUNTIME,
  --           "${3rd}/luv/library",
  --         },
  --       },
  --     },
  --   })

  -- Notifica o LSP sobre a mudança de configuração
  --     client:notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, {
  --       settings = client.config.settings,
  --     })
  --   end
  --
  --   return true
  -- end,

  -- Outras configurações do servidor LuaLS (formatação, hints, completions, etc.)
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT", -- Define o runtime como LuaJIT
      },
      telemetry = { enable = false },
      workspace = {
        checkThirdParty = false,
        -- didChangeWatchedFiles = {
        --   dynamicRegistration = false,
        -- },
        -- Configura as bibliotecas manualmente (lazydev não está ativo)
        -- library = {
        --   vim.env.VIMRUNTIME,
        --   "${3rd}/luv/library",
        -- },
      },
      type = {
        castNumberToInteger = true,
        inferParamType = true,
      },
      codeLens = {
        enable = true,
      },
      hint = {
        enable = true,
        await = true,
        setType = true,         --false
        paramType = true,
        paramName = "All",      -- "All", "Literal", "Disable"
        semicolon = "Disable",  -- "All", "SameLine", "Disable"
        arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
      },
      completion = { callSnippet = "Replace" },
      doc = {
        privateName = { "^_" },
      },
      diagnostics = {
        globals = { 'vim' },
        -- disable = { "incomplete-signature-doc", "trailing-space" },
      },
    },
  },
}

return M
