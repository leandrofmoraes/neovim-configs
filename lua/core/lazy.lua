--------------------------------------------------------------------------------
-- lua/core/lazy_setup.lua - Instala e configura o lazy.nvim e os plugins
--------------------------------------------------------------------------------
-- local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    lazyrepo,
    "--branch=stable", -- Usa a última versão estável
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
-- vim.opt.rtp:prepend(lazypath)
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Configuração do lazy.nvim: opções para instalação, performance, UI e especificação dos plugins
local opts = {
  defaults = { lazy = true, version = "*" },
  git = { log = { '--since=3 days ago' } },
  install = { colorscheme = { "tokyonight", "catppuccin" } },
  -- rocks = { hererocks = true },
  checker = {
    enabled = false,
    notify = true,
    frequency = 604800, -- Verifica atualizações a cada semana (em segundos)
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "netrwPlugin",
        "rplugin",
        -- "matchit",
        -- "matchparen"
      },
    },
    -- cache = { enabled = true },
  },
  ui = {
    border = "double", -- "double" | "single" | "shadow" | "none" | "rounded" | "solid"
    custom_keys = { false },
  },
  -- Especifique os plugins a serem carregados. Você pode ter uma estrutura modular, por exemplo:
  spec = {
    -- { import = "plugins.extras" },
    -- { import = "plugins.lazyvim" },
    -- { import = "plugins.lsp" },
    { import = "plugins" },
  },
  -- debug = true
}
-- Carrega a configuração do lazy.nvim com as opções definidas
require("lazy").setup(opts)

-- return M
