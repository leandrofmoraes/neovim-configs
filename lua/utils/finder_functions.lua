local M = {}

local telescope = require("telescope")
-- local fzf = require('fzf-lua')
local builtin = require("telescope.builtin")
-- local picker = require("snacks.picker")

-- Função que checa qual plugin de busca está disponível
local function get_active_plugin()
  local has_telescope, _ = pcall(require, "telescope")
  local has_fzf, _ = pcall(require, "fzf-lua")

  if has_telescope then
    return "telescope"
  elseif has_fzf then
    return "fzf"
  else
    return nil
  end
end

M.my_search = function (plugin)
  -- Se o plugin não for especificado, tenta detectar automaticamente
  plugin = plugin or get_active_plugin()
  if plugin == "telescope" then
    require("telescope.builtin").find_files()
  elseif plugin == "fzf-lua" then
    require("fzf-lua").files()
  else
    print("Nenhum plugin de busca encontrado! Certifique-se de instalar o telescope ou o fzf-lua.")
  end
end

-- Carregar extensões do Telescope
M.file_browser = function()
  local function telescope_buffer_dir()
    return vim.fn.expand('%:p:h')
  end

  telescope.extensions.file_browser.file_browser({
    path = '%:p:h',
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    -- previewer = false,
    initial_mode = 'normal',
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 2 },
        height = { padding = 5 },
        preview_width = 0.6,
      },
    },
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    -- layout_strategy = 'bottom_pane',
  })

end

M.fidget = function()
  telescope.extensions.fidget.fidget({
    hidden = true,
    grouped = true,
    -- previewer = false,
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 2 },
        height = { padding = 5 },
        preview_width = 0.6,
      },
    },
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    -- layout_strategy = 'bottom_pane',
  })

end

M.buffers_list = function(plugin)
  plugin = plugin or get_active_plugin()
  -- require('telescope.builtin').buffers({
  if plugin == "telescope" then
  builtin.buffers({
    previewer = false,
    hidden = true,
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
  elseif plugin == "fzf-lua" then
    local fzf = require('fzf-lua')
    fzf.buffers({
      winopts = {
        preview = { hidden = true },
        height           = 0.40,            -- window height
        width            = 0.20,
      }
    })
  else
    vim.notify("Nenhum plugin de busca encontrado! Certifique-se de instalar o telescope ou o fzf-lua.", vim.log.levels.ERROR)
  end
end

M.picker_file_browser = function()
  local picker = require("snacks.picker")
  picker.explorer({
    -- format = "file",
    current = true,
    tree = false,
    layout = {
      preview = true,
      layout = {
        box = "horizontal",
        backdrop = false,
        width = 0.8,
        height = 0.9,
        border = "none",
        {
          box = "vertical",
          { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
          { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
        },
        {
          win = "preview",
          title = "{preview:Preview}",
          width = 0.6,
          border = "rounded",
          title_pos = "center",
        },
      },
    },
  })
end

-- M.picker_buffers = function()
--   ---@class snacks.picker.buffers.Config: snacks.picker.Config
--   ---@field hidden? boolean show hidden buffers (unlisted)
--   ---@field unloaded? boolean show loaded buffers
--   ---@field current? boolean show current buffer
--   ---@field nofile? boolean show `buftype=nofile` buffers
--   ---@field modified? boolean show only modified buffers
--   ---@field sort_lastused? boolean sort by last used
--   -- ---@field filter? snacks.picker.filter.Config
--   picker.buffers({
--     finder = "buffers",
--     format = "buffer",
--     hidden = false,
--     unloaded = true,
--     current = true,
--     sort_lastused = true,
--     layout = { preset = "select" },
--     win = {
--       input = {
--         keys = {
--           ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
--         },
--       },
--       list = { keys = { ["dd"] = "bufdelete" } },
--     },
--   })
-- end

M.live_grep = function()
  -- require('telescope.builtin').live_grep({
  builtin.live_grep({
    theme = 'ivy',
    sorting_strategy = 'ascending',
    layout_strategy = 'bottom_pane',
    prompt_prefix = '>> ',
    prompt_title = "~ search by word ~",
  })
end

M.find_files = function(plugin)
  plugin = plugin or get_active_plugin()
  if plugin == "telescope" then
  builtin.find_files({
    -- cwd = require("lazy.core.config").options.root
    cwd = vim.loop.cwd()
  })
  elseif plugin == "fzf-lua" then
    local fzf = require('fzf-lua')
    fzf.files()
  else
    vim.notify("Nenhum plugin de busca encontrado! Certifique-se de instalar o telescope ou o fzf-lua.", vim.log.levels.ERROR)
  end
end

-- M.picker_files = function()
--   ---@class snacks.picker.files.Config: snacks.picker.proc.Config
--   ---@field cmd? "fd"| "rg"| "find" command to use. Leave empty to auto-detect
--   ---@field hidden? boolean show hidden files
--   ---@field ignored? boolean show ignored files
--   ---@field dirs? string[] directories to search
--   ---@field follow? boolean follow symlinks
--   ---@field exclude? string[] exclude patterns
--   ---@field args? string[] additional arguments
--   ---@field ft? string|string[] file extension(s)
--   ---@field rtp? boolean search in runtimepath
--   picker.files({
--     finder = "files",
--     format = "file",
--     show_empty = true,
--     hidden = false,
--     ignored = false,
--     follow = false,
--     supports_live = true,
--   })
-- end
--
-- M.picker_notifications = function()
--   ---@class snacks.picker.notifications.Config: snacks.picker.Config
--   ---@field filter? snacks.notifier.level|fun(notif: snacks.notifier.Notif): boolean
--   picker.notifications({
--     finder = "snacks_notifier",
--     format = "notification",
--     preview = "preview",
--     formatters = { severity = { level = true } },
--     confirm = "close",
--   })
-- end

M.find_in_curr_workspace = function()
  -- return require("telescope.builtin").find_files({
  builtin.find_files({
    initial_mode = 'normal',
    no_ignore = false,
    hidden = true,
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 2 },
        height = { padding = 5 },
        preview_width = 0.6,
      },
    },
    layout_strategy = 'horizontal',
  })
end

M.find_in_curr_buffer = function()
  builtin.current_buffer_fuzzy_find({
    theme = 'dropdown',
    prompt_prefix = '>> ',
    prompt_title = "~ search by word ~",
    -- layout_strategy = 'bottom_pane',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 2 },
        height = { padding = 5 },
        preview_width = 0.5,
      },
    },
  })
end

-- M.picker_icons = function()
--   ---@class snacks.picker.icons.Config: snacks.picker.Config
--   ---@field icon_sources? string[]
--   picker.icons({
--     icon_sources = { "nerd_fonts", "emoji" },
--     finder = "icons",
--     format = "icon",
--     layout = { preset = "vscode" },
--     confirm = "put",
--   })
-- end

M.list_keymaps = function()
  -- require('telescope.builtin').keymaps({
  builtin.keymaps({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    -- layout_config = { height = 20, width = 60 },
    layout_config = {
      horizontal = {
        width = { padding = 2 },
        height = { padding = 5 },
      },
    }
  })
end

M.list_ts_symbols = function()
  -- require('telescope.builtin').treesitter({
  builtin.treesitter({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

M.help_tags = function()
  -- require('telescope.builtin').help_tags({
  builtin.help_tags({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    -- layout_config = { height = 20, width = 60 },
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 2 },
        height = { padding = 5 },
        preview_width = 0.6,
      },
    },
  })
end

M.recent_files = function()
  -- require('telescope.builtin').oldfiles({
  builtin.oldfiles({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 2 },
        height = { padding = 5 },
        preview_width = 0.6,
      },
    },

  })
end

M.man_pages = function()
  -- return require('telescope.builtin').man_pages()
  builtin.man_pages()
end

M.resume_telescope = function()
  -- require('telescope').extensions.resume()
  builtin.resume()
end

M.registers = function()
  -- require('telescope.builtin').registers({
  builtin.registers({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

M.commands = function()
  -- require('telescope.builtin').commands({
  builtin.commands({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

M.command_history = function()
  -- require('telescope.builtin').command_history({
  builtin.command_history({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

M.document_diagnostics = function()
  -- require('telescope.builtin').lsp_document_diagnostics({
  -- require('telescope.builtin').diagnostics({
  -- builtin.lsp_document_diagnostics({
  builtin.diagnostics({
    bufnr = 0,
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

M.workspace_diagnostics = function()
    -- require('telescope.builtin').diagnostics({
  builtin.diagnostics({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

M.lsp_document_symbols = function()
  -- require('telescope.builtin').lsp_document_symbols({
  builtin.lsp_document_symbols({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

M.lsp_document_diagnostics = function()
  -- require('telescope.builtin').lsp_document_diagnostics({
  builtin.lsp_document_diagnostics({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

M.lsp_workspace_diagnostics = function()
  -- require('telescope.builtin').lsp_workspace_diagnostics({
  builtin.lsp_workspace_diagnostics({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

M.git_status = function()
  -- require('telescope.builtin').git_status({
  builtin.git_status({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    -- layout_config = { height = 20, width = 60 },
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 2 },
        height = { padding = 5 },
        preview_width = 0.6,
      },
    },
  })
end

M.git_branches = function()
  -- require('telescope.builtin').git_branches({
  builtin.git_branches({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    -- layout_config = { height = 20, width = 60 },
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 2 },
        height = { padding = 5 },
        preview_width = 0.6,
      },
    },
  })
end

M.git_commits = function()
  -- require('telescope.builtin').git_commits({
  builtin.git_commits({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    -- layout_config = { height = 20, width = 60 },
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 2 },
        height = { padding = 5 },
        preview_width = 0.6,
      },
    },
  })
end

M.git_stash = function()
  -- require('telescope.builtin').git_stash({
  builtin.git_stash({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = { height = 20, width = 60 },
  })
end

-- require('telescope').load_extension('fzf')
-- require('telescope').load_extension('file_browser')
-- require("telescope").load_extension('undo')
-- pcall(telescope.load_extension, "fzf")
-- pcall(telescope.load_extension, "file_browser")
-- pcall(telescope.load_extension, "undo")

M.yank_history = function()
  telescope.extensions.yank_history.yank_history({
    theme = 'dropdown',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = { padding = 5 },
        height = { padding = 5 },
        preview_width = 0.5,
      },
    },
  })
end

return M
