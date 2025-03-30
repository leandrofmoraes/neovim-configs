-- local home_dir = os.getenv("HOME")
-- local home_dir = vim.env.HOME

return {
  {
    "folke/lazydev.nvim",
    enabled = true,
    ft = "lua", -- only load on lua files
    -- cmd = "LazyDev",

    ---@alias lazydev.Library {path:string, words:string[], mods:string[]}
    ---@alias lazydev.Library.spec string|{path:string, words?:string[], mods?:string[]}
    ---@class lazydev.Config
    opts = {
      -- Utiliza o runtime do Neovim
      -- runtime = vim.env.VIMRUNTIME --[[@as string]],
      library = {
        --   -- Adiciona a biblioteca que será usada para completar require e anotações de módulo
        --   -- See the configuration section for more details
        --   -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim",        words = { "Snacks" } },
        --   -- "lazy.nvim",
        --   -- { path = "lazy.nvim",          words = { "Lazy" } },
        { path = "lazy.nvim",          words = { "LazyVim" } },
      },
      -- integrations = {
      --   -- Fixes lspconfig's workspace management for LuaLS
      --   -- Only create a new workspace if the buffer is not part
      --   -- of an existing workspace or one of its libraries
      --   lspconfig = true, -- Integra com lspconfig para atualizar o workspace do LuaLS
      --   -- add the cmp source for completion of:
      --   -- `require "modname"`
      --   -- `---@module "modname"`
      --   cmp = true,  -- Adiciona fonte de completions para require e anotações
      --   -- same, but for Coq
      --   coq = false, -- Desabilita a integração com Coq (se não for utilizada)
      -- },
      -- always enable unless `vim.g.lazydev_enabled = false`
      -- This is the default
      -- ---@type boolean|(fun(root:string):boolean?)
      enabled = function(root_dir)
        local enabled = vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
        return enabled and vim.uv.fs_stat(root_dir)
        -- return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
      ----------------------------------------------------------------------------------
      -- Habilita o lazydev somente se NÃO houver um .luarc.json no diretório raiz.
      -- Assim, se houver .luarc.json, assumimos que você deseja gerenciar o workspace manualmente.
      -- disable when a .luarc.json file is found
      -- enabled = function(root_dir)
      --   return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      -- end,
    },
  }
}
-- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
