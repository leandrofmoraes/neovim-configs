local map = vim.keymap.set

local finder = require('utils.finder_functions')
local Snacks = require("snacks")

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir
-- vim.cmd("command! -nargs=+ -complete=file Grep noautocmd grep! <args> | redraw! | copen")
-- vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")

------------------------------------------------------
---- Which Key Mappings ----
------------------------------------------------------

-- delete default mappings
-- vim.keymap.del("n", "gx")

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
-- function M.safe_keymap_set(mode, lhs, rhs, opts)
--   local keys = require("lazy.core.handler").handlers.keys
--   ---@cast keys LazyKeysHandler
--   local modes = type(mode) == "string" and { mode } or mode
--
--   ---@param m string
--   modes = vim.tbl_filter(function(m)
--     return not (keys.have and keys:have(lhs, m))
--   end, modes)
--
--   -- do not create the keymap if a lazy keys handler exists
--   if #modes > 0 then
--     opts = opts or {}
--     opts.silent = opts.silent ~= false
--     if opts.remap and not vim.g.vscode then
--       ---@diagnostic disable-next-line: no-unknown
--       opts.remap = nil
--     end
--     vim.keymap.set(modes, lhs, rhs, opts)
--   end
-- end

------------------------------------------------------
--for no groups
------------------------------------------------------
-- wk.add({
-- mode = { 'n', 'v' },
-- { "<leader>;", "<cmd>Alpha<CR>", desc = "Dashboard" },
-- { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
-- { "<leader>/", require("Comment.api").toggle.linewise.current, desc = "Comment current line" },
-- ["<leader>l"] = {
--   name = "lsp",
--   i = { "<cmd>LspInfo<cr>", "Info" },
--   I = { "<cmd>Mason<cr>", "Mason Info" },
-- },
-- })

------------------------------------------------------
---- Mappings with "vim.keymap.set"
------------------------------------------------------
-- Smart delete
map("n", "dd", function()
  local current_line = vim.api.nvim_get_current_line()
  if current_line:match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true, desc = "Only yank text with dd from non-empty lines" })

-- Desabilita a tecla espaço (já que ela é usada como líder)
-- Disable space since I'm using it as my leader key
-- map({ 'n', 'v' }, '<Space>', '<Nop>', { expr = true, silent = true })
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Move selected lines up/down in visual mode
map("x", "K", ":move '<-2<CR>gv=gv", {})
map("x", "J", ":move '>+1<CR>gv=gv", {})

-- Map <leader>o & <leader>O to newline without insert mode
map("n", "go",
  [[:<C-u>call append(line("."), repeat([""], v:count1))<CR>]],
  { silent = true, desc = "newline below (no insert-mode)" })
map("n", "gO",
  [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]],
  { silent = true, desc = "newline above (no insert-mode)" })

-- map("n", "gx", "<cmd>!xdg-open <C-R>=expand('<cfile>')<CR><CR>", { desc = "Open URI" })
-- map( 'n', "gx", "<Cmd>call netrw#BrowseX(expand('<cfile>'), 0)<CR>", {desc = "Open File/URI"})
------------------------------------------------------
-- Session Mappings
------------------------------------------------------
-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- quit
map("n", "<leader>fQ", "<cmd>qa!<cr>", { desc = "Quit without saving" })

-- Quit neovim
map('n', '<leader>fq', '<cmd>qa<CR>', { desc = 'Quit' })

-- Quick write
map('n', '<leader>fs', '<cmd>w<CR>', { desc = 'Save' })
map('n', '<leader>fS', '<cmd>wa<CR>', { desc = 'Save all' })

map('n', '<leader>fx', '<cmd>xall<CR>', { desc = 'Save and Quit' })

-- save file with Crtl+s
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Git/Github tools
map('n', "<leader>Gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map('n', "<leader>Gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
map('n', "<leader>Gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
map('n', "<leader>GL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
map('n', "<leader>Gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
map('n', "<leader>GS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
map('n', "<leader>Gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
map('n', "<leader>Gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
map({ "n", "v" }, "<leader>GB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })

map('n', ';Gs', finder.git_status, { desc = 'git status' })
map('n', ';Gb', finder.git_branches, { desc = 'git branches' })
map('n', ';Gc', finder.git_commits, { desc = 'git commits' })
map('n', ';GS', finder.git_stash, { desc = 'git stash' })

------------------------------------------------------
-- Lazy keymap (Plugin Manager)
------------------------------------------------------
map('n', '<leader>P', '<cmd>Lazy<CR>', { desc = 'Plugins' })
map('n', '<leader>Pi', '<cmd>Lazy install<cr>', { desc = "Install" })
map('n', '<leader>Ps', '<cmd>Lazy sync<cr>', { desc = "Sync" })
map('n', '<leader>PS', '<cmd>Lazy clear<cr>', { desc = "Status" })
map('n', '<leader>Pc', '<cmd>Lazy clean<cr>', { desc = "Clean" })
map('n', '<leader>Pu', '<cmd>Lazy update<cr>', { desc = "Update" })
map('n', '<leader>Pp', '<cmd>Lazy profile<cr>', { desc = "Profile" })
map('n', '<leader>Pl', '<cmd>Lazy log<cr>', { desc = "Log" })
map('n', '<leader>Pd', '<cmd>Lazy debug<cr>', { desc = "Debug" })


------------------------------------------------------
-- nvim-highlight-colors
------------------------------------------------------
-- wk.add({ "<leader>h", group = "Highlight Colors", icon = {icon = icons.kind.Color, color = "orange" }})
-- map( 'n', "<leader>hh", function() require("nvim-highlight-colors").turnOn() end,     { desc = "Turn On" })
-- map( 'n', "<leader>hH", function() require("nvim-highlight-colors").turnOff() end,    { desc = "Turn Off" })
-- map( 'n', "<leader>h", function() require("nvim-highlight-colors").toggle() end,     { desc = "Toggle" })
-- map( 'n', "<leader>Ha", function() require("nvim-highlight-colors").is_active() end,  { desc = "Is active" })

-- -- Better indenting
-- map('v', '<', '<gv')
-- map('v', '>', '>gv')
--
-- -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
-- map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
-- map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
-- map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Previous search result' })
-- map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Previous search result' })
-- map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Previous search result' })

-- map('n', '<leader>z', function() Snacks.zen() end, { desc = 'Zen Mode' })
-- map('n', '<leader>zz', function() Snacks.zen.zen() end, { desc = 'Zen' })
-- map('n', '<leader>zZ', function() Snacks.zen.zoom() end, { desc = 'Zoom' })

-- map('n', '<leader>D', function() Snacks.dim() end, { desc = 'dim' })
-- map('n', '<leader>Dd', function() Snacks.dim.enable() end, { desc = 'Enable' })
-- map('n', '<leader>DD', function() Snacks.dim.disable() end, { desc = 'Disable' })

------------------------------------------------------
-- NeoTree file explorer (requires 'nvim-neo-tree/neo-tree.nvim')
------------------------------------------------------
map('n', ';e', '<cmd>Neotree toggle<CR>', { desc = 'NeoTree Explorer' })
map('n', '<leader>e', function() Snacks.explorer(require("plugins.snacks.explorer")) end, { desc = 'Explorer' })

-- telescope requires 'nvim-telescope/telescope.nvim',

map('n', ';/', finder.find_in_curr_buffer, { desc = 'Search' })
-- File Browser
map('n', ';.', finder.file_browser, { desc = 'File Browser' })

map('n', ';P', "<Cmd>Telescope projects<CR>", { desc = "Projects" })
map('n', ';T', finder.resume_telescope, { desc = 'Resume Telescope' })
-- Pesquisa
-- map( 'n', ';fb',         finder.picker_file_browser,          { desc = 'Files Browse' })
map('n', ';fc', finder.commands, { desc = 'Commands' })
map('n', ';fC', finder.command_history, { desc = 'Command history' })
-- map( 'n', ';ff',         function() finder.find_files("telescope") end, { desc = 'Files' })
map('n', ';ff', function() Snacks.picker.files() end, { desc = 'Files' })
map('n', ';fg', finder.find_in_curr_workspace, { desc = 'Files (respects .gitignore)' })
-- map( 'n', ';fh',         finder.help_tags,                    { desc = 'Search Help tags' })
map('n', ';fh', function() Snacks.picker.help() end, { desc = 'Search Help tags' })
map('n', ';fi', function() Snacks.picker.icons() end, { desc = 'Icons' })
map('n', ';fk', finder.list_keymaps, { desc = 'Keymaps' })
map('n', ';fm', finder.man_pages, { desc = 'Man pages' })
map('n', ';fn', function() Snacks.picker.notifications() end, { desc = 'Notifications' })
map('n', ';fo', finder.recent_files, { desc = 'Recently opened' })
map('n', ';fR', finder.registers, { desc = 'Registers' })
map('n', ';fs', finder.lsp_document_symbols, { desc = 'LSP Document symbols' })
map('n', ';fu', '<cmd>Telescope undo<cr>', { desc = 'Undo History' })
map('n', ';fw', finder.live_grep, { desc = 'Words' })
-- Listar mapeamentos e símbolos
map('n', ";S", finder.list_ts_symbols, { desc = "Treesitter symbols" })

-- search/replace in multiple files
map(
  { "n", "v" },
  ";fr",
  function()
    local grug = require("grug-far")
    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
    grug.open({
      transient = true,
      prefills = {
        filesFilter = ext and ext ~= "" and "*." .. ext or nil,
      },
    })
  end,
  { desc = "Search and Replace" }
)
-- Todo-comments
-- map( 'n', ";ft", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
map('n', ";ft", function() require("todo-comments.fzf").todo() end, { desc = "Todo" })
-- map( 'n', ";fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme" })
map('n', ";fT", function() require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end,
  { desc = "Todo/Fix/Fixme" })

------------------------------------------------------
-- Buffer keymaps
------------------------------------------------------

-- Other buffer keymaps are defined in the plugins/bufferline
map('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<cmd>BufferLineMoveNext<CR>', { desc = 'Move current buffer forwards' })
map('n', '<S-h>', '<cmd>BufferLineMovePrev<CR>', { desc = 'Move current buffer backwards' })

-- map( 'n', ';;',              function() finder.buffers_list("telescope") end,      { desc = 'Buffers List' })
map('n', ';;', function() Snacks.picker.buffers() end, { desc = 'Buffers List' })
map('n', ';x', function() Snacks.bufdelete() end, { desc = 'Buffer Close' })

map('n', ';<Tab>x', function() Snacks.bufdelete() end, { desc = 'Close' })
map('n', ';<Tab>X', function() Snacks.bufdelete({ force = true }) end, { desc = 'Close forcefully' })
map('n', ';<Tab>b', '<cmd>e #<CR>', { desc = 'Switch to other buffer' })
map('n', ';<Tab><Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next' })
map('n', ';<Tab><S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous' })
map('n', ';<Tab>L', '<cmd>BufferLineMoveNext<CR>', { desc = 'Move forwards' })
map('n', ';<Tab>H', '<cmd>BufferLineMovePrev<CR>', { desc = 'Move backwards' })

map('n', ';<Tab>B', function() require('bufferline').move_to(1) end, { desc = 'Move to beginning' })
map('n', ';<Tab>E', function() require('bufferline').move_to(-1) end, { desc = 'Move to end' })

for i = 1, 9 do
  map('n', ';<Tab>' .. i, function() require('bufferline').go_to(i) end, { desc = 'Jump to buffer ' .. i })
end

map('n', ';<Tab>$', function() require('bufferline').go_to(-1) end, { desc = 'Jump to last buffer' })

------------------------------------------------------
---- windows control ----
------------------------------------------------------

-- map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wc", "<C-W>c", { desc = "Close Window", remap = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Inserts ',', '.', ';' with undo points (<c-g>u) for granular undo
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Open Word documentation/manual under cursor (native K command)
map("n", ";k", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
-- map("v", "<", "<gv")
-- map("v", ">", ">gv")

-- commenting
-- map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
-- map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- select all with Crtl+a
map('n', '<C-a>', 'ggVG', { desc = 'Select all' })
map('n', 'ga', 'ggVG', { desc = 'Select all' })

-- Fix indenting
local indent_all = function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('silent! keepjumps normal! gg=G')
  vim.api.nvim_win_set_cursor(0, pos)
end

map('n', 'g=', indent_all, { desc = 'Indent all' })
map('n', '<C-=>', indent_all, { desc = 'Indent all' })



-- Refactoring
-- wk.add({ mode = { 'n', 'v' }, { "gr", group = "Refactoring", icon = { icon = icons.kind.Reference, color = "orange" }}})
-- map( 'x', 'gre', function() require('refactoring').refactor('Extract Function') end,         { desc = 'Extract' })
-- map( 'x', 'grE', function() require('refactoring').refactor('Extract Function To File') end, { desc = 'Extract to File' })
-- map( 'x', 'grv', function() require('refactoring').refactor('Extract Variable') end,         { desc = 'Extract var' })
-- map( 'n', 'grf', function() require('refactoring').refactor('Inline Function') end,          { desc = 'Inline var' })
-- map( 'n', 'gri', function() require('refactoring').refactor('Inline Variable') end,          { desc = 'Inline func' })
-- map( 'n', 'grb', function() require('refactoring').refactor('Extract Block') end,            { desc = 'Extract Block' })
-- map( 'n', 'grB', function() require('refactoring').refactor('Extract Block To File') end,    { desc = 'Extract block to file' })
-- Extract block supports only normal mode

-- formatting
-- map({ "n", "v" }, "<leader>cf", function()
--   LazyVim.format({ force = true })
-- end, { desc = "Format" })

map("x", "grk", ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>", { desc = "Capture group (\\1)" })
map("n", "grk", ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>", { desc = "Line capture (\\1)" })
map("v", "gre", '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>', { desc = "Replace selection (confirm)" })
map("n", "gre", ":%s/<C-r><C-w>/<C-r><C-w>/gcI<Left><Left><Left><Left>", { desc = "Replace word (ci)" })
------------------------------------------------------
-- diagnostics and quickfix
------------------------------------------------------

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

map('n', "<leader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map('n', "<leader>dn", diagnostic_goto(true), { desc = "Next Diagnostic" })
map('n', "<leader>dp", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map('n', "<leader>de", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map('n', "<leader>dE", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map('n', "<leader>dw", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map('n', "<leader>dW", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

map('n', '<leader>dD', finder.lsp_document_diagnostics, { desc = 'LSP Document diagnostics' })
map('n', '<leader>dK', finder.lsp_workspace_diagnostics, { desc = 'LSP Workspace diagnostics' })
map('n', '<leader>dp', finder.document_diagnostics, { desc = 'Telescope document diagnostics' })
map('n', '<leader>dk', finder.workspace_diagnostics, { desc = 'Workspace diagnostics' })

map("n", "<leader>dl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>dq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
-- map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- todo-comments
map('n', "]t", function() require("todo-comments").jump_next() end, { desc = "Next Todo Comment" })
map('n', "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous Todo Comment" })
map('n', "<leader>dt", "<cmd>Trouble todo toggle<cr>", { desc = "Todo (Trouble)" })
map('n', "<leader>dT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
  { desc = "Todo/Fix/Fixme (Trouble)" })


------------------------------------------------------
-- Highlightning
------------------------------------------------------

-- highlights under cursor
-- map("n", "gui",   vim.show_pos,                 { desc = "Inspect Pos" })
-- map("n", "guI",   "<cmd>InspectTree<cr>",       { desc = "Inspect Tree" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map("n", "<leader>r",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Clear & Refresh" }
)

------------------------------------------------------
-- Misc
------------------------------------------------------
-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- tabs
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

------------------------------------------------------
-- Terminal Mappings
------------------------------------------------------
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

local terminal = require("plugins.toggleterm.toggleterm_util")
map('n', "<leader>$", function() terminal.horizontal_term() end, { desc = "Terminal" })
map('n', "<leader>!", function() terminal.htop_toggle() end, { desc = "Htop" })

-- wk.add({ "<leader>T", icon = { icon = icons.misc.Tmux, color = "cyan" }})
-- map("n", "<leader>T", ":let $VIM_DIR=expand('%:p:h')<CR>:silent !tmux split-window -hc $VIM_DIR<CR>", { desc = "Open TMUX" })

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     local buf = args.buf
--
--     if client.name == "clangd" then
--       wk.add({
--         { "<leader>c", group = "code" },
--         { "<leader>cs", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
--         { "<leader>cr", "<cmd>lua _RUN_CODE()<cr>", desc = "Run Code" },
--       }, { mode = "n", buffer = buf })
--     elseif client.name == "tsserver" then
--       wk.add({
--         { "<leader>c", group = "code" },
--         { "<leader>co", "<cmd>lua _ORGANIZE_TS_IMPORTS()<cr>", desc = "Organize Imports" },
--         { "<leader>cR", "<cmd>lua _REMOVE_UNUSED()<cr>", desc = "Remove Unused Imports" },
--         { "<leader>cr", "<cmd>lua _RUN_CODE()<cr>", desc = "Run Code" },
--         { "<leader>ci", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node" },
--       }, { mode = "n", buffer = buf })
--     elseif client.name == "bashls" then
--       wk.add({
--         { "<leader>c", group = "code" },
--           { "<leader>ci", "<cmd>lua _FLOAT_TERM()<cr>", desc = "Shell" },
--       }, { mode = "n", buffer = buf })
--     elseif client.name == "lua_ls" then
--       wk.add({
--         { "<leader>c", group = "code" },
--           { "<leader>ci", "<cmd>lua _LUA_TOGGLE()<cr>", desc = "Interactive Lua" },
--       }, { mode = "n", buffer = buf })
--     elseif client.name == "markdownlint" or client.name == "marksman" then
--       wk.add({
--         { "<leader>c", group = "code" },
--           { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
--       }, { mode = "n", buffer = buf })
--     elseif client.name == "html" then
--       wk.add({
--         { "<leader>c", group = "code" },
--          { "<leader>cl", "<cmd>lua _liveServerToggle()<cr>", desc = "Toggle Live Server" },
--          { "<leader>cr", "<cmd>LiveServerStart<cr>", desc = "Start Live Server" },
--          { "<leader>cs", "<cmd>LiveServerStop<cr>", desc = "Stop Live Server" },
--       }, { mode = "n", buffer = buf })
--     end
--   end,
-- })

-----------------------------------------------------------
-- Trouble.nvim - better diagnostics list and others
-- map('n', "<leader>dx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
-- map('n', "<leader>dX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
-- map('n', "<leader>ds", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
-- map('n', "<leader>dS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions/... (Trouble)" })
-- map('n', "<leader>dL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
-- map('n', "<leader>dQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
-- map('n',
--   "[q",
--   function()
--     if require("trouble").is_open() then
--       require("trouble").prev({ skip_groups = true, jump = true })
--     else
--       local ok, err = pcall(vim.cmd.cprev)
--       if not ok then
--         vim.notify(err, vim.log.levels.ERROR)
--       end
--     end
--   end,
--   { desc = "Previous Trouble/Quickfix Item" }
-- )
-- map('n',
--   "]q",
--   function()
--     if require("trouble").is_open() then
--       require("trouble").next({ skip_groups = true, jump = true })
--     else
--       local ok, err = pcall(vim.cmd.cnext)
--       if not ok then
--         vim.notify(tostring(err), vim.log.levels.ERROR)
--       end
--     end
--   end,
--   { desc = "Next Trouble/Quickfix Item" }
-- )

-- Yank.nvim
map({ 'n', 'x' }, 'y', '<Plug>(YankyYank)', { desc = 'Yanky yank' })
map({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)', { desc = 'Put yanked text after cursor' })
map({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)', { desc = 'Put yanked text before cursor' })
map('n', '=p', '<Plug>(YankyPutAfterLinewise)', { desc = 'Put yanked text in line below' })
map('n', '=P', '<Plug>(YankyPutBeforeLinewise)', { desc = 'Put yanked text in line above' })
map('n', '[y', '<Plug>(YankyCycleForward)', { desc = 'Cycle forward through yank history' })
map('n', ']y', '<Plug>(YankyCycleBackward)', { desc = 'Cycle backward through yank history' })
map('n', ';y', finder.yank_history, { desc = 'Yank History' })

-- Flash
-- map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
-- map({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
-- map("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
-- map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
-- map({ "c" }, "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

------------------------------------------------------
-- Noice
------------------------------------------------------
-- map('n', "<leader>nl", function() require("noice").cmd("last") end, { desc = "Noice Last Message" })
-- map('n', "<leader>nh", function() require("noice").cmd("history") end, { desc = "Noice History" })
-- map('n', "<leader>na", function() require("noice").cmd("all") end, { desc = "Noice All" })
-- map('n', "<leader>nd", function() require("noice").cmd("dismiss") end, { desc = "Dismiss All" })
-- map('c', "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, { desc = "Redirect Cmdline" })
-- map({ 'i', 'n', 's' }, "<c-f>",
--   function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
--   { silent = true, expr = true, desc = "Scroll forward"
--   })
-- map({ 'i', 'n', 's' }, "<c-b>",
--   function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
--   { silent = true, expr = true, desc = "Scroll backward"
--   })

-- For split/Join function
-- local treesj = require('treesj')
-- map('n', 'g/m', function() return treesj.toggle() end, { desc = 'Toggle' })
-- map('n', 'g/j', function() return treesj.join() end, { desc = 'Join' })
-- map('n', 'g/s', function() return treesj.split() end, { desc = 'Split' })

-- Overseer
-- map('n', "<leader>ow", "<cmd>OverseerToggle<cr>", { desc = "Task list" })
-- map('n', "<leader>oo", "<cmd>OverseerRun<cr>", { desc = "Run task" })
-- map('n', "<leader>oq", "<cmd>OverseerQuickAction<cr>", { desc = "Action recent task" })
-- map('n', "<leader>oi", "<cmd>OverseerInfo<cr>", { desc = "Overseer Info" })
-- map('n', "<leader>ob", "<cmd>OverseerBuild<cr>", { desc = "Task builder" })
-- map('n', "<leader>ot", "<cmd>OverseerTaskAction<cr>", { desc = "Task action" })
-- map('n', "<leader>oc", "<cmd>OverseerClearCache<cr>", { desc = "Clear cache" })
