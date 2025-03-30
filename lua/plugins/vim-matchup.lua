-- vim-matchup
-- match-up is a plugin that lets you highlight, navigate, and operate on sets of matching text.
-- It extends vim's % key to language-specific words instead of just single characters.
return {
  'andymass/vim-matchup',
  enabled = false,
  dependencies = 'nvim-treesitter/nvim-treesitter',
  -- event = { 'BufReadPost', 'BufNewFile' },
    event = { "BufReadPost", "VeryLazy" },
  config = function()
    vim.g.matchup_matchparen_offscreen = {}
    vim.g.matchup_matchparen_deferred = 1
  end,
}
