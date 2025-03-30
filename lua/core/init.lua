local modules = {
  "options",
  "autocommands",
  "lazy",
  "keymaps",
  -- Adicione mais módulos conforme necessário
}

-- local utils = require("core.safe_require")
local safe_require = require("utils.safe_require").safe_require

for _, module in ipairs(modules) do
  safe_require("core." .. module)
end
