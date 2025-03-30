local icons = require('utils.icons')
-- local mini_icons = require('mini.icons')

-- which-key.nvim
return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- Carrega em um evento lazy, para não atrasar o startup
  -- opts_extend = { "spec" },
  opts = {
    defaults = {},
    ---@type false | "classic" | "modern" | "helix"
    preset = "helix",
    -- Defer popup display: return true only if mode is exactly visual line ('V') or visual block ('<C-V>')
    defer = function(ctx)
      return ctx.mode == "V" or ctx.mode == "<C-V>"
    end,
    notify = true,
    plugins = {
      marks = false,     -- Mostra os marcadores (' e `)
      registers = false, -- Mostra os registradores (quando pressionar " em modo normal ou <C-r> em inserção)
      spelling = {
        enabled = false,
        suggestions = 20,
      },
      presets = {
        operators = false,    -- adds help for operators like d, y, ...
        motions = false,      -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = true,       -- default bindings on <c-w>
        nav = false,          -- misc bindings to work with windows
        z = false,            -- bindings for folds, spelling and others prefixed with z
        g = false,            -- bindings for prefixed with g
      },
    },
    -- spec = {} -- Mappings are in "core.keymaps"
    icons = {
      breadcrumb = icons.ui.DoubleChevronRight, -- Símbolo na área de comando que mostra a sequência ativa
      separator = icons.ui.BoldArrowRight,      -- Separador entre a tecla e a descrição
      group = icons.ui.Plus,                    -- Prefixo para grupos de mapeamentos
      ellipsis = icons.ui.Ellipsis,
      mappings = true,
      rules = {},
      -- use the highlights from mini.icons
      -- When `false`, it will use `WhichKeyIcon` instead
      colors = true,
      keys = icons.keys,
    },
    show_help = true,                 -- Exibe uma mensagem de ajuda na linha de comando quando o popup estiver visível
    show_keys = true,                 -- Mostra a tecla pressionada e sua descrição na linha de comando
    win = {
      no_overlap = true,              -- don't allow the popup to overlap with the cursor
      border = "double",              -- Borda da janela: "none", "single", "double", "shadow", "rounded" ou "solid"
      height = { min = 4, max = 25 }, -- Altura mínima e máxima das colunas
      -- width = 1,
      title = false,
      title_pos = "center",
      -- zindex = 1000,
      padding = { 2, 2, 2, 2 },
      bo = {},
      wo = {
        winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
      },
    },
    layout = {
      width = { min = 20, max = 50 }, -- Largura mínima e máxima das colunas
      spacing = 3,                    -- Espaçamento entre colunas
      -- align = "center",               -- Alinhamento: "left", "center" ou "right"
    },
    keys = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>",   -- binding to scroll up inside the popup
    },
    -- ignore_missing = false,  -- Se true, não exibe aviso para mapeamentos não definidos
    -- triggers = "auto",       -- Define os gatilhos (ou lista manual) para abrir o popup
    triggers = {
      -- {"<leader>", "g", "]", "[", "z", ";"}
      { "<auto>", mode = "nxso" },
    },
    -- triggers = {
    --   { "<leader>", mode = { "n", "v" } },
    -- },
    debug = false, -- enable wk.log in the current directory
  },
  -- keys = keys,

  config = function(_, opts)
    local wk = require("which-key")
    require("plugins.which-key.which_keymaps")
    wk.setup(opts)
    if not vim.tbl_isempty(opts.defaults) then
      vim.notify("which-key: opts.defaults is deprecated. Please use opts.spec instead.", vim.log.levels.WARN)
      wk.register(opts.defaults)
    end
  end,
}
