-- Filetypes in which to highlight color codes.
local colored_fts = {
  'cfg',
  'css',
  'conf',
  'config',
  'lua',
  'scss',
}

-- Create Color Code.
return {
  {
    'uga-rosa/ccc.nvim',
    ft = colored_fts,
    cmd = 'CccPick',
    opts = function()
      local ccc = require 'ccc'

      -- Use uppercase for hex codes.
      ccc.output.hex.setup { uppercase = true }
      ccc.output.hex_short.setup { uppercase = true }

      return {
        highlighter = {
          auto_enable = true,
          filetypes = colored_fts,
        },
        -- LSP causes the highlights to not cover the correct range.
        lsp = false,
        ---@usage "fg" | "bg" | "foreground" | "background" | "virtual" - Default: "bg"
        highlight_mode = "background",
        ---@string --Default: " ● "
        virtual_symbol = "■",
        ---@usage "inline-left" | "inline-right" | "eol"
        virtual_pos = "inline-left",
      }
    end,
    keys = function()
      return {
        { "gh",        "<cmd>CccPick<cr>",              mode = { 'n', 'v' }, desc = "Color Pick" },
        { "gH",        "<cmd>CccConvert<cr>",           mode = { 'n', 'v' }, desc = "Color Convert" },
        { "<leader>h", "<cmd>CccHighlighterToggle<cr>", mode = { 'n' },    desc = "Highlight Colors" },
        -- { "gC", require("ccc").mapping.complete(), { mode = {'n', 'v'}, desc = "Color Pick"}}
      }
    end
  },
}
