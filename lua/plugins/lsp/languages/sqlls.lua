local M = {}
local util = require('plugins.lsp.lsp_util')

M.sqlls = {
  cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
  filetypes = { 'sql', 'mysql' },
  root_dir = util.root_pattern '.sqllsrc.json',
  single_file_support = true,
  settings = {},
  docs = {
    description = [[
https://github.com/joe-re/sql-language-server

This LSP can be installed via  `npm`. Find further instructions on manual installation of the sql-language-server at [joe-re/sql-language-server](https://github.com/joe-re/sql-language-server).
<br>
    ]],
  },
}

return M
