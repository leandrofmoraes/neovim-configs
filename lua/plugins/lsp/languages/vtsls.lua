-- VTSLS
local M = {}

local generate_ts_mappings = function()
  return {
    source_actions = "<Cmd>VtsExec source_actions<CR>",
    rename_file = "<Cmd>VtsExec rename_file<CR>",
    organize_imports = "<Cmd>VtsExec organize_imports<CR>",
    add_missing_imports = "<Cmd>VtsExec add_missing_imports<CR>",
    sort_imports = "<Cmd>VtsExec sort_imports<CR>",
    go_to_source_definition = "<Cmd>VtsExec go_to_source_definition<CR>",
    go_to_project_config = "<Cmd>goto_project_config<CR>",
    remove_unused_imports = "<Cmd>VtsExec remove_unused_imports<CR>",
    remove_unused = "<Cmd>VtsExec remove_unused<CR>",
    file_references = "<Cmd>file_references<CR>",
    fix_all = "<Cmd>VtsExec fix_all<CR>",
  }
end

M.vtsls = {
  settings = {
    -- typescript = lang_settings,
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
    javascript = {
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        variableTypes = { enabled = true },
      },
    },
    complete_function_calls = true,
    vtsls = {
      -- Automatically use workspace version of TypeScript lib on startup.
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        -- Inlay hint truncation.
        maxInlayHintLength = 30,
        -- For completion performance.
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
  },
  on_attach = function(_, bufnr)

      local ts_mappings = generate_ts_mappings()
      local map = vim.keymap.set

      map(
        "n",
        "<leader>cA",
        ts_mappings.source_actions,
        { buffer = bufnr, desc = "Source Actions" }
      )
      map(
        "n",
        "<leader>cF",
        ts_mappings.fix_all,
        { buffer = bufnr, desc = "Fix All" }
      )
      map(
        "n",
        "<leader>cf",
        ts_mappings.rename_file,
        { buffer = bufnr, desc = "Rename File" }
      )
      -- map(
      --   "n",
      --   "<leader>cr",
      --   ts_mappings.file_references,
      --   { buffer = bufnr, desc = "File References" }
      -- )
      map(
        "n",
        "<leader>ci",
        ts_mappings.add_missing_imports,
        { buffer = bufnr, desc = "Add Missing Imports" }
      )
      map(
        "n",
        "<leader>co",
        ts_mappings.organize_imports,
        { buffer = bufnr, desc = "Organize Imports" }
      )
      map(
        "n",
        "<leader>cS",
        ts_mappings.sort_imports,
        { buffer = bufnr, desc = "Sort Imports" }
      )
      map(
        "n",
        "<leader>cu",
        ts_mappings.remove_unused_imports,
        { buffer = bufnr, desc = "Remove Unused Imports" }
      )
      map(
        "n",
        "<leader>cU",
        ts_mappings.remove_unused,
        { buffer = bufnr, desc = "Remove All Unused Code" }
      )
      map(
        "n",
        ";gc",
        ts_mappings.go_to_project_config,
        { buffer = bufnr, desc = "Go To Project Config" }
      )
      map(
        "n",
        ";gs",
        ts_mappings.go_to_source_definition,
        { buffer = bufnr, desc = "Go To Source Definition" }
      )
    -- Mapeamentos personalizados
    --       local map = function(mode, lhs, rhs, desc)
    --         vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    --       end
    --
    -- Bloco de setup para configurar comandos personalizados e ajustar settings
    -- setup = function(_, opts)
    --   -- Supondo que o LSP já esteja conectado, você pode acessar o cliente ativo.
    --   local clients = vim.lsp.get_active_clients()
    --   for _, client in ipairs(clients) do
    --     if client.name == "vtsls" then
    --       client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
    --         local action, uri, range = unpack(command.arguments)
    --         local function move(newf)
    --           client.request("workspace/executeCommand", {
    --             command = command.command,
    --             arguments = { action, uri, range, newf },
    --           })
    --         end
    --
    --         local fname = vim.uri_to_fname(uri)
    --         client.request("workspace/executeCommand", {
    --           command = "typescript.tsserverRequest",
    --           arguments = {
    --             "getMoveToRefactoringFileSuggestions",
    --             {
    --               file = fname,
    --               startLine = range.start.line + 1,
    --               startOffset = range.start.character + 1,
    --               endLine = range["end"].line + 1,
    --               endOffset = range["end"].character + 1,
    --             },
    --           },
    --         }, function(_, result)
    --           local files = result.body.files
    --           table.insert(files, 1, "Enter new path...")
    --           vim.ui.select(files, {
    --             prompt = "Select move destination:",
    --             format_item = function(f)
    --               return vim.fn.fnamemodify(f, ":~:.")
    --             end,
    --           }, function(f)
    --             if f and f:find("^Enter new path") then
    --               vim.ui.input({
    --                 prompt = "Enter move destination:",
    --                 default = vim.fn.fnamemodify(fname, ":h") .. "/",
    --                 completion = "file",
    --               }, function(newf)
    --                 if newf then move(newf) end
    --               end)
    --             elseif f then
    --               move(f)
    --             end
    --           end)
    --         end)
    --       end
    --     end
    --   end
    --   -- Caso a seção de settings do JavaScript não esteja definida, copie a de typescript
    --   opts.settings.javascript = vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
  end,
}
--   ft = {
--     "javascript",
--     "javascriptreact",
--     "typescript",
--     "typescriptreact",
--   },
--   -- enabled = not env.NVIM_USER_USE_TSSERVER,
return M
