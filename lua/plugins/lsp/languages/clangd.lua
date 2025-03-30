-- -- -- C/C++
local M = {}
local util = require 'plugins.lsp.lsp_util'

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
  local method_name = 'textDocument/switchSourceHeader'
  bufnr = util.validate_bufnr(bufnr)
  local client = util.get_active_client_by_name(bufnr, 'clangd')
  if not client then
    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client.request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify('corresponding file cannot be determined')
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

local function symbol_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local clangd_client = util.get_active_client_by_name(bufnr, 'clangd')
  if not clangd_client or not clangd_client.supports_method 'textDocument/symbolInfo' then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, clangd_client.offset_encoding)
  clangd_client.request('textDocument/symbolInfo', params, function(err, res)
    if err or #res == 0 then
      -- Clangd always returns an error, there is not reason to parse it
      return
    end
    local container = string.format('container: %s', res[1].containerName) ---@type string
    local name = string.format('name: %s', res[1].name) ---@type string
    vim.lsp.util.open_floating_preview({ name, container }, '', {
      height = 2,
      width = math.max(string.len(name), string.len(container)),
      focusable = false,
      focus = false,
      border = 'single',
      title = 'Symbol Info',
    })
  end, bufnr)
end

M.clangd = {
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  -- keys = {
  --   { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch source/header (C/C++)" },
  -- },
  -- root_dir = function(fname)
  --   return require("lspconfig.util").root_pattern(
  --     "Makefile",
  --     "configure.ac",
  --     "configure.in",
  --     "config.h.in",
  --     "meson.build",
  --     "meson_options.txt",
  --     "build.ninja"
  --   )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
  --       fname
  --     ) or require("lspconfig.util").find_git_ancestor(fname)
  -- end,
  root_dir = function(fname)
    return util.root_pattern(
      '.clangd',
      '.clang-tidy',
      '.clang-format',
      'compile_commands.json',
      'compile_flags.txt',
      'configure.ac', -- AutoTools

      "Makefile",
      "configure.ac",
      "configure.in",
      "config.h.in",
      "meson.build",
      "meson_options.txt",
      "build.ninja"
    )(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
  end,
  single_file_support = true,
  capabilities = {
    -- offsetEncoding = { "utf-8", "utf-16" },
    offsetEncoding = "utf-16", -- Clangd >= 14 usa UTF-16 por padrão
    textDocument = {
      completion = {
        editsNearCursor = true,
        completionItem = {
          commitCharactersSupport = true,
          insertReplaceSupport = true,
          snippetSupport = true,
          deprecatedSupport = true,
          labelDetailsSupport = true,
          preselectSupport = false,
          resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
          },
          tagSupport = {
            valueSet = { 1 },
          },
        },
      },
    },
  },
  cmd = {
    "clangd",
    "--clang-tidy",
    "--background-index",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    -- "--function-arg-placeholders",
    '--function-arg-placeholders=false',
    "--enable-config",
    -- '--offset-encoding=utf-16',

    -- Resolve standard include paths for cross-compilation targets
    -- "--query-driver=/usr/sbin/arm-none-eabi-gcc,/usr/sbin/aarch64-linux-gnu-gcc",

    -- Auto-format only if .clang-format exists
    "--fallback-style=none",
    -- "--fallback-style=llvm",
    "--offset-encoding=utf-16", -- Forçar explicitamente
  },
  -- codeLens = {
  --   enable = true,
  -- },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  commands = {
    ClangdSwitchSourceHeader = {
      function()
        switch_source_header(0)
      end,
      description = 'Switch between source/header',
    },
    ClangdShowSymbolInfo = {
      function()
        symbol_info()
      end,
      description = 'Show symbol info',
    },
  },
  docs = {
    description = [[
https://clangd.llvm.org/installation.html

- **NOTE:** Clang >= 11 is recommended! See [#23](https://github.com/neovim/nvim-lspconfig/issues/23).
- If `compile_commands.json` lives in a build directory, you should
  symlink it to the root of your source tree.
  ```
  ln -s /path/to/myproject/build/compile_commands.json /path/to/myproject/
  ```
- clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html)
  specified as compile_commands.json, see https://clangd.llvm.org/installation#compile_commandsjson
]],
  },
  -- },
  setup = {
    clangd = function(_, opts)
      local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
      require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
      return false
    end,
  }
}

return M
