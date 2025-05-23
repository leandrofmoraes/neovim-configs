--> left_sep   :          
--> right_sep  :          

local utils = require("plugins.lualine.lualine_utils")
local icons = require('utils.icons')

local colors = {
  black = '#080808',
  white = '#c6c6c6',
  grey = '#303030',
  yellow = '#ECBE7B',
  cyan = '#79dac8',
  green = '#008787',
  orange = '#FF8800',
  magenta = '#c678dd',
  blue = '#4799EB',
  dblue = '#05142F',
  transparent = nil,
}

-- local diff = {
--         "diff",
--         color = { bg = colors.gray2, fg = colors.bg, gui = "bold" },
--         separator = { left = "", right = "" },
--         symbols = { added = " ", modified = " ", removed = " " },
--
--         diff_color = {
--             added = { fg = colors.green },
--             modified = { fg = colors.yellow },
--             removed = { fg = colors.red },
--         },
--     }

local my_theme = {
  normal = {
    a = { fg = colors.dblue, bg = colors.blue, gui = 'bold' },
    b = { fg = colors.blue, bg = colors.dblue },
    c = { fg = colors.blue, bg = colors.transparent },
  },
  insert = {
    a = { fg = colors.dblue, bg = colors.green, gui = 'bold' },
    b = { fg = colors.green, bg = colors.dblue },
    c = { fg = colors.green, bg = colors.transparent },
  },
  visual = {
    a = { fg = colors.dblue, bg = colors.yellow, gui = 'bold' },
    b = { fg = colors.yellow, bg = colors.dblue },
    c = { fg = colors.yellow, bg = colors.transparent },
  },
  command = {
    a = { fg = colors.dblue, bg = colors.magenta, gui = 'bold' },
    b = { fg = colors.magenta, bg = colors.dblue },
    c = { fg = colors.magenta, bg = colors.transparent },
  },
  inactive = {
    a = { fg = colors.blue, bg = colors.dblue, gui = 'bold' },
    b = { fg = colors.dblue, bg = colors.blue },
    c = { fg = colors.dblue, bg = colors.transparent },
  },
  replace = {
    a = { bg = colors.red, fg = colors.bg, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
}

local diff = {
  "diff",
  source = utils.diff_source,
  symbols = {
    added = icons.git.LineAdded .. " ",
    modified = icons.git.LineModified .. " ",
    removed = icons.git.LineRemoved .. " ",
  },
  padding = { left = 2, right = 1 },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.yellow },
    removed = { fg = colors.red },
  },
  cond = nil,
}

local lsp = {
  function()
    return utils.getLspClients()
  end
}

local multicursor = {
  utils.get_name,
  cond = utils.is_active,
  separator = { left = "" },
}

local modes = {
  "mode",
  -- color = function()
  --     local mode_color = modecolor
  --     return { bg = mode_color[vim.fn.mode()], fg = colors.bg_dark, gui = "bold" }
  -- end,
  separator = { left = "", right = "" },
}

local filetype = {
  'filetype',
  icon_only = true,
  separator = '',
  padding = { left = 1, right = 1 },
}

-- local navic = {
--   function()
--     return require('nvim-navic').get_location()
--   end,
--   cond = function()
--     return package.loaded['nvim-navic'] and require('nvim-navic').is_available()
--   end,
--   color_correction = 'static',
-- }
local betterEscape = {
  function()
    local ok, m = pcall(require, 'better_escape')
    return ok and m.waiting and '✺' or ''
  end,
}

local dap = {
  function()
    return require('dap').status()
  end,
  cond = function()
    return package.loaded['dap'] and require('dap').status() ~= ''
  end,
}

local dia = {
  'diagnostics',
  sources = { 'nvim_lsp', 'nvim_diagnostic' }
}

local progress = {
  'progress',
  separator = { right = "" },
}

return {
  {
    'linrongbin16/lsp-progress.nvim',
    -- commit = '70dfe3b',
    -- dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lsp-progress').setup()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      options = {
        theme = my_theme,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          'dashboard',
          'NeogitStatus',
          'NeogitCommitView',
          'NeogitPopup',
          'NeogitConsole',
        },
      },
      sections = {
        lualine_a = { multicursor, modes },
        lualine_b = { 'branch', diff, betterEscape },
        -- lualine_c = { navic },
        lualine_c = { lsp },
        lualine_x = { dap, dia },
        lualine_y = { filetype, 'filename', 'fileformat' },
        lualine_z = { 'location', progress },
      },
      extensions = {
        'man',
        'quickfix',
        'mason',
        'toggleterm',
        'neo-tree',
        'trouble',
        'lazy',
        'nvim-dap-ui',
      },
    },
  },
}
