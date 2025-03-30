-- local icons = require('utils.icons')

return{
  -- gitsigns.nvim
  {
    'lewis6991/gitsigns.nvim',
    -- enabled = false,
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ 'BufRead' }, {
        group = vim.api.nvim_create_augroup('GitSignsLazyLoad', { clear = true }),
        callback = function()
          vim.fn.system('git -C ' .. '"' .. vim.fn.expand('%:p:h') .. '"' .. ' rev-parse')
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name('GitSignsLazyLoad')
            vim.schedule(function()
              require('lazy').load({ plugins = { 'gitsigns.nvim' } })
            end)
          end
        end,
      })
    end,
    ft = 'gitcommit',
    keys = {
      -- stylua: ignore start
      -- { '<leader>gj', function() return require('gitsigns').next_hunk() end,       desc = 'Next hunk' },
      -- { '<leader>gk', function() return require('gitsigns').prev_hunk() end,       desc = 'Previous hunk' },
      -- { '<leader>gl', function() return require('gitsigns').blame_line() end,      desc = 'Open git blame' },
      -- { '<leader>gp', function() return require('gitsigns').preview_hunk() end,    desc = 'Preview the hunk' },
      -- { '<leader>gr', function() return require('gitsigns').reset_hunk() end,      mode = { 'n', 'v' },      desc = 'Reset the hunk' },
      -- { '<leader>gR', function() return require('gitsigns').reset_buffer() end,    desc = 'Reset the buffer' },
      -- { '<leader>gs', function() return require('gitsigns').stage_hunk() end,      mode = { 'n', 'v' },      desc = 'Stage the hunk' },
      -- { '<leader>gS', function() return require('gitsigns').stage_buffer() end,    desc = 'Stage the buffer' },
      -- { '<leader>gu', function() return require('gitsigns').undo_stage_hunk() end, desc = 'Unstage the hunk' },
      -- { '<leader>gd', function() return require('gitsigns').diffthis() end,        desc = 'Open a diff' },
      -- { ']g',         function() return require('gitsigns').next_hunk() end,       desc = 'Next hunk' },
      -- { '[g',         function() return require('gitsigns').prev_hunk() end,       desc = 'Previous hunk' },
      -- stylua: ignore end
    },
    opts = {
      -- signs = {
      --   add = {
      --     hl = 'GitSignsAdd',
      --     -- text = icons.ui.BoldLineLeft,
      --     text = icons.gitsigns.Add,
      --     numhl = 'GitSignsAddNr',
      --     linehl = 'GitSignsAddLn',
      --   },
      --   change = {
      --     hl = 'GitSignsChange',
      --     -- text = icons.ui.BoldLineLeft,
      --     text = icons.gitsigns.Change,
      --     numhl = 'GitSignsChangeNr',
      --     linehl = 'GitSignsChangeLn',
      --   },
      --   delete = {
      --     hl = 'GitSignsDelete',
      --     -- text = icons.ui.Triangle,
      --     text = icons.gitsigns.Delete,
      --     numhl = 'GitSignsDeleteNr',
      --     linehl = 'GitSignsDeleteLn',
      --   },
      --   topdelete = {
      --     hl = 'GitSignsDelete',
      --     -- text = icons.ui.Triangle,
      --     text = icons.gitsigns.TopDelete,
      --     numhl = 'GitSignsDeleteNr',
      --     linehl = 'GitSignsDeleteLn',
      --   },
      --   changedelete = {
      --     hl = 'GitSignsChange',
      --     -- text = icons.ui.BoldLineLeft,
      --     text = icons.gitsigns.ChangeDelete,
      --     numhl = 'GitSignsChangeNr',
      --     linehl = 'GitSignsChangeLn',
      --   },
      --   untracked = {
      --     text = icons.gitsigns.Untracked,
      --   },
      -- },
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      -- numhl = false,
      numhl = true,
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      -- current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      current_line_blame_formatter = '<author>, <author_time:%d-%m-%Y> - <summary>',
      -- current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      status_formatter = nil, -- Use default
      update_debounce = 200,
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
      -- yadm = { enable = false },
      -- signs = {
      --   add = { text = '+' },
      --   change = { text = '~' },
      --   delete = { text = '-' },
      --   topdelete = { text = '-' },
      --   changedelete = { text = '~' },
      -- },
      -- word_diff = true,
    },
  },
}
