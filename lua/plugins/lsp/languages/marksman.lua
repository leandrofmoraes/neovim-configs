local M = {}

local util = require('plugins.lsp.lsp_util')
local bin_name = 'marksman'
local cmd = { bin_name, 'server' }

M.markdown = {
  cmd = cmd,
  filetypes = { 'markdown', 'markdown.mdx' },
  root_dir = function(fname)
    local root_files = { '.marksman.toml' }
    return util.root_pattern(unpack(root_files))(fname)
      or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
  end,
  single_file_support = true,
  settings = {
    marksman = {
      server = {
        enabled = true,
      },
    },
  },
  on_attach = function(_, bufnr)
    vim.keymap.set('v', 'gmb', ":lua require('markdowny').bold()<cr>", { desc = 'Bold', buffer = bufnr })
    vim.keymap.set('v', 'gmi', ":lua require('markdowny').italic()<cr>", { desc = 'Italic', buffer = bufnr })
    vim.keymap.set('v', 'gml', ":lua require('markdowny').link()<cr>", { desc = 'Link', buffer = bufnr })
    vim.keymap.set('v', 'gmc', ":lua require('markdowny').code()<cr>", { desc = 'Code', buffer = 0 })
    vim.keymap.set(
      'n',
      'gmp',
      '<cmd>PasteImage<cr>', --require "HakonHarnes/img-clip.nvim"
      { desc = 'Paste image from system clipboard' }
    )
    vim.keymap.set(
      'n',
      '<leader>ct',
      '<cmd>Markview Toggle<cr>', --require "OXY2DEV/markview.nvim"
      { desc = 'Markview Toggle' }
    )
    vim.keymap.set(
      'n',
      '<leader>cv',
      '<cmd>Markview open<cr>', --require "OXY2DEV/markview.nvim"
      { desc = 'Opens the link under cursor' }
    )
  end,
}

return M
