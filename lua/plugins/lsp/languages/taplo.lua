local M = {}

M.taplo = {
  cmd = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' },

  root_dir = function(fname)
    -- converte bufnr (number) para nome do arquivo (string)
    if type(fname) == "number" then
      fname = vim.api.nvim_buf_get_name(fname)
    end

    -- se não houver nome (buffer novo/sem arquivo), usa cwd como fallback
    if not fname or fname == "" then
      fname = vim.loop.cwd()
    end

    local found = vim.fs.find({ ".git" }, { path = fname, upward = true })
    if found and #found > 0 then
      return vim.fs.dirname(found[1])
    end

    -- fallback: retorna o diretório do arquivo (ou cwd se for vazio)
    return vim.fs.dirname(fname)
  end,

  single_file_support = true,

  settings = {
    -- Use the defaults that the VSCode extension uses: https://github.com/tamasfe/taplo/blob/2e01e8cca235aae3d3f6d4415c06fd52e1523934/editors/vscode/package.json
    taplo = {
      configFile = { enabled = true },
      schema = {
        enabled = true,
        catalogs = { 'https://www.schemastore.org/api/json/catalog.json' },
        cache = {
          memoryExpiration = 60,
          diskExpiration = 600,
        },
      },
    },
  },
  docs = {
    description = [[
https://taplo.tamasfe.dev/cli/usage/language-server.html

Language server for Taplo, a TOML toolkit.

`taplo-cli` can be installed via `cargo`:
```sh
cargo install --features lsp --locked taplo-cli
```
    ]],
  },
}

return M
