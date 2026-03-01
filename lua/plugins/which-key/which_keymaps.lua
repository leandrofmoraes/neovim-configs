local wk = require('which-key')
local icons = require('utils.icons')

wk.add({
  mode = { 'n', 'v' },

  ------------------------------------------------------
  -- for 'leader' trigger

  -- { "<leader><tab>", group = "tabs" },
  -- { "<leader>c", group = "code" },
  -- { "<leader>gh", group = "hunks" },
  -- { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
  { '[', group = 'prev' },
  { ']', group = 'next' },
  {
    '<leader>w',
    group = 'Windows',
    proxy = '<c-w>',
    expand = function()
      return require('which-key.extras').expand.win()
    end,
  },
  {
    ';?',
    function()
      require('lua.plugins.which_key.init').show({ global = false })
    end,
    desc = 'Keymaps',
    icon = { icon = icons.ui.Keyboard, color = 'yellow' },
  },
  -- { "gx", desc = "Open with system app" },
  -- { "g", group = "goto" },
  -- { "z", group = "fold" },
  { ',s',  group = 'Surround',             icon = { icon = icons.kind.Namespace, color = 'yellow' } },
  { ',sa', desc = 'Add surrounding' },
  { ',sh', group = 'Highlight surrounding' },
  { ',sd', group = 'Delete surrounding' },
  { ',sr', group = 'Replace surrounding' },
  { ',sf', group = 'Find surrounding' },
})

wk.add({
  mode = { 'v', 'n' },
  { ',M', group = 'Markdown', icon = { icon = require('utils.icons').misc.Markdown, color = 'green' } },
})
wk.add({ mode = { 'v', 'n' }, { 'gm', group = 'Multicursors', icon = { icon = icons.ui.Cursor, color = 'green' } } })
wk.add({
  mode = { 'v', 'n' },
  { ',r', group = 'Replace', icon = { icon = icons.kind.Reference, color = 'green' } },
})
-- operador-pending / normal / visual onde aplicável
wk.add({
  mode = 'n',
  { ',o', icon = { icon = icons.ui.HorizontalLine, color = 'orange' } },
  { ',O', icon = { icon = icons.ui.HorizontalLine, color = 'orange' } },
  { ',=', icon = { icon = icons.ui.Indent, color = 'green' } },
  { ',a', icon = { icon = icons.ui.SelectAll, color = 'green' } },
  --{ 'gw', icon = { icon = icons.ui.Word, color = 'green' } },
  --{ 'vw', icon = { icon = icons.ui.Word, color = 'green' } },
  { ',h', icon = { icon = icons.kind.Color, color = 'orange' } },
  { ',H', icon = { icon = icons.kind.Color, color = 'orange' } },
  { ',x', desc = 'Open file/URL' }, -- better descriptions
  { '<leader>cg', group = 'Go to', icon = { icon = '', color = 'yellow' } },
  { ',/', group = 'Split/Join', icon = { icon = icons.ui.Code, color = 'orange' } },
  { ',m', group = 'Multicursors', icon = { icon = icons.ui.Cursor } },
})

wk.add({
  mode = { 'n', 'v' },
  { 'yi', group = 'Yank inner' },
  { 'ya', group = 'Yank arround' },
  { 'vi', group = 'Select inner' },
  { 'va', group = 'Select arround' },
  { 'ci', group = 'Change inner' },
  { 'ca', group = 'Change arround' },
  { 'di', group = 'Delete inner' },
  { 'da', group = 'Delete arround' },
})

------------------------------------------------------
-----Leader keys
------------------------------------------------------
wk.add({
  { '<leader>!', icon = { icon = '', hl = 'WhichKeyIconOrange' } },
  { '<leader>e', icon = { icon = icons.kind.Class, color = 'green' } },
  { '<leader>h', icon = { icon = icons.kind.Color, color = 'orange' } },
  { '<leader>P', group = 'Plugins', icon = { icon = icons.misc.Package, hl = 'WhichKeyIconOrange' } },
  { '<leader>r', icon = { icon = icons.ui.Refresh, color = 'green' } },
  { '<leader>c', group = 'Code' },
  { '<leader>cx', group = 'Extract' },
  { '<leader>C', group = 'Copilot', icon = { icon = icons.kind.Copilot, color = 'blue' } },
  { '<leader>d', group = 'diagnostics/Quickfix', icon = { icon = icons.diagnostics.Icon, hl = 'WhichKeyIconGreen' } },
  -- { "<leader>D", group = "Dim", icon = { icon = '󱉖', color = "yellow" } },
  -- { "<leader>Dd", icon = { icon = '', color = "grey" } },
  -- { "<leader>DD", icon = { icon = '󰌵', color = "cyan" } },
  { '<leader>f', group = 'File' },
  { '<leader>G', group = 'Git Tools' },
  { '<leader>n', group = 'Noice' },
  { '<leader>o', group = 'overseer', icon = { icon = icons.ui.DebugConsole, color = 'yellow' } },
  { '<leader>T', group = 'Test' },
  { '<leader>t', group = 'Toggle' },
  { '<leader>z', group = 'Zen mode', icon = { icon = icons.misc.Zen, color = 'cyan' } },
})

wk.add({
  {
    ';<Tab>',
    -- proxy = "<C-Tab>",
    group = 'Buffer Menu',
    expand = function()
      return require('which-key.extras').expand.buf()
    end,
  },
  { ';e', icon = { icon = icons.kind.Class, color = 'green' } },
  { ';k', icon = { icon = icons.kind.Keyword, color = 'green' } },
  { ';P', icon = { icon = icons.ui.Project, color = 'green' } },
  { ';S', icon = { icon = icons.ui.Tree, color = 'green' } },
  { ';f', group = 'Search' },
  { ';G', group = 'Git' },
  { ';l', group = 'Legendary',                                  icon = { icon = icons.ui.Search, color = 'blue' } },
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
  { ';y', icon = { icon = icons.ui.Clipboard, color = 'orange' } },
})
