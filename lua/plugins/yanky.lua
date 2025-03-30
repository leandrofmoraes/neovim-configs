local finder = require('utils.finder_functions')

-- Better copy/pasting.
return {
  'gbprod/yanky.nvim',
  -- lazy = false,
  opts = {
    ring = {
      history_length = 100,
      storage = "memory",                                             -- Default : shada | Available : shada, sqlite or memory
      storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
      sync_with_numbered_registers = true,
      cancel_event = "update",
      ignore_registers = { "_" },
      update_register_on_cycle = false,
      permanent_wrapper = nil,
    },
    picker = {
      select = {
        action = nil, -- nil to use default put action
      },
      telescope = {
        use_default_mappings = true, -- if default mappings should be used
        mappings = nil,              -- nil to use default mappings or no mappings (see `use_default_mappings`)
      },
    },
    system_clipboard = {
      sync_with_ring = true,
      clipboard_register = nil,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 250,
    },
    preserve_cursor_position = {
      enabled = true,
    },
    textobj = {
      enabled = false,
    },
    -- keys = {
    --   { 'p',  '<Plug>(YankyPutAfter)',          mode = { 'n', 'x' },                         desc = 'Put yanked text after cursor' },
    --   { 'P',  '<Plug>(YankyPutBefore)',         mode = { 'n', 'x' },                         desc = 'Put yanked text before cursor' },
    --   { '=p', '<Plug>(YankyPutAfterLinewise)',  desc = 'Put yanked text in line below' },
    --   { '=P', '<Plug>(YankyPutBeforeLinewise)', desc = 'Put yanked text in line above' },
    --   { '[y', '<Plug>(YankyCycleForward)',      desc = 'Cycle forward through yank history' },
    --   { ']y', '<Plug>(YankyCycleBackward)',     desc = 'Cycle backward through yank history' },
    --   { 'y',  '<Plug>(YankyYank)',              mode = { 'n', 'x' },                         desc = 'Yanky yank' },
    --   { ';y', finder.yank_history,              mode = { 'n' },                              desc = 'Yank History' }
    -- },
  }
}
