return {
  -- {
  --   'smjonas/inc-rename.nvim',
  --   keys = {
  --     {
  --       'gr',
  --       function()
  --         return ':IncRename ' .. vim.fn.expand('<cword>')
  --       end,
  --       expr = true,
  --       desc = 'Rename',
  --     },
  --     {
  --       '<leader>rr',
  --       function()
  --         return ':IncRename ' .. vim.fn.expand('<cword>')
  --       end,
  --       expr = true,
  --       desc = 'Rename',
  --     },
  --   },
  --   opts = {
  --     cmd_name = "IncRename", -- the name of the command
  --     hl_group = "Substitute", -- the highlight group used for highlighting the identifier's new name
  --     preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancelled instead
  --     show_message = true, -- whether to display a `Renamed m instances in n files` message after a rename operation
  --     post_hook = nil, -- callback to run after renaming, receives the result table (from LSP handler) as an argument
  --     -- input_buffer_type = "dressing", -- the type of the external input buffer to use (the only supported value is currently "dressing")
  --     input_buffer_type = 'noice'
  --   },
  -- },
  -- actions-preview.nvim
  -- {
  --   'aznhe21/actions-preview.nvim',
  --   dependencies = 'nvim-telescope/telescope.nvim',
  --   opts = {
  --     telescope = {
  --       sorting_strategy = 'ascending',
  --       layout_strategy = 'vertical',
  --       layout_config = {
  --         width = 0.8,
  --         height = 0.9,
  --         prompt_position = 'top',
  --         preview_cutoff = 20,
  --         preview_height = function(_, _, max_lines)
  --           return max_lines - 15
  --         end,
  --       },
  --     },
  --   },
  -- keys = {
  --   {
  --     '<leader>ac',
  --     function()
  --       return require('actions-preview').code_actions()
  --     end,
  --     mode = { 'n', 'v' },
  --     desc = 'Action Preview',
  --   },
  --   {
  --     '<leader>aa',
  --     "<cmd>lua vim.lsp.buf.code_action()<cr>",
  --     desc = "Actions"
  --   },
  -- },
  -- },

  -- nvim-dap
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
      -- Fancy UI for the debugger
      -- 'nvim-neotest/nvim-nio',
      -- nvim-dap-virtual-text
      { "rcarriga/nvim-dap-ui" },

      -- { 'theHamsta/nvim-dap-virtual-text', opts = { highlight_new_as_changed = true } },

      -- mason-nvim-dap.nvim
      -- {
      --   'jay-babu/mason-nvim-dap.nvim',
      --   cmd = { 'DapInstall', 'DapUninstall' },
      --   dependencies = 'williamboman/mason.nvim',
      --   opts = {
      --     automatic_installation = true,
      --     handlers = {},
      --     ensure_installed = { 'codelldb' },
      --   },
      -- },
      -- Lua adapter.
      -- {
      --   'jbyuki/one-small-step-for-vimkind',
      --   keys = {
      --     {
      --       '<leader>da',
      --       function()
      --         require('osv').launch { port = 8086 }
      --       end,
      --       desc = 'Launch Lua adapter',
      --     },
      --   },
      -- },

      -- goto-breakpoints.nvim
      -- {
      --   'ofirgall/goto-breakpoints.nvim',
      --   keys = {
      --     -- stylua: ignore start
      --     { ']b', function() return require('goto-breakpoints').next() end, desc = 'Next breakpoint' },
      --     { '[b', function() return require('goto-breakpoints').prev() end, desc = 'Previous breakpoint' },
      --     -- stylua: ignore end
      --   },
      -- },

      -- nvim-dap-ui
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        lazy = true,
        keys = {
          -- stylua: ignore start
          { '<leader>Tu', function() return require('dapui').toggle() end, desc = 'Dap UI' },
          { '<leader>Tv', function() return require('dapui').eval() end,   desc = 'Eval',  mode = { 'n', 'v' } },
          -- stylua: ignore end
        },
        --   config = function()
        --     local dap = require('dap')
        --     local dapui = require('dapui')
        --     dapui.setup()
        --     dap.listeners.after.event_initialized['dapui_config'] = function()
        --       dapui.open()
        --     end
        --     dap.listeners.before.event_terminated['dapui_config'] = function()
        --       dapui.close()
        --     end
        --     dap.listeners.before.event_exited['dapui_config'] = function()
        --       dapui.close()
        --     end
        --   end,
      },
    },
    opts = {
      -- Simple configuration to attach to remote java debug process
      -- Taken directly from https://github.com/mfussenegger/nvim-dap/wiki/Java
      configurations = {
        java = {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        }
      },
    },
    keys = {
      --   -- stylua: ignore start
      { '<leader>TB', function() return require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Breakpoint Condition' },
      { '<leader>Tb', function() return require('dap').toggle_breakpoint() end,                                    desc = 'Toggle Breakpoint' },
      { '<leader>Tc', function() return require('dap').continue() end,                                             desc = 'Continue' },
      { '<leader>TC', function() return require('dap').run_to_cursor() end,                                        desc = 'Run to Cursor' },
      { '<leader>Tg', function() return require('dap').goto_() end,                                                desc = 'Go to line (no execute)' },
      { '<leader>Ti', function() return require('dap').step_into() end,                                            desc = 'Step Into' },
      { '<leader>Tj', function() return require('dap').down() end,                                                 desc = 'Down' },
      { '<leader>Tk', function() return require('dap').up() end,                                                   desc = 'Up' },
      { '<leader>Tl', function() return require('dap').run_last() end,                                             desc = 'Run Last' },
      { '<leader>TO', function() return require('dap').step_out() end,                                             desc = 'Step Out' },
      { '<leader>To', function() return require('dap').step_over() end,                                            desc = 'Step Over' },
      { '<leader>Tp', function() return require('dap').pause() end,                                                desc = 'Pause' },
      { '<leader>Tr', function() return require('dap').repl.toggle() end,                                          desc = 'Toggle REPL' },
      { '<leader>Ts', function() return require('dap').session() end,                                              desc = 'Session' },
      { '<leader>Tt', function() return require('dap').terminate() end,                                            desc = 'Terminate' },
      { '<leader>Tw', function() return require('dap.ui.widgets').hover() end,                                     desc = 'Widgets' },
      --   -- stylua: ignore end
    },
    config = function()
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
    end,
  },

  { 'mxsdev/nvim-dap-vscode-js' },
}
