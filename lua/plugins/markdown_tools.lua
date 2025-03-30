return {
  -- Markdown preview
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      require('lazy').load({ plugins = { 'markdown-preview.nvim' } })
      vim.fn['mkdp#util#install']()
    end,
    -- or install with yarn or npm
    -- build = "cd app && yarn install",
    -- init = function()
    --   vim.g.mkdp_filetypes = { "markdown" }
    -- end,
    keys = {
      {
        '<leader>cP',
        ft = 'markdown',
        '<cmd>MarkdownPreviewToggle<cr>',
        desc = 'Markdown Preview',
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
  -- render-markdown
  {
    enabled = false,
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      enabled = true,
      code = {
        -- Turn on / off code block & inline code rendering.
        enabled = true,
        sign = true,
        width = 'block',
        right_pad = 1,
      },
      heading = {
        sign = true,
        -- icons = {},
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        signs = { '󰫎 ' },
      },
      checkbox = {
        enabled = true,
        unchecked = {
          -- Replaces '[ ]' of 'task_list_marker_unchecked'.
          icon = '󰄱 ',
          -- Highlight for the unchecked icon.
          highlight = 'RenderMarkdownUnchecked',
          -- Highlight for item associated with unchecked checkbox.
          scope_highlight = nil,
        },
        checked = {
          -- Replaces '[x]' of 'task_list_marker_checked'.
          icon = '󰱒 ',
          -- Highlight for the checked icon.
          highlight = 'RenderMarkdownChecked',
          -- Highlight for item associated with checked checkbox.
          scope_highlight = nil,
        },
      },
      bullet = {
        -- Turn on / off list bullet rendering
        enabled = true,
        -- Additional modes to render list bullets
        render_modes = false,
        -- Replaces '-'|'+'|'*' of 'list_item'.
        -- If the item is a 'checkbox' a conceal is used to hide the bullet instead.
        -- Output is evaluated depending on the type.
        -- | function   | `value(context)`                                    |
        -- | string     | `value`                                             |
        -- | string[]   | `cycle(value, context.level)`                       |
        -- | string[][] | `clamp(cycle(value, context.level), context.index)` |
        icons = { '●', '○', '◆', '◇' },
        -- Replaces 'n.'|'n)' of 'list_item'.
        -- Output is evaluated using the same logic as 'icons'.
        ordered_icons = function(ctx)
          local value = vim.trim(ctx.value)
          local index = tonumber(value:sub(1, #value - 1))
          return string.format('%d.', index > 1 and index or ctx.index)
        end,
      },
    },
    ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
    config = function(_, opts)
      local Snacks = require('snacks')
      require('render-markdown').setup(opts)
      Snacks.toggle({
        name = 'Render Markdown',
        get = function()
          return require('render-markdown.state').enabled
        end,
        set = function(enabled)
          local m = require('render-markdown')
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map('<leader>cr')
    end,
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    --- Configuration table for `markview.nvim`.
    -- opts = {
    --   experimental = {
    --     date_formats = {},
    --     date_time_formats = {},
    --
    --     text_filetypes = {},
    --     read_chunk_size = 1000,
    --     link_open_alerts = false,
    --     file_open_command = "tabnew",
    --
    --     list_empty_line_tolerance = 3
    --   },
    --   highlight_groups = {},
    --   preview = {
    --     enable = true,
    --     filetypes = { "md", "rmd", "quarto" },
    --     ignore_buftypes = { "nofile" },
    --     ignore_previews = {},
    --
    --     modes = { "n", "no", "c" },
    --     hybrid_modes = {},
    --     debounce = 50,
    --     draw_range = { vim.o.lines, vim.o.lines },
    --     edit_range = { 1, 0 },
    --
    --     callbacks = {},
    --
    --     splitview_winopts = { split = "left" }
    --   },
    --   renderers = {},
    --
    --   html = {
    --     enable = true,
    --
    --     container_elements = {},
    --     headings = {},
    --     void_elements = {},
    --   },
    --   latex = {
    --     enable = true,
    --
    --     blocks = {},
    --     commands = {},
    --     escapes = {},
    --     fonts = {},
    --     inlines = {},
    --     parenthesis = {},
    --     subscripts = {},
    --     superscripts = {},
    --     symbols = {},
    --     texts = {}
    --   },
    --   markdown = {
    --     enable = true,
    --
    --     block_quotes = {},
    --     code_blocks = {},
    --     headings = {},
    --     horizontal_rules = {},
    --     list_items = {},
    --     metadata_plus = {},
    --     metadata_minus = {},
    --     tables = {}
    --   },
    --   markdown_inline = {
    --     enable = true,
    --
    --     block_references = {},
    --     checkboxes = {},
    --     emails = {},
    --     embed_files = {},
    --     entities = {},
    --     escapes = {},
    --     footnotes = {},
    --     highlights = {},
    --     hyperlinks = {},
    --     images = {},
    --     inline_codes = {},
    --     internal_links = {},
    --     uri_autolinks = {}
    --   },
    --   typst = {
    --     enable = true,
    --
    --     codes = {},
    --     escapes = {},
    --     headings = {},
    --     labels = {},
    --     list_items = {},
    --     math_blocks = {},
    --     math_spans = {},
    --     raw_blocks = {},
    --     raw_spans = {},
    --     reference_links = {},
    --     subscripts = {},
    --     superscript = {},
    --     symbols = {},
    --     terms = {},
    --     url_links = {}
    --   },
    --   yaml = {
    --     enable = true,
    --
    --     properties = {}
    --   }
    -- }
  },
  {
    'antonk52/markdowny.nvim',
    enabled = true, -- Opcional: controle de ativação/desativação global
    -- opts = {
    --   filetypes = { 'markdown', 'txt' },
    -- },
    config = function()
      require('markdowny').setup({ filetypes = { 'markdown', 'txt' } })
    end,
    keys = {
      { 'gmb', ":lua require('markdowny').bold()<cr>", mode = 'v', desc = 'Markdown Bold' },
      { 'gmi', ":lua require('markdowny').italic()<cr>", mode = 'v', desc = 'Markdown Italic' },
      { 'gml', ":lua require('markdowny').link()<cr>", mode = 'v', desc = 'Markdown Link' },
      { 'gmc', ":lua require('markdowny').code()<cr>", mode = 'v', desc = 'Markdown Code' },
    },
  },
}
