-- Install lazy.nvim automatically
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
-- vim.opt.rtp:prepend(lazypath)
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local opts = {
  git = { log = { '--since=3 days ago' } },
  ui = {
    custom_keys = { false },
    border = "double", -- "double" | "single" | "shadow" | "none" | "rounded" | "solid"
  },
  install = { colorscheme = { 'tokyonight' } },
  checker = {
    enabled = true,
    notify = true, -- get a notification when new updates are found
    -- frequency = 3600, -- check for updates every hour
    frequency = 604800, -- check for updates every week
  },
  -- change_detection = { enabled = false },
  defaults = {
    lazy = true,
    version = "*",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        -- 'matchit',
        -- 'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        'rplugin',
      },
    },
  },
  spec = {
    { import = "plugins.extras" },
    { import = "plugins.lsp" },
    { import = "plugins" },
  },
}

-- Load the plugins and options
-- require('lazy').setup('plugins', opts)
require('lazy').setup(opts)
