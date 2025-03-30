return {
  'mfussenegger/nvim-lint',
  -- event = { 'BufWritePost' },
  config = function()
    require('lint').linters_by_ft = {
      bash = { 'shellcheck' },
      c = { 'cpplint' },
      cmake = { 'cmakelint' },
      css = { 'stylelint' },
      cpp = { 'cpplint' },
      dockerfile = { 'hadolint' },
      json = { 'jsonlint' },
      markdown = { 'markdownlint-cli2' },
      scss = { 'stylelint' },
      sh = { 'shellcheck' },
      -- python = { 'pylint' },  -- Adicione se tiver pylint instalado
      yaml = { 'yamllint' },
    }

    -- Configurações específicas para linters
    require('lint.linters.shellcheck').args = {
      '-x',
      '-f',
      -- 'gcc',
      '-s',
      'bash',
      '-',
    }
    -- Autocomando para lintar ao salvar
    vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
