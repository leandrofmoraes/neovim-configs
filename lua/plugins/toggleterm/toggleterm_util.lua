local M = {}
local ok, Terminal = pcall(require, "toggleterm.terminal")
-- local Terminal = require('toggleterm.terminal').Terminal
if not ok then
  return
end

Terminal = Terminal.Terminal
-- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

-- local run = Terminal:new {
-- dir = "%:p:h",
-- hidden = true,
-- direction = "float",
-- on_open = function(_)
--   vim.cmd("startinsert!")
--   vim.fn.feedkeys("i")
--   vim.cmd("redraw!")
--   -- vim.cmd(":ToggleTermExec node %")
--   vim.cmd('TermExec cmd="node %"')
-- end,
-- }

function M.run_code()
  -- run:toggle()
  -- vim.fn.feedkeys("i")
  local filetype = vim.bo.filetype
  local horizontal_dir = 'direction="horizontal" go_back=0'
  if filetype == 'javascript' then
    -- vim.cmd('TermExec cmd="node %"') -- horizontal term
    vim.cmd('TermExec cmd="node %" ' .. horizontal_dir)
  elseif filetype == 'python' then
    -- vim.cmd('TermExec cmd="python %"')
    vim.cmd('TermExec cmd="python %" ' .. horizontal_dir)
  elseif filetype == 'c' then
    -- vim.cmd('TermExec cmd="javac % && java %<"')
    vim.cmd('TermExec cmd="gcc *.c -o %<.out && ./%<.out" ' .. horizontal_dir)
  elseif filetype == 'cpp' then
    -- vim.cmd('TermExec cmd="javac % && java %<"')
    vim.cmd('TermExec cmd="g++ *.cpp -o %< && ./%<" ' .. horizontal_dir)
  elseif filetype == 'java' then
    -- vim.cmd('TermExec cmd="javac % && java %<"')
    vim.cmd('TermExec cmd="javac % && java %<" ' .. horizontal_dir)
    -- vim.cmd('TermExec cmd="javac -cp .:*.jar % && java -cp .:*.jar %<" direction="horizontal" go_back=0 || TermExec cmd="javac % && java %<" direction="horizontal" go_back=0')
  elseif filetype == 'sh' then
    -- vim.cmd('TermExec cmd="bash %"')
    vim.cmd('TermExec cmd="bash %" ' .. horizontal_dir)
  elseif filetype == 'lua' then
    vim.cmd('TermExec cmd="lua %" ' .. horizontal_dir)
  elseif filetype == 'html' then
    -- vim.cmd('TermExec cmd="bash %"')
    -- vim.cmd('TermExec cmd="google-chrome-stable % && exit" direction="horizontal"')
    vim.cmd('LiveServer start')
  end
  -- vim.cmd("startinsert!")
end

function M.htop_toggle()
  Terminal:new({
    cmd = 'htop',
    display_name = ' Htop',
    hidden = true,
  }):toggle(30)
end

local function interactive_float_term(name, cmd)
  return {
    dir = '%:p:h',
    cmd = cmd,
    hidden = true,
    display_name = name,
    direction = 'float',
    border = 'curved',
  }
end

function M.lazygit_toggle()
  Terminal:new({
    interactive_float_term('LazyGit', 'lazygit'),
    on_open = function(_)
      vim.cmd('startinsert!')
    end,
    on_close = function(_) end,
    count = 99,
  }):toggle()
end

-- local node = Terminal:new({
--   interactive_float_term('node'),
-- })

function M.node_toggle()
  -- node:toggle()
  Terminal:new(interactive_float_term(' Node', 'node')):toggle()
end

function M.python_toggle()
  Terminal:new(interactive_float_term('󰌠 Python', 'python')):toggle()
end

-- local lua = Terminal:new({
--   dir = '%:p:h',
--   cmd = 'lua',
--   hidden = true,
--   direction = 'float',
--   border = 'curved',
-- })

function M.lua_toggle()
  Terminal:new(interactive_float_term('󰢱 Lua', 'lua')):toggle()
end

function M.java_toggle()
  -- java:toggle()
  Terminal:new(interactive_float_term('󰬷 JShell', 'jshell')):toggle()
end

-- local cargo_run = Terminal:new({
--   dir = '%:p:h',
--   cmd = 'cargo run',
--   hidden = true,
--   direction = 'float',
--   border = 'curved',
-- })

function M.cargo_run()
  -- cargo_run:toggle()
  Terminal:new(interactive_float_term('󱘗 Cargo', 'cargo run')):toggle()
end

local float_term = Terminal:new({
  direction = 'float',
  border = 'curved',
  -- shell = "/usr/bin/zsh",
  display_name = 'Shell',
  on_open = function(term)
    vim.cmd('startinsert!')
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      'n',
      '<m-1>',
      '<cmd>ToggleTerm dir=%:p:h direction=float<cr>',
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      't',
      '<m-1>',
      '<cmd>ToggleTerm dir=%:p:h direction=float<cr>',
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      'i',
      '<m-1>',
      '<cmd>ToggleTerm dir=%:p:h direction=float<cr>',
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(term.bufnr, '', '<m-2>', '<nop>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(term.bufnr, '', '<m-3>', '<nop>', { noremap = true, silent = true })
  end,
  count = 1,
})

function M.float_term()
  float_term:toggle()
end

-- TYPESCRIPT FUNCTIONS
-- function _ORGANIZE_TS_IMPORTS()
--   vim.lsp.buf.code_action({
--     apply = true,
--     context = {
--       only = { "source.organizeImports.ts" },
--       diagnostics = {},
--     },
--   })
-- end
--
-- function _REMOVE_UNUSED()
--   vim.lsp.buf.code_action({
--     apply = true,
--     context = {
--       only = { "source.removeUnused.ts" },
--       diagnostics = {},
--     },
--   })
-- end

-- vim.api.nvim_set_keymap("n", "<m-1>", "<cmd>lua _FLOAT_TERM()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<m-1>", "<cmd>lua _FLOAT_TERM()<CR>", { noremap = true, silent = true })

-- local vertical_term = Terminal:new {
--   direction = "vertical",
--   on_open = function(term)
--     vim.cmd "startinsert!"
--     vim.api.nvim_buf_set_keymap(
--       term.bufnr,
--       "n",
--       "<m-2>",
--       "<cmd>2ToggleTerm size=60 direction=vertical<cr>",
--       { noremap = true, silent = true }
--     )
--     vim.api.nvim_buf_set_keymap(
--       term.bufnr,
--       "t",
--       "<m-2>",
--       "<cmd>2ToggleTerm size=60 direction=vertical<cr>",
--       { noremap = true, silent = true }
--     )
--     vim.api.nvim_buf_set_keymap(
--       term.bufnr,
--       "i",
--       "<m-2>",
--       "<cmd>2ToggleTerm size=60 direction=vertical<cr>",
--       { noremap = true, silent = true }
--     )
--     vim.api.nvim_buf_set_keymap(term.bufnr, "", "<m-3>", "<nop>", { noremap = true, silent = true })
--   end,
--   count = 2,
-- }

-- function _VERTICAL_TERM()
--   vertical_term:toggle(60)
-- end

-- vim.api.nvim_set_keymap("n", "<m-2>", "<cmd>lua _VERTICAL_TERM()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<m-2>", "<cmd>lua _VERTICAL_TERM()<CR>", { noremap = true, silent = true })

function M.horizontal_term()
  Terminal:new {
    direction = "horizontal",
    on_open = function(term)
      vim.cmd "startinsert!"
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "n",
        "<m-3>",
        "<cmd>3ToggleTerm size=10 direction=horizontal<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "t",
        "<m-3>",
        "<cmd>3ToggleTerm size=10 direction=horizontal<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "i",
        "<m-3>",
        "<cmd>3ToggleTerm size=10 direction=horizontal<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(term.bufnr, "", "<m-2>", "<nop>", { noremap = true, silent = true })
    end,
    count = 3,
  }:toggle(10)
end

-- vim.api.nvim_set_keymap("n", "<m-3>", "<cmd>lua _HORIZONTAL_TERM()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<m-3>", "<cmd>lua _HORIZONTAL_TERM()<CR>", { noremap = true, silent = true })

-- for k, v in pairs(options) do
--   lvim.builtin.terminal[k] = v
-- end

return M
