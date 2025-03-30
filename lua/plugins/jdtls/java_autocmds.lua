local M = {}
local util = require("plugins.jdtls.java_util")
local java_filetypes = { "java" }

local function create_attach_autocmd(attach_fn)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = java_filetypes,
    callback = function(args)
      attach_fn(args.buf)
    end,
    desc = "[JDTLS] Attach language server"
  })
end

-- local function create_codelens_autocmd()
--   vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = java_filetypes,
--     callback = function() pcall(vim.lsp.codelens.refresh) end,
--     desc = "[JDTLS] Refresh code lenses"
--   })
-- end

local function create_lsp_attach_autocmd(opts)
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "[JDTLS] Setup keymaps and DAP",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      -- local bufnr = args.buf

      if client and client.name == "jdtls" then
        -- Keymaps
        -- local keymaps = require("plugins.jdtls.java_keymaps")
        -- keymaps.setup_jdtls(bufnr)

        -- DAP configuration
        if opts.dap and util.has_plugin("nvim-dap") and util.mason_registry.is_installed("java-debug-adapter") then
          require("jdtls").setup_dap(opts.dap)
          require("jdtls.dap").setup_dap_main_class_configs()

          -- if opts.test and util.mason_registry.is_installed("java-test") then
          --   keymaps.setup_dap(bufnr)
          -- end
        end

        -- User customizations
        pcall(vim.lsp.codelens.refresh)
        if opts.on_attach then
          opts.on_attach(args)
        end
      end
    end
  })
end

function M.setup(opts, attach_jdtls)
  create_attach_autocmd(attach_jdtls)
  -- create_codelens_autocmd()
  create_lsp_attach_autocmd(opts)
end

return M
