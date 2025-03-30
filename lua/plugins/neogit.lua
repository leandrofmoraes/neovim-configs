return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua",              -- optional
  },
  -- config = true,
  cmd = 'Neogit',
  opts = {
    disable_insert_on_commit = 'auto',
    kind = 'replace',
    status = { recent_commit_count = 25 },
    -- integrations = { telescope = true },
    auto_show_console = false,
    telescope_sorter = function()
      return require('telescope').extensions.fzf.native_fzf_sorter()
    end,
  },
  -- keys = {
  --   -- stylua: ignore start
  --   { '<leader>gg', function() return require('neogit').open() end,             desc = 'Open neogit' },
  --   { '<leader>gC', function() return require('neogit').open({ 'commit' }) end, desc = 'Open neogit commit popup' },
  --   -- stylua: ignore end
  -- },
}
