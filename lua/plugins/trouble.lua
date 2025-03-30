-- better diagnostics list and others
return {
  "folke/trouble.nvim",
  dependencies = 'nvim-tree/nvim-web-devicons',
  cmd = { "Trouble" },
  opts = {
    auto_close = false,      -- auto close when there are no items
    auto_open = false,       -- auto open when there are items
    auto_preview = true,     -- automatically open preview when on an item
    auto_refresh = true,     -- auto refresh when open
    auto_jump = false,       -- auto jump to the item when there's only one
    focus = false,           -- Focus the window when opened
    restore = true,          -- restores the last location in the list when opening
    follow = true,           -- Follow the current item
    indent_guides = true,    -- show indent guides
    max_items = 200,         -- limit number of items that can be displayed per section
    multiline = true,        -- render multi-line messages
    pinned = false,          -- When pinned, the opened trouble window will be bound to the current buffer
    warn_no_results = true,  -- show a warning when there are no results
    open_no_results = false, -- open the trouble window when there are no results
    use_diagnostic_signs = true,
    ---@type trouble.Window.opts
    win = {}, -- window options for the results window. Can be a split or a floating window.
    -- Window options for the preview window. Can be a split, floating window,
    -- or `main` to show the preview in the main editor window.
    ---@type trouble.Window.opts
    preview = {
      type = "main",
      -- when a buffer is not yet loaded, the preview window will be created
      -- in a scratch buffer with only syntax highlighting enabled.
      -- Set to false, if you want the preview to always be a real loaded buffer.
      scratch = true,
    },
    -- Throttle/Debounce settings. Should usually not be changed.
    ---@type table<string, number|{ms:number, debounce?:boolean}>
    throttle = {
      refresh = 20,                                                                        -- fetches new data when needed
      update = 10,                                                                         -- updates the window
      render = 10,                                                                         -- renders the window
      follow = 100,                                                                        -- follows the current item
      preview = { ms = 100, debounce = true },                                             -- shows the preview for the current item
    },
    include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions" },  -- for the given modes, include the declaration of the current symbol in the results
    mode = "workspace_diagnostics",                                                        -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    -- modes = {
    --   lsp = {
    --     win = { position = "right" },
    --   },
    -- },
  },
  keys = {
    { "<leader>dx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
    { "<leader>dX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>ds", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols (Trouble)" },
    { "<leader>dS", "<cmd>Trouble lsp toggle<cr>",                      desc = "LSP references/definitions/... (Trouble)" },
    { "<leader>dL", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List (Trouble)" },
    { "<leader>dQ", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List (Trouble)" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Previous Trouble/Quickfix Item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Next Trouble/Quickfix Item",
    },
  },
}
