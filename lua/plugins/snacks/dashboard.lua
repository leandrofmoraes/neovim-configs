-- Importa um módulo de ícones, se você já tiver um (ex: "utils.icons").
-- Caso contrário, você pode definir uma tabela simples com os ícones desejados.
local ok, icons = pcall(require, "utils.icons")
if not ok then
  icons = {
    file = "",
    directory = "",
    -- Adicione outros ícones se necessário.
  }
end

-- Certifique-se de que o módulo "config.logo" exista e retorne um cabeçalho apropriado.
local header = require("utils.logo")

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
  enable = true,
  width = 60,
  row = nil,       -- Posição vertical: nil para centralizar
  col = nil,       -- Posição horizontal: nil para centralizar
  pane_gap = 4,    -- Espaçamento entre as colunas dos painéis
  autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- Sequência de teclas automáticas

  -- Configurações usadas por seções internas do dashboard
  preset = {
    pick = nil,  -- Opcional: define um picker customizado (suporta fzf-lua, telescope, mini.pick, etc.)
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
    header = header.leovim,  -- Cabeçalho importado do módulo "config.logo"
  },

  -- Formatadores de campos para itens do dashboard
  formats = {
    icon = format_icon,
    footer = { "%s", align = "center" },
    header = { "%s", align = "center" },
    file = format_file,
  },

  -- Definição das seções do dashboard
  sections = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
    { section = "startup" },
  },
}
