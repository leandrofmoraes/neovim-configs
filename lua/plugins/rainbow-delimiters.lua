-- rainbow-delimiters.nvim
return {
  --   'hiphish/rainbow-delimiters.nvim',
  'HiPhish/rainbow-delimiters.nvim',
  -- enabled = false,
  -- commit = 'eb3e304523f0fc08eb568855fea55598ba5ccf42',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
}
