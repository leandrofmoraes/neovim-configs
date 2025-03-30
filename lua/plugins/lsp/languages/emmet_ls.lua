local M = {}

M.emmet = {
  cmd = { 'emmet-ls', '--stdio' },
  filetypes = {
    'astro',
    'css',
    'eruby',
    'html',
    'htmldjango',
    'javascriptreact',
    -- 'less',
    -- 'pug',
    'sass',
    'scss',
    'svelte',
    'typescriptreact',
    'vue',
    'htmlangular',
  },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
  end,
  single_file_support = true,

  -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts
  init_options = {
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = true,

    html = {
      options = {
        ["bem.enabled"] = true,
        ["bem.modifier"] = "--",
      },
    },
    jsx = {
      options = {
        ["bem.enabled"] = true,
        ["jsx.enabled"] = true,
        ["output.selfClosingStyle"] = "xhtml",
      },
    },
  },
  docs = {
    description = [[
https://github.com/aca/emmet-ls

Package can be installed via `npm`:
```sh
npm install -g emmet-ls
```
]],
  },
}

return M

    -- configure emmet language server
    --   -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
    --   -- **Note:** only the options listed in the table are supported.
    --   init_options = {
    --     ---@type table<string, string>
    --     includeLanguages = {},
    --     --- @type string[]
    --     excludeLanguages = {},
    --     --- @type string[]
    --     extensionsPath = {},
    --     --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    --     preferences = {},
    --     --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    --     syntaxProfiles = {},
    --     --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    --     variables = {},
    --   },
