local M = {}
local map = vim.keymap.set
local term_util = require("plugins.toggleterm.toggleterm_util")


function M.term_exec(client, buf)
  if client.name == "clangd" then
    map("n", "<leader>cZ", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = buf, desc = "Switch Source/Header (C/C++)" })
  elseif client.name == "tsserver" or client.name == "vtsls" then
    -- map("n", "<leader>co", "<cmd>lua _ORGANIZE_TS_IMPORTS()<cr>", { buffer = buf, desc = "Organize Imports" })
    -- map("n", "<leader>cR", "<cmd>lua _REMOVE_UNUSED()<cr>", { buffer = buf, desc = "Remove Unused Imports" })
    map("n", "<leader>cZ", function() term_util.node_toggle() end, { buffer = buf, desc = "Node" })
  elseif client.name == "bashls" then
    map("n", "<leader>cZ", function() term_util.float_term() end, { buffer = buf, desc = "Shell" })
  elseif client.name == "jdtls" then
    map("n", "<leader>cZ", function() term_util.java_toggle() end, { buffer = buf, desc = "JShell" })
  elseif client.name == "lua_ls" then
    map("n", "<leader>cZ", function() term_util.lua_toggle() end, { buffer = buf, desc = "Interactive Lua" })
    -- elseif client.name == "markdownlint" or client.name == "marksman" then
    --   map("n", "<leader>cZ", "<cmd>MarkdownPreviewToggle<cr>", { buffer = buf, desc = "Markdown Preview" })
    -- elseif client.name == "html" then
    --   map("n", "<leader>cl", "<cmd>lua _liveServerToggle()<cr>", { buffer = buf, desc = "Toggle Live Server" })
    --   map("n", "<leader>cr", "<cmd>LiveServerStart<cr>", { buffer = buf, desc = "Start Live Server" })
    --   map("n", "<leader>cs", "<cmd>LiveServerStop<cr>", { buffer = buf, desc = "Stop Live Server" })
  end


  if client.name == "clangd" or
      client.name == "jdtls" or
      client.name == "vtsls" or
      client.name == "bashls" or
      client.name == "lua_ls" or
      client.name == "marksman" or
      client.name == "html" then
    map("n", "<leader>cR", function() term_util.run_code() end, { buffer = buf, desc = "Run Code" })
  end
end

return M
