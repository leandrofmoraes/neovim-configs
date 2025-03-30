-- treesj
return {
  -- enabled = false,
  'Wansmer/treesj',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  opts = {
    max_join_length = 500,
    check_syntax_error = true,
    use_default_keymaps = false,
    ---Cursor behavior:
    ---hold - cursor follows the node/place on which it was called
    ---start - cursor jumps to the first symbol of the node being formatted
    ---end - cursor jumps to the last symbol of the node being formatted
    ---@type 'hold'|'start'|'end'
    cursor_behavior = 'hold',
    ---@type boolean Notify about possible problems or not
    notify = false,
    ---@type boolean Use `dot` for repeat action
    dot_repeat = true,
    ---@type nil|function Callback for treesj error handler. func (err_text, level, ...other_text)
    on_error = nil,
    ---@type table Presets for languages
    -- langs = {}, -- See the default presets in lua/treesj/langs
  },
  keys = { -- see 'core.keymaps'
    -- stylua: ignore start
    { 'g/m', function() return require('treesj').toggle() end, desc = 'Toggle' },
    { 'g/j', function() return require('treesj').join() end,   desc = 'Join' },
    { 'g/s', function() return require('treesj').split() end,  desc = 'Split' },
    -- stylua: ignore end
  },
}
