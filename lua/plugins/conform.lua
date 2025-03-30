return {
  'stevearc/conform.nvim',
  -- optional = true,
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
      -- async = true, -- Recomendado para evitar bloqueio
    },
    formatters = {
      -- ['markdown-toc'] = {
      --   command = 'markdown-toc',
      --   args = { '-i', '-' },
      -- condition = function(_, ctx)
      --           return vim.fn.search('<!%-%- toc %-%->', 'nw', 0, ctx.buf) > 0
      --         end,
      --   condition = function(_, ctx)
      --     for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
      --       if line:find('<!%-%- toc %-%->') then
      --         return true
      --       end
      --     end
      --   end,
      -- },
      shfmt = {
        -- prepend_args = { '--indent', vim.o.shiftwidth or 4, '--case-indent' },
        prepend_args = {
          '--indent',
          vim.o.shiftwidth or 4,
          '--case-indent',
          'true',
        },
      },
      clang_format = {
        {
          command = 'clang-format',
          args = {
            '--style=Google', -- Chromium | GNU | Google | LLVM | Microsoft
            '--assume-filename=' .. vim.api.nvim_buf_get_name(0),
          },
        },
      },
    },
    formatters_by_ft = {
      ['markdown'] = { 'prettier', 'markdown-toc' },
      ['markdown.mdx'] = { 'prettier', 'markdown-toc' },
      sh = { 'shfmt' },
      go = { 'gofmt' },
      -- You can also customize some of the format options for the filetype
      rust = { 'rustfmt', lsp_format = 'fallback' },
      lua = { 'stylua' },
      yaml = { 'yamlfmt' },
      -- c = { 'clang-format' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
    },
  },
  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   pattern = '*',
  --   callback = function(args)
  --     require('conform').format({ bufnr = args.buf })
  --   end,
  -- }),
}
