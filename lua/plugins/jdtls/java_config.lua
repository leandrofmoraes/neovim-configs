local M = {}
local Util = require('plugins.jdtls.java_util')
local handlers = require('vim.lsp.handlers')
-- TextDocument version is reported as 0, override with nil so that
-- the client doesn't think the document is newer and refuses to update
-- See: https://github.com/eclipse/eclipse.jdt.ls/issues/1695
local function fix_zero_version(workspace_edit)
  if workspace_edit and workspace_edit.documentChanges then
    for _, change in pairs(workspace_edit.documentChanges) do
      local text_document = change.textDocument
      if text_document and text_document.version and text_document.version == 0 then
        text_document.version = nil
      end
    end
  end
  return workspace_edit
end

local function on_textdocument_codeaction(err, actions, ctx)
  for _, action in ipairs(actions) do
    -- TODO: (steelsojka) Handle more than one edit?
    if action.command == 'java.apply.workspaceEdit' then -- 'action' is Command in java format
      action.edit = fix_zero_version(action.edit or action.arguments[1])
    elseif type(action.command) == 'table' and action.command.command == 'java.apply.workspaceEdit' then -- 'action' is CodeAction in java format
      action.edit = fix_zero_version(action.edit or action.command.arguments[1])
    end
  end

  handlers[ctx.method](err, actions, ctx)
end

local function on_textdocument_rename(err, workspace_edit, ctx)
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end

local function on_workspace_applyedit(err, workspace_edit, ctx)
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end

-- Non-standard notification that can be used to display progress
local function on_language_status(_, result)
  local command = vim.api.nvim_command
  command('echohl ModeMsg')
  command(string.format('echo "%s"', result.message))
  command('echohl None')
end

function M.get_config()
  local opts = Util.get_plugin_opts('nvim-jdtls') or {}
  -- local fname = vim.api.nvim_buf_get_name(buf)
  -- local fname = vim.api.nvim_buf_get_name(0)

  -- Configuration can be augmented and overridden by opts.jdtls
  return Util.extend_or_override({

    filetypes = opts.filetypes or { 'java' },
    -- cmd = opts.full_cmd(opts),
    -- cmd = Util.build_full_cmd(opts),
    cmd = opts.cmd,
    -- root_dir = require('lspconfig.configs.jdtls').default_config.root_dir,
    -- root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
    root_dir = opts.root_dir(),
    single_file_support = opts.single_file_support,
    init_options = {
      bundles = Util.get_bundles(opts),
    },
    handlers = {
      -- Due to an invalid protocol implementation in the jdtls we have to conform these to be spec compliant.
      -- https://github.com/eclipse/eclipse.jdt.ls/issues/376
      ['textDocument/codeAction'] = on_textdocument_codeaction,
      ['textDocument/rename'] = on_textdocument_rename,
      ['workspace/applyEdit'] = on_workspace_applyedit,
      ['language/status'] = vim.schedule_wrap(on_language_status),
    },
    -- enable CMP capabilities
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(),
    -- capabilities = require("blink").get_lsp_capabilities(),
    eclipse = {
      downloadSources = true,
    },
    maven = {
      downloadSources = true,
      updateSnapshots = true,
    },
    completion = {
      favoriteStaticMembers = {
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.assertj.core.api.Assertions.*',
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.Assert.*',
        'org.junit.Assume.*',
        'org.junit.jupiter.api.Assertions.*',
        'org.junit.jupiter.api.Assumptions.*',
        'org.junit.jupiter.api.DynamicContainer.*',
        'org.junit.jupiter.api.DynamicTest.*',
        'org.mockito.Mockito.*',
        'org.mockito.ArgumentMatchers.*',
        'org.mockito.Answers.*',
      },
      importOrder = {
        '#',
        'java',
        'javax',
        'org',
        'com',
      },
      overwrite = false,
      guessMethodArguments = true,

      -- completionItem = {
      --   documentationFormat = { "markdown", "plaintext" },
      --   snippetSupport = true,
      --   preselectSupport = true,
      --   insertReplaceSupport = true,
      --   labelDetailsSupport = true,
      --   deprecatedSupport = true,
      --   commitCharactersSupport = true,
      --   tagSupport = { valueSet = { 1 } },
      --   resolveSupport = {
      --     properties = {
      --       "documentation",
      --       "detail",
      --       "additionalTextEdits",
      --     },
      --   },
      -- }
    },
    contentProvider = { preferred = 'fernflower' },
    extendedClientCapabilities = require('jdtls').extendedClientCapabilities,
    flags = {
      allow_incremental_sync = true,
      server_side_fuzzy_completion = true,
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      generateComments = true,
      useBlocks = true,
      hashCodeEquals = {
        userIntanceOf = true,
      },
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        codeStyle = 'STRING_BUILDER_CHAINED',
      },
    },
    implementationsCodeLens = { enabled = true },
    referencesCodeLens = { enabled = true },
    references = { includeDecompiledSources = true },
    -- inlayHints = {
    --   parameterNames = {
    --     enabled = "all", -- literals | none | all (all = "literals" + extras)
    --     -- subtleties = {
    --     --   showForComplexExpressions = true  -- Mostra também para expressões complexas
    --     -- }
    --   },
    -- },

    -- runtimes = {
    --   {
    --     name = "JavaSE-23",
    --     path = "/usr/lib/jvm/java-23-openjdk/",
    --   },
    -- },
    --NOTE: experimental
    configuration = {
      ---@type 'disabled' | 'interactive' | 'automatic'
      updateBuildConfiguration = 'interactive',
    },
    format = {
      settings = {
        url = vim.fn.stdpath('config') .. '/rules/eclipse-java-google-style.xml',
        profile = 'GoogleStyle',
      },
    },
    on_attach = function()
      --   -- -- User customizations
      --   -- pcall(vim.lsp.codelens.refresh)
      --
      Util.enable_debugger(opts)
    end,
    -- signatureHelp = { enabled = true },
  }, opts.jdtls)
  -- Existing server will be reused if the root_dir matches.
end

return M
