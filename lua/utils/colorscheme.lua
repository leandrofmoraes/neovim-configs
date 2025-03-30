-- Example using native api: vim.api.nvim_set_hl(0, 'BlinkCmpKindDict', { default = false, fg = '#a6e3a1' })

return function(hl, c)
  local transparent = nil
  local blue = '#62AEEF'
  -- local dblue = '#05142F'
  local dblue = '#020221'
  local pink = '#B542FF'
  -- local grey = '#1C1C1C'
  hl.Normal = { bg = transparent, fg = blue }
  hl.NormalFloat = { bg = transparent, fg = blue }
  hl.MsgArea = { bg = transparent, fg = blue }
  hl.SignColumn = { bg = transparent, fg = blue }
  hl.EndOfBuffer = { bg = transparent, fg = blue }
  hl.Float = { bg = transparent, fg = blue }
  hl.FloatBorder = { bg = transparent, fg = pink }
  hl.Pmenu = { bg = transparent, fg = blue }
  -- Telescope
  --   hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
  hl.TelescopeNormal = { bg = transparent, fg = blue }
  hl.TelescopeBorder = { bg = transparent, fg = pink }
  --   hl.TelescopePromptNormal = { bg = prompt }
  hl.TelescopePromptNormal = { bg = transparent, fg = blue }
  hl.TelescopePromptBorder = { bg = transparent, fg = pink }
  --   hl.TelescopePromptTitle = { bg = prompt, fg = prompt }
  hl.TelescopePromptTitle = { bg = transparent, fg = blue }
  --   hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
  hl.TelescopePreviewTitle = { bg = transparent, fg = blue }
  --   hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
  hl.TelescopeResultsTitle = { bg = transparent, fg = blue }
  hl.TroubleNormal = { bg = transparent }
  -- NeoTree
  hl.NeoTreeNormal = { bg = transparent, fg = blue }
  hl.NeoTreeNormalNC = { bg = transparent, fg = blue }
  -- Whichkey
  hl.WhichKey = { fg = blue, bg = transparent }
  hl.WhichKeySeperator = { link = 'Comment' }
  hl.WhichKeyGroup = { fg = pink, bg = transparent }
  hl.WhichKeyDesc = { fg = blue, bg = transparent }
  hl.WhichKeyFloat = { fg = transparent, bg = dblue }
  hl.WhichKeyValue = { fg = dblue, bg = transparent }
  hl.WhichKeyBorder = { fg = blue, bg = dblue }
  -- Blink
  hl.BlinkCmpDoc = { fg = blue, bg = dblue }
  hl.BlinkCmpDocBorder = { fg = blue, bg = transparent }
  hl.BlinkCmpDocSeparator = { fg = pink }
  hl.BlinkCmpMenuBorder = { fg = pink, bg = transparent }
  hl.BlinkCmpSignatureHelpBorder = { fg = pink, bg = transparent }
end
