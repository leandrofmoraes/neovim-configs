return {
  'nvimdev/lspsaga.nvim',
  -- enable = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
  event = 'LspAttach',
  -- config = function()
  --   local lspsaga = require('lspsaga')
  --   lspsaga.setup({
  opts = {
    debug = false,
    use_saga_diagnostic_sign = true,
    -- diagnostic sign
    error_sign = '',
    warn_sign = '',
    hint_sign = '',
    infor_sign = '',
    diagnostic_header_icon = '   ',
    -- code action title icon
    code_action_icon = ' ',
    code_action_prompt = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
    finder_definition_icon = '  ',
    finder_reference_icon = '  ',
    max_preview_lines = 10,

    lightbulb = {
      enable = false,
      sign = true, -- show sign in status column
      debounce = 10, -- timer debounce
      sign_priority = 40, -- sign priority
      virtual_text = true, -- show virtual text at the end of line
      enable_in_insert = true,
    },

    finder_action_keys = {
      open = 'o',
      vsplit = 's',
      split = 'i',
      quit = 'q',
      scroll_down = '<C-f>',
      scroll_up = '<C-b>',
    },

    hover = {
      max_width = 0.5,
    },

    code_action_keys = { quit = 'q', exec = '<CR>' },
    rename_action_keys = { quit = '<C-c>', exec = '<CR>' },
    definition_preview_icon = '  ',
    border_style = 'single',
    rename_prompt_prefix = '➤',
    server_filetype_map = {},
    diagnostic_prefix_format = '%d. ',
    -- })
    -- end,
  }
}
