local M = {
  'tzachar/cmp-tabnine',
  event = 'InsertEnter',
  dependencies = 'hrsh7th/nvim-cmp',
  build = './install.sh',
}

function M.config() end

return M
