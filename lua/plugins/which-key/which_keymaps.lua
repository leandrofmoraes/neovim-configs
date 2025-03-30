local wk = require("which-key")
local icons = require('utils.icons')

wk.add({
  mode = { "n", "v" },

  ------------------------------------------------------
  -- for 'leader' trigger

  -- { "<leader><tab>", group = "tabs" },
  -- { "<leader>c", group = "code" },
  -- { "<leader>gh", group = "hunks" },
  -- { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
  { "[", group = "prev" },
  { "]", group = "next" },
  {
    "<leader>w",
    group = "Windows",
    proxy = "<c-w>",
    expand = function()
      return require("which-key.extras").expand.win()
    end,
  },
  {
    ";?",
    function()
      require("lua.plugins.which_key.init").show({ global = false })
    end,
    desc = "Keymaps",
    icon = { icon = icons.ui.Keyboard, color = "yellow" },
  },
  -- { "gx", desc = "Open with system app" },
  -- { "g", group = "goto" },
  -- { "z", group = "fold" },
  { "gz", group = "surround", icon = { icon = icons.kind.Namespace, color = "yellow" } },
})

wk.add({ mode = { "v", "n" }, { "gM", group = "Markdown", icon = { icon = require("utils.icons").misc.Markdown, color = "green" } } })
wk.add({ mode = { "v", "n" }, { "gm", group = "Multicursors", icon = { icon = icons.ui.Cursor, color = "green" } } })
wk.add({ mode = { 'v', 'n', 'x' }, { "gr", group = "Replace", icon = { icon = icons.kind.Reference, color = "green" } } })
wk.add({
  mode = "n",
  { "go", icon = { icon = icons.ui.HorizontalLine, color = 'orange' } },
  { "gO", icon = { icon = icons.ui.HorizontalLine, color = 'orange' } },
  { "g=", icon = { icon = icons.ui.Indent, color = "green" } },
  { "ga", icon = { icon = icons.ui.SelectAll, color = "green" } },
  { "gh", icon = { icon = icons.kind.Color, color = "orange" } },
  { "gH", icon = { icon = icons.kind.Color, color = "orange" } },
  { "gx", desc = "Open file/URL" }, -- better descriptions
  { ";g", group = "Go to", icon = { icon = "", color = "yellow" } },
  { "g/", group = "Split/Join", icon = { icon = icons.ui.Code, color = "orange" } },
})

------------------------------------------------------
-----Leader keys
------------------------------------------------------
wk.add({
  { "<leader>!", icon = { icon = "", hl = "WhichKeyIconOrange" } },
  { "<leader>e", icon = { icon = icons.kind.Class, color = "green" } },
  { "<leader>h", icon = { icon = icons.kind.Color, color = "orange" } },
  { "<leader>P", icon = { icon = icons.misc.Package, hl = "WhichKeyIconOrange" } },
  { "<leader>r", icon = { icon = icons.ui.Refresh, color = "green" } },
  { "<leader>c", group = "Code" },
  { "<leader>cx", group = "Extract" },
  { "<leader>C", group = "Copilot", icon = { icon = icons.kind.Copilot, color = "blue" } },
  { "<leader>d", group = "diagnostics/Quickfix", icon = { icon = icons.diagnostics.Icon, hl = "WhichKeyIconGreen" } },
  -- { "<leader>D", group = "Dim", icon = { icon = '󱉖', color = "yellow" } },
  -- { "<leader>Dd", icon = { icon = '', color = "grey" } },
  -- { "<leader>DD", icon = { icon = '󰌵', color = "cyan" } },
  { "<leader>f", group = "File" },
  { "<leader>G", group = "Git Tools" },
  { "<leader>n", group = "Noice" },
  { "<leader>o", group = "overseer", icon = { icon = icons.ui.DebugConsole, color = "yellow" } },
  { "<leader>T", group = "Test" },
  { "<leader>t", group = "Toggle" },
  { "<leader>z", group = "Zen mode", icon = { icon = icons.misc.Zen, color = "cyan" } },
})

wk.add({
  {
    ";<Tab>",
    -- proxy = "<C-Tab>",
    group = "Buffer Menu",
    expand = function()
      return require("which-key.extras").expand.buf()
    end,
  },
  { ";e", icon = { icon = icons.kind.Class, color = "green" } },
  { ";k", icon = { icon = icons.kind.Keyword, color = "green" } },
  { ";P", icon = { icon = icons.ui.Project, color = "green" } },
  { ";S", icon = { icon = icons.ui.Tree, color = "green" } },
  { ";f", group = "Search" },
  { ";G", group = "Git" },
  { ";l", group = "Legendary",                                  icon = { icon = icons.ui.Search, color = "blue" } },
})

-- Yank.nvim
wk.add({
  { 'y',  icon = { icon = icons.ui.Clipboard, color = 'orange' } },
  { 'p',  icon = { icon = icons.ui.Clipboard, color = 'orange' } },
  { 'P',  icon = { icon = icons.ui.Clipboard, color = 'orange' } },
  { '=p', icon = { icon = icons.ui.Clipboard, color = 'orange' } },
  { '=P', icon = { icon = icons.ui.Clipboard, color = 'orange' } },
  { '[y', icon = { icon = icons.ui.Clipboard, color = 'orange' } },
  { ']y', icon = { icon = icons.ui.Clipboard, color = 'orange' } },
  { ';y', icon = { icon = icons.ui.Clipboard, color = 'orange' } }
})
