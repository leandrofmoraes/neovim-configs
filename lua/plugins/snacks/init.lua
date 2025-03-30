return {
  "folke/snacks.nvim",
  lazy = false,
  -- 	priority = 1000,

  opts = {
    animate      = require("plugins.snacks.animate"),
    bigfile      = require("plugins.snacks.bigfile"),
    dashboard    = require("plugins.snacks.dashboard"),
    dim          = require("plugins.snacks.dim"),
    git          = require("plugins.snacks.git"),
    gitbrowse    = require("plugins.snacks.gitbrowse"),
    image        = require("plugins.snacks.image"),
    input        = require("plugins.snacks.input"),
    indent       = require("plugins.snacks.indent"),
    notify       = require("plugins.snacks.notify"),
    notifier     = require("plugins.snacks.notifier"),
    picker       = require("plugins.snacks.picker"),
    scope        = require("plugins.snacks.scope"),
    scroll       = require("plugins.snacks.scroll"),
    statuscolumn = require("plugins.snacks.statuscolumn"), --disabled
    explorer     = require("plugins.snacks.explorer"),
    zen          = require("plugins.snacks.zen"),
  },
  keys = {
    { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    { "<leader>zz", function() Snacks.zen() end,                     desc = "Toggle Zen" },
    { "<leader>zZ", function() Snacks.zen.zoom() end,                desc = "Toggle Zoom" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.animate():map("<leader>ta")
        Snacks.toggle.scroll():map("<leader>ts")
        Snacks.toggle.inlay_hints():map("<leader>th")
        Snacks.toggle.dim():map("<leader>td")
        Snacks.toggle.diagnostics():map("<leader>tD")
        Snacks.toggle.line_number():map("<leader>tl")
        Snacks.toggle.words():map("<leader>tw")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tW")
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>tS")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
        -- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>tc")
        -- Snacks.toggle.treesitter():map("<leader>tT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tb")
        -- Snacks.toggle.indent():map("<leader>tg")
      end,
    })
  end,
}
-- return {
-- 	"folke/snacks.nvim",
-- 	opts = {
-- 		rename = { enabled = true },
-- 		notifier = {
-- 			enabled = true,
-- 			style = "fancy",
-- 		},
-- 		-- notify = { enabled = true },
-- 		-- dim = { enabled = true },
-- 		quickfile = { enabled = true },
-- 		statuscolumn = { enabled = true },
-- 		words = { enabled = true },
-- },
--
-- 	keys = {
-- 		{
-- 			"<leader>nn",
-- 			function()
-- 				Snacks.notifier.show_history()
-- 			end,
-- 			desc = "Notification History",
-- 		},
-- 		{
-- 			"<leader>gB",
-- 			function()
-- 				Snacks.gitbrowse()
-- 			end,
-- 			desc = "Git Browse",
-- 			mode = { "n", "v" },
-- 		},
-- 		{
-- 			"<leader>gb",
-- 			function()
-- 				Snacks.git.blame_line()
-- 			end,
-- 			desc = "Git Blame Line",
-- 		},
-- 		{
-- 			"<leader>gf",
-- 			function()
-- 				Snacks.lazygit.log_file()
-- 			end,
-- 			desc = "Lazygit Current File History",
-- 		},
-- 		{
-- 			"<leader>gg",
-- 			function()
-- 				Snacks.lazygit()
-- 			end,
-- 			desc = "Lazygit",
-- 		},
-- 		{
-- 			"<leader>gl",
-- 			function()
-- 				Snacks.lazygit.log()
-- 			end,
-- 			desc = "Lazygit Log (cwd)",
-- 		},
-- 		{
-- 			"<leader>rf",
-- 			function()
-- 				Snacks.rename.rename_file()
-- 			end,
-- 			desc = "Rename File",
-- 		},
-- },
-- }
