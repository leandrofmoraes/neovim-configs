local M = {}
local util = require('plugins.lsp.lsp_util')

M.cmake = {
  cmd = { 'cmake-language-server' },
  filetypes = { 'cmake' },
  root_dir = function(fname)
    return util.root_pattern('CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake')(fname)
  end,
  single_file_support = true,
  init_options = {
    buildDirectory = 'build',
  },
  docs = {
    description = [[
https://github.com/regen100/cmake-language-server

CMake LSP Implementation
]],
  },
}

return M
