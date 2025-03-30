-- local telefuncs = require('utils.telescope_functions')

---------------------------------------------------------------------
-- Funçoes redefinidas em utils/telescope_functions.lua
-- Functions redefined in utils/telescope_functions.lua
---------------------------------------------------------------------
-- local file_browser = function()
--   local telescope = require('telescope')
--
--   local function telescope_buffer_dir()
--     return vim.fn.expand('%:p:h')
--   end
--
--   telescope.extensions.file_browser.file_browser({
--     path = '%:p:h',
--     cwd = telescope_buffer_dir(),
--     respect_gitignore = false,
--     hidden = true,
--     grouped = true,
--     -- previewer = false,
--     initial_mode = 'normal',
--     -- layout_config = { height = 40 },
--     layout_config = { height = 30, width = 150 },
--     sorting_strategy = 'ascending',
--     layout_strategy = 'horizontal',
--     -- layout_strategy = 'bottom_pane',
--   })
-- end
--
-- local buffers_list = function()
--   require('telescope.builtin').buffers({
--     previewer = false,
--     hidden = true,
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local live_grep = function()
--   require('telescope.builtin').live_grep({
--     theme = 'ivy',
--     sorting_strategy = 'ascending',
--     layout_strategy = 'bottom_pane',
--     prompt_prefix = '>> ',
--     prompt_title = "~ search by word ~",
--   })
-- end
--
-- local find_files = function()
--   require("telescope.builtin").find_files({
--     cwd = require("lazy.core.config").options.root
--   })
-- end
--
-- local find_in_curr = function()
--   return require("telescope.builtin").find_files({
--     no_ignore = false,
--     hidden = true,
--   })
-- end
--
-- local list_keymaps = function()
--   require('telescope.builtin').keymaps({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local list_ts_symbols = function()
--   require('telescope.builtin').treesitter({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local help_tags = function()
--   require('telescope.builtin').help_tags({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local recent_files = function()
--   require('telescope.builtin').oldfiles({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local man_pages = function() return require('telescope.builtin').man_pages() end
--
-- local resume_telescope = function()
--   require('telescope').extensions.resume()
-- end
--
-- local registers = function()
--   require('telescope.builtin').registers({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local commands = function()
--   require('telescope.builtin').commands({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local command_history = function()
--   require('telescope.builtin').command_history({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local document_diagnostics = function()
--   -- require('telescope.builtin').lsp_document_diagnostics({
--   require('telescope.builtin').diagnostics({
--     bufnr = 0,
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local workspace_diagnostics = function()
--     require('telescope.builtin').diagnostics({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local lsp_document_symbols = function()
--   require('telescope.builtin').lsp_document_symbols({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- -- local lsp_document_diagnostics = function()
-- --   require('telescope.builtin').lsp_document_diagnostics({
-- --     theme = 'dropdown',
-- --     layout_strategy = 'horizontal',
-- --     layout_config = { height = 20, width = 60 },
-- --   })
-- -- end
--
-- -- local lsp_workspace_diagnostics = function()
-- --   require('telescope.builtin').lsp_workspace_diagnostics({
-- --     theme = 'dropdown',
-- --     layout_strategy = 'horizontal',
-- --     layout_config = { height = 20, width = 60 },
-- --   })
-- -- end
--
-- local git_status = function()
--   require('telescope.builtin').git_status({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local git_branches = function()
--   require('telescope.builtin').git_branches({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local git_commits = function()
--   require('telescope.builtin').git_commits({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end
--
-- local git_stash = function()
--   require('telescope.builtin').git_stash({
--     theme = 'dropdown',
--     layout_strategy = 'horizontal',
--     layout_config = { height = 20, width = 60 },
--   })
-- end

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'debugloop/telescope-undo.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
        require('telescope').load_extension('fzf')
      end,
    },
    {
      "ahmedkhalf/project.nvim",
      opts = {
        manual_mode = false,
      },
      event = "VeryLazy",
      -- corrigir implementação
      config = function(_, opts)
        -- require("project_nvim").setup(opts)
        -- require("lazyvim.util").on_load("telescope.nvim", function()
        --   require("telescope").load_extension("projects")
        -- end)
      end,
      -- keys = {
      --   { ";fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
      -- },
    },
    -- {
    --   "nvim-telescope/telescope-project.nvim",
    --   event = "BufWinEnter",
    --   setup = function()
    --     vim.cmd [[packadd telescope.nvim]]
    --   end,
    -- },

  },
  branch = '0.1.x',
  cmd = 'Telescope',
  -- keys = {
  --   { ';ft',              '<cmd>TodoTelescope<CR>',                                                      desc = 'Todo' },
  --   { ';fT',              '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>',                              desc = 'Todo/Fix/Fixme' },
  --   { ';fu',              '<cmd>Telescope undo<cr>',                                                     desc = 'Undo History' },
  --   { 'gu',               '<cmd>Telescope undo<cr>',                                                     desc = 'Undo History' },
  --   -- stylua: ignore start
  --   { ';bl',              telefuncs.buffers_list,                                                                  desc = 'List' },
  --   { ';<leader>',        telefuncs.buffers_list,                                                                  desc = 'Buffers List' },
  --   { ';.',               telefuncs.file_browser,                                                                  desc = "File Browser" },
  --
  --   { ';ff',              telefuncs.find_files,                                                                    desc = 'Files' },
  --   { ';fg',              telefuncs.find_in_curr,                                                                  desc = "Find files (respects .gitignore)" },
  --   { ';k',               telefuncs.list_keymaps,                                                                  desc = 'Keymaps' },
  --   { ";s",               telefuncs.list_ts_symbols,                                                               desc = "List Treesitter symbols" },
  --   { ';fs',              telefuncs.lsp_document_symbols(),                                                        desc = 'LSP Document symbols' },
  --   -- { ';dd',           telefuncs.   lsp_document_diagnostics(),                                                    desc = 'LSP Document diagnostics' },
  --   -- { ';dw',           telefuncs.   lsp_workspace_diagnostics(),                                                   desc = 'LSP Workspace diagnostics' },
  --
  --   { ';h',               telefuncs.help_tags,                                                                     desc = "Search and open help tags" },
  --   { ';t',               telefuncs.resume_telescope,                                                              desc = 'Resume the previous telescope picker' },
  --
  --   { ';fw',              telefuncs.live_grep,                                                                     desc = 'Words' },
  --   { ';fm',              telefuncs.man_pages,                                                                     desc = 'Man pages' },
  --   { ';fr',              telefuncs.recent_files,                                                                  desc = 'Recently opened' },
  --   { ';fR',              telefuncs.registers,                                                                     desc = 'Registers' },
  --   { ';fc',              telefuncs.commands,                                                                      desc = 'Commands' },
  --   { ';fC',              telefuncs.command_history,                                                               desc = 'Command history' },
  --
  --   { ';fd',              telefuncs.document_diagnostics,                                                          desc = 'Telescope document diagnostics' },
  --   { ';fD',              telefuncs.workspace_diagnostics,                                                         desc = 'Workspace diagnostics' },
  --
  --   { '<leader>go',       telefuncs.git_status,                                                                    desc = 'Search through changed files' },
  --   { '<leader>gb',       telefuncs.git_branches,                                                                  desc = 'Search through git branches' },
  --   { '<leader>gc',       telefuncs.git_commits,                                                                   desc = 'Search and checkout git commits' },
  --   { '<leader>gO',       telefuncs.git_stash,                                                                     desc = 'Search through stash' },
  -- },
  opts = function()
    -- File and text search in hidden files and directories
    -- local telescope = require('telescope')
    local actions = require('telescope.actions')
    local fb_actions = require('telescope').extensions.file_browser.actions

    -- Clone the default Telescope configuration
    -- local telescopeConfig = require('telescope.config')
    -- local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

    -- I want to search in hidden/dot files.
    -- table.insert(vimgrep_arguments, '--hidden')
    -- I don't want to search in the `.git` directory.
    -- table.insert(vimgrep_arguments, '--glob')
    -- table.insert(vimgrep_arguments, '!**/.git/*')

    return {
      defaults = {
        theme = "dropdown",
        prompt_prefix = ' ',
        selection_caret = ' ',
        mappings = { n = { ['q'] = actions.close } },
        -- mappings = { n = {} },
        -- theme = 'tokyonight',
        -- path_display = { 'smart' },
        initial_mode = "insert",
        selection_strategy = "reset",
        file_ignore_patterns = { '.git/' },
        -- layout_strategy = 'horizontal',
        -- layout_strategy = nil,
        layout_strategy = 'bottom_pane',
        layout_config = { prompt_position = 'top' },
        -- layout_config = {},
        -- sorting_strategy = nil,
        sorting_strategy = 'ascending',
        wrap_results = true,
        -- winblend = 0,
        -- vimgrep_arguments = vimgrep_arguments, //clone the default configuration
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
      },
      -- pickers = { find_files = { find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' } } },
      pickers = {
        diagnostics = {
          theme = 'ivy',
          initial_mode = 'normal',
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      },
      extensions = {
        file_browser = {
          theme = 'ivy', --'dropdown',
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            -- your custom insert mode mappings
            ['n'] = {
              -- your custom normal mode mappings
              ['N'] = fb_actions.create,
              ['h'] = fb_actions.goto_parent_dir,
              ['/'] = function()
                vim.cmd('startinsert')
              end,
              ['<C-u>'] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ['<C-d>'] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
              ['<PageUp>'] = actions.preview_scrolling_up,
              ['<PageDown>'] = actions.preview_scrolling_down,
            },
          },
        },

        undo = {
          use_delta = true,
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            horizontal = {
              -- prompt_position = "top",
              preview_width = 0.6,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            preview_height = 0.8,
          },
          -- layout_config = {
          --   preview_height = 0.8,
          -- },
        },
      },
      require('telescope').load_extension('fzf'),
      require('telescope').load_extension('file_browser'),
      require("telescope").load_extension('undo'),
      require("telescope").load_extension("yank_history"),
      require("telescope").load_extension("fidget")
    }
  end,
}
