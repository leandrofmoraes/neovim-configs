local M = {}
local util = require('plugins.lsp.lsp_util')

M.tailwindcss = {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = {
    -- html
    'aspnetcorerazor',
    'astro',
    'astro-markdown',
    'blade',
    'clojure',
    'django-html',
    'htmldjango',
    'edge',
    'eelixir', -- vim ft
    'elixir',
    'ejs',
    'erb',
    'eruby', -- vim ft
    'gohtml',
    'gohtmltmpl',
    'haml',
    'handlebars',
    'hbs',
    'html',
    'htmlangular',
    'html-eex',
    'heex',
    'jade',
    'leaf',
    'liquid',
    'markdown',
    'mdx',
    'mustache',
    'njk',
    'nunjucks',
    'php',
    'razor',
    'slim',
    'twig',
    -- css
    'css',
    'less',
    'postcss',
    'sass',
    'scss',
    'stylus',
    'sugarss',
    -- js
    'javascript',
    'javascriptreact',
    'reason',
    'rescript',
    'typescript',
    'typescriptreact',
    -- mixed
    'vue',
    'svelte',
    'templ',
  },
  -- root_dir = function(fname)
  --   return lsp_util.root_pattern(
  --     "tailwind.config.js",
  --     "tailwind.config.cjs",
  --     "tailwind.config.mjs"
  --   )(fname)
  -- end,
  root_dir = function(fname)
    return util.root_pattern(
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts'
    )(fname) or vim.fs.dirname(vim.fs.find('package.json', { path = fname, upward = true })[1]) or vim.fs.dirname(
        vim.fs.find('node_modules', { path = fname, upward = true })[1]
      ) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
  end,
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = {
        'class',
        'className',
        'class:list',
        'classList',
        'ngClass',
      },
      includeLanguages = {
        eelixir = 'html-eex',
        eruby = 'erb',
        templ = 'html',
        htmlangular = 'html',
      },
      experimental = {
        classRegex = {
          -- clsx, cn
          -- https://github.com/tailwindlabs/tailwindcss-intellisense/issues/682#issuecomment-1364585313
          { [[clsx\(([^)]*)\)]], [["([^"]*)"]] },
          { [[cn\(([^)]*)\)]], [["([^"]*)"]] },
          -- Tailwind Variants
          -- https://www.tailwind-variants.org/docs/getting-started#intellisense-setup-optional
          { [[tv\(([^)]*)\)]], [==[["'`]([^"'`]*).*?["'`]]==] },
        },
      },
    },
  },
  on_new_config = function(new_config)
    if not new_config.settings then
      new_config.settings = {}
    end
    if not new_config.settings.editor then
      new_config.settings.editor = {}
    end
    if not new_config.settings.editor.tabSize then
      -- set tab size for hover
      new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
  end,
  docs = {
    description = [[
      https://github.com/tailwindlabs/tailwindcss-intellisense

      Tailwind CSS Language Server can be installed via npm:
      ```sh
      npm install -g @tailwindcss/language-server
      ```
    ]],
  },
}

return M
