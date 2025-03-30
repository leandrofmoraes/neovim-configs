-- indent-blankline.nvim
return {
  'lukas-reineke/indent-blankline.nvim',
  enabled = false,
  main = 'ibl',
  -- commit = "3d08501caef2329aba5121b753e903904088f7e6", -- release v3.5.4
  dependencies = 'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    indent = { char = '│', tab_char = '│' },
    scope = { enabled = false },
    exclude = { filetypes = { 'lazy', 'dashboard', 'mason' } },
  },
}
