local M = {}

M.lemminx = {
  cmd = { 'lemminx' },
  filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
  end,
  single_file_support = true,
  docs = {
    description = [[
      https://github.com/eclipse/lemminx

      The easiest way to install the server is to get a binary from https://github.com/redhat-developer/vscode-xml/releases and place it on your PATH.

      NOTE to macOS users: Binaries from unidentified developers are blocked by default. If you trust the downloaded binary, run it once, cancel the prompt, then remove the binary from Gatekeeper quarantine with `xattr -d com.apple.quarantine lemminx`. It should now run without being blocked.

    ]],
  },
}

return M
