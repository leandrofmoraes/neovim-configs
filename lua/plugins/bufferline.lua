-- bufferline.nvim
return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  version = '*',
  -- event = 'UIEnter',
  event = "BufEnter",
  -- event = { 'BufAdd' },
  -- event = { 'BufReadPost', 'BufNewFile' },
  -- keys = {
    -- { '<Tab>',      '<cmd>BufferLineCycleNext<CR>',                       desc = 'Next buffer' },
    -- { '<S-Tab>',    '<cmd>BufferLineCyclePrev<CR>',                       desc = 'Previous buffer' },
    -- { '<S-l>',      '<cmd>BufferLineMoveNext<CR>',                        desc = 'Move current buffer forwards' },
    -- { '<S-h>',      '<cmd>BufferLineMovePrev<CR>',                        desc = 'Move current buffer backwards' },
    --
    -- { ';;l', '<cmd>BufferLineCycleNext<CR>',                              desc = 'Next' },
    -- { ';;h', '<cmd>BufferLineCyclePrev<CR>',                              desc = 'Previous' },
    -- { ';;L', '<cmd>BufferLineMoveNext<CR>',                               desc = 'Move forwards' },
    -- { ';;H', '<cmd>BufferLineMovePrev<CR>',                               desc = 'Move backwards' },
    -- stylua: ignore start
    -- mapped in "core.keymaps"
    ------------------------------------------------------
    -- { ';;B', function() return require('bufferline').move_to(1) end,      desc = 'Move buffer to beginning' },
    -- { ';;E', function() return require('bufferline').move_to(-1) end,     desc = 'Move buffer to end' },
    -- { ';;1', function() return require('bufferline').go_to(1, true) end,  desc = 'Jump to first' },
    -- { ';;2', function() return require('bufferline').go_to(2, true) end,  desc = 'Jump to second' },
    -- { ';;3', function() return require('bufferline').go_to(3, true) end,  desc = 'Jump to third' },
    -- { ';;4', function() return require('bufferline').go_to(4, true) end,  desc = 'Jump to fourth' },
    -- { ';;5', function() return require('bufferline').go_to(5, true) end,  desc = 'Jump to fifth' },
    -- { ';;6', function() return require('bufferline').go_to(6, true) end,  desc = 'Jump to sixth' },
    -- { ';;7', function() return require('bufferline').go_to(7, true) end,  desc = 'Jump to seventh' },
    -- { ';;8', function() return require('bufferline').go_to(8, true) end,  desc = 'Jump to eighth' },
    -- { ';;9', function() return require('bufferline').go_to(9, true) end,  desc = 'Jump to ninth' },
    -- { ';;$', function() return require('bufferline').go_to(-1, true) end, desc = 'Jump to last' },

    -- stylua: ignore end
  -- },
  opts = {
    options = {
      numbers = function(opts)
        return string.format('%s', opts.ordinal)
      end,
      mode = 'buffers',
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(_, _, diag)
        local ret = (diag.error and ' ' .. diag.error .. ' ' or '')
            .. (diag.warning and ' ' .. diag.warning or '')
        return vim.trim(ret)
      end,
      right_mouse_command = 'vert sbuffer %d', -- can be a string | function, see "Mouse actions"
      left_mouse_command = 'buffer %d',        -- can be a string | function, see "Mouse actions"
      middle_mouse_command = nil,              -- can be a string | function, see "Mouse actions"
      name_formatter = function(buf)           -- buf contains a "name", "path" and "bufnr"
        -- remove extension from markdown files for example
        if buf.name:match('%.md') then
          return vim.fn.fnamemodify(buf.name, ':t:r')
        end
      end,
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      truncate_names = true,  -- whether or not tab names should be truncated
      show_buffer_icons = true, -- | false, -- disable filetype icons for buffers
      show_buffer_close_icons = true, -- | false,
      show_close_icon = true, -- | false,
      show_tab_indicators = true, -- | false,
      show_duplicate_prefix = true, -- | false, -- whether to show duplicate buffer prefix
      duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      separator_style = "thin", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
      enforce_regular_tabs = false, -- | true,
      always_show_bufferline = false, -- | false,
      auto_toggle_bufferline = true, -- | false,
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Neo-tree',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
    },
  },
}
