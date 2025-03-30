return {
  "mrjones2014/legendary.nvim", -- A command palette for keymaps, commands and autocmds
  enabled = true,
  priority = 10000,
  lazy = false,
  -- dependencies = "kkharji/sqlite.lua",
  keys = {
    { "<C-p>", function() require("legendary").find() end, desc = "Open Legendary" },
    { ";ll",   "<cmd>Legendary<CR>",                       desc = 'Open' },
    { ";lk",   "<cmd>Legendary keymaps<CR>",               desc = 'Search Keymaps' },
    { ";lc",   "<cmd>Legendary commands<CR>",              desc = 'Search Commands' },
    { ";lf",   "<cmd>Legendary functions<CR>",             desc = 'Search Functions' },
    { ";la",   "<cmd>Legendary autocmds<CR>",              desc = 'Search Autocmds' },

    -- repeat the last item executed via legendary.nvim's finder;
    -- by default, only executes if the last set of item filters used still returns `true`
    { ";lr",   "<cmd>LegendaryRepeat<CR>",                 desc = 'Repeat the last item executed' },
    -- repeat the last item executed via legendary.nvim's finder, ignoring the filters used
    { ";lR",   "<cmd>LegendaryRepeat!<CR>",                desc = 'Repeat the last item executed, ignoring the filters used' },
  },
  opts = {
    -- select_prompt = "Legendary",
    include_builtin = false,
    extensions = {
      codecompanion = false,
      lazy_nvim = true,
      nvim_tree = true,
      smart_splits = {
        directions = { 'h', 'j', 'k', 'l' },
        mods = {
          move = '<C>',
          resize = '<M>',
        },
      },
    },
    -- Load these with the plugin to ensure they are loaded before any Neovim events
    -- autocmds = require("config.autocmds"),
  }
}
