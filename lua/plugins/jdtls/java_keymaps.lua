local M = {}

local map = vim.keymap.set
function M.jdtls_keymaps(bufnr)
  -- { ";gS", require("jdtls").goto_subjects, desc = "Go to Subjects" },
  map('n',
    "<leader>cxm", require('jdtls').extract_method,
    { buffer = bufnr, desc = "Extract Method" }
  )
  map('n',
    "<leader>cxv", require("jdtls").extract_variable_all,
    { buffer = bufnr, desc = "Extract Variable" }
  )
  map('n',
    "<leader>cxc", require("jdtls").extract_constant,
    { buffer = bufnr, desc = "Extract Constant" }
  )

  map('n',
    ";gs", require("jdtls").super_implementation,
    { buffer = bufnr, desc = "Go to Super" }
  )

  map('n',
    "<leader>co", require("jdtls").organize_imports,
    { buffer = bufnr, desc = "Organize Imports" }
  )
  --   map( 'n',
  --     "<leader>ci",
  --     function() require("jdtls").implement_methods() end,
  --     { buffer = bufnr, desc = "Implement Methods" }
  --   )
  --   map( 'n',
  --     "<leader>cc",
  --     function() require("jdtls").create_constructor() end,
  --     { buffer = bufnr, desc = "Create Constructor" }
  --   )
  --   map( 'n',
  --     "<leader>cf",
  --     function() require("jdtls").create_field() end,
  --     { buffer = bufnr, desc = "Create Field" }
  --   )
  --   map( 'n',
  --     "<leader>cG",
  --     function() require("jdtls").generate_getters_and_setters() end,
  --     { buffer = bufnr, desc = "Generate Getters and Setters" }
  --   )
  --   map( 'n',
  --     "<leader>ch",
  --     function() require("jdtls").create_hashcode_and_equals() end,
  --     { buffer = bufnr, desc = "Create Hashcode and Equals" }
  --   )
  --   map( 'n',
  --     "<leader>ct",
  --     function() require("jdtls").create_tostring() end,
  --     { buffer = bufnr, desc = "Create ToString" }
  --   )
  --   map( 'n',
  --     "<leader>cd",
  --     function() require("jdtls").create_delegate_methods() end,
  --     { buffer = bufnr, desc = "Create Delegate Methods" }
  --   )
  --   map( 'n',
  --     "<leader>cs",
  --     function() require("jdtls").create_setter() end,
  --     { buffer = bufnr, desc = "Create Setter" }
  --   )
  --   map( 'n',
  --     "<leader>cg",
  --     require("jdtls").create_getter,
  --     { buffer = bufnr, desc = "Create Getter" }
  --   )
  --   map( 'n',
  --     "<leader>cI",
  --     function() require("jdtls").create_interface() end,
  --     { buffer = bufnr, desc = "Create Interface" }
  --   )
  --   map( 'n',
  --     "<leader>cC",
  --     function() require("jdtls").create_class() end,
  --     { buffer = bufnr, desc = "Create Class" }
  --   )
  --   map( 'n',
  --     "<leader>cE",
  --     function() require("jdtls").create_enum() end,
  --     { buffer = bufnr, desc = "Create Enum" }
  --   )
  -- -- Abrir jshell (terminal interativo)
  --   map("n", "<leader>js", function() require("jdtls").jshell() end,
  --     { buffer = bufnr, desc = "Open JShell" }
  --   )
  -- wk.register({
  --   ["<leader>c"] = { "+code" },
  --   ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Actions" },
  --   ['<leader>cA'] = {
  --     function()
  --       return require('actions-preview').code_actions()
  --     end,
  --     "Action Preview"
  --   },
  -- })
end

function M.dap_keymaps(opts)
  map('n',
    "<leader>Tt",
    function()
      require("jdtls.dap").test_class({
        config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
      })
    end,
    { desc = "Run All Test",
    })
  map('n',
    "<leader>Tr",
    function()
      require("jdtls.dap").test_nearest_method({
        config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
      })
    end,
    { desc = "Run Nearest Test",
    })
  map('n', "<leader>TT", require("jdtls.dap").pick_test, { desc = "Run Test" })
end

return M
