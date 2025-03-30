---@class snacks.dashboard.Config
---@field enabled? boolean
---@field sections snacks.dashboard.Section
---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>

local header = require("utils.logo")

local ok, icons = pcall(require, "utils.icons")
if not ok then
  icons = {
    file = "",
    directory = "",
    -- Adicione outros ícones se necessário.
  }
end

local function format_icon(item)
  -- Se o item representa um arquivo ou diretório e a propriedade 'icon' é "file" ou "directory",
  -- utiliza o ícone correspondente do módulo de ícones.
  if item.file and (item.icon == "file" or item.icon == "directory") then
    return { icons[item.icon] or item.icon, width = 2, hl = "icon" }
  end
  -- Caso contrário, retorna o ícone padrão fornecido no item.
  return { item.icon, width = 2, hl = "icon" }
end

local function format_file(item, ctx)
  local fname = vim.fn.fnamemodify(item.file, ":~")
  -- Se houver uma largura definida e o nome do arquivo for maior, encolhe o caminho.
  if ctx.width and #fname > ctx.width then
    fname = vim.fn.pathshorten(fname)
  end
  local dir, file = fname:match("^(.*)/(.+)$")
  if dir and file then
    return { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
  else
    return { { fname, hl = "file" } }
  end
end

return {
  autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
  enable = true,
  width = 60,
  row = nil, -- dashboard position. nil for center
  col = nil, -- dashboard position. nil for center
  pane_gap = 4, -- empty columns between vertical panes
  preset = {
    pick = nil,
    header = header.leovim,

    -- keys = {
    --   { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
    --   { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
    --   { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
    --   { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
    --   { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
    --   { icon = " ", key = "s", desc = "Restore Session", section = "session" },
    --   { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
    --   { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    -- },
  },

  formats = {
    icon = format_icon,
    footer = { "%s", align = "center" },
    header = { "%s", align = "center" },
    file = format_file,
  },
  sections = {
    { section = "header", indent = 60 },
    {
      { section = "keys", gap = 1, padding = 3 },
      { section = "startup", indent = 60, padding = 5 },
    },
    -- {
    -- 	pane = 2,
    -- 	section = "terminal",
    -- 	cmd = " ~/dotfiles/nvim/.config/nvim/plugin/dynamic_header.sh 'AEKC'",
    -- 	height = 5,
    -- 	padding = 3,
    -- 	indent = -60,
    -- },
    {
      pane = 2,
      {
        icon = " ",
        title = "Recent Files",
        padding = 1,
      },
      {
        section = "recent_files",
        opts = { limit = 3 },
        indent = 2,
        padding = 1,
      },
      {
        icon = " ",
        title = "Projects",
        padding = 1,
      },
      {
        section = "projects",
        opts = { limit = 3 },
        indent = 2,
        padding = 1,
      },
    },
  },
}
