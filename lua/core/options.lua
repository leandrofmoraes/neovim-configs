-- local opt = vim.opt
local g = vim.g

-- Set space as my leader key
g.mapleader = ' '
g.maplocalleader = ' '

local options = {
  -- Cursor highlighting
  cursorline = true, -- highlight the current line
  cursorcolumn = false,

  -- Pane splitting
  splitbelow = true,    -- force all horizontal splits to go below current window
  splitright = true,    -- force all vertical splits to go to the right of current window

  splitkeep = 'screen', -- Keep cursor to the same screen line when opening a split

  -- Searching
  smartcase = true,  -- smart case
  ignorecase = true, -- ignore case in search patterns
  incsearch = true,
  -- hlsearch = false,  -- highlight all matches on previous search pattern
  inccommand = "nosplit", -- show the effects of a command incrementally, as you type

  -- Make terminal support truecolor
  termguicolors = true, -- set term gui colors (most terminals support this)

  -- only set clipboard if not in ssh, to make sure the OSC 52
  -- integration works automatically. Requires Neovim >= 0.10.0
  clipboard = vim.env.SSH_TTY and "" or "unnamedplus", -- Sync with system clipboard
  -- clipboard = 'unnamedplus', -- allows neovim to access the system clipboard

  -- Disable old vim status
  showmode = false, -- we don't need to see things like -- INSERT -- anymore

  -- Set relative line numbers
  number = true,   -- set numbered lines
  relativenumber = false,
  numberwidth = 2, -- set number column width to 2 {default 4}

  -- Tab config
  expandtab = true,   -- convert tabs to spaces
  smartindent = true, -- make indenting smarter again
  shiftwidth = 2,     -- the number of spaces inserted for each indentation
  tabstop = 2,        -- insert 2 spaces for a tab
  shiftround = true,

  -- Code folding
  foldlevel = 99,
  foldlevelstart = 99,
  foldcolumn = '0', -- Don't show the foldcolumn
  foldenable = true,
  -- foldmethod = "manual", -- folding, set to "expr" for treesitter based folding
  foldmethod = 'expr',
  -- foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
  foldexpr = 'nvim_treesitter#foldexpr()',

  -- Decrease update time
  updatetime = 100, -- faster completion

  -- Disable swapfile
  swapfile = false, -- creates a swapfile

  -- Enable persistent undo
  undofile = true, -- enable persistent undo
  -- undodir = undodir, -- set an undo directory

  -- Maximum number of undo changes
  undolevels = 10000,

  -- Always show tabline
  showtabline = 0, -- 4

  -- Mouse support
  mouse = 'a',      -- allow the mouse to be used in neovim
  mousehide = true, -- hide mouse pointer while typing
  mousescroll = "ver:1,hor:4",

  -- Scrolloff
  scrolloff = 8,     -- minimal number of screen lines to keep above and below the cursor.
  sidescrolloff = 8, -- minimal number of screen lines to keep left and right of the cursor.

  -- wrapping
  wrap = true,      -- display lines as one long line
  linebreak = true, -- wrap long lines at a blank

  -- Show invisible characters
  list = true,

  -- Fill chars
  fillchars = {
    eob = ' ', -- suppress ~ at EndOfBuffer
    diff = '╱', -- alternatives = ⣿ ░ ─
    msgsep = ' ', -- alternatives: ‾ ─
    fold = ' ',
    foldsep = ' ',
    foldopen = '',
    foldclose = '',
  },

  -- Enable lazy redraw for performance
  -- lazyredraw = true,

  -- faster redrawing for modern terminals
  -- ttyfast = true,

  -- Have the statusline only display at the bottom
  laststatus = 3,

  -- Confirm to save changed before exiting the modified buffer
  -- confirm = true,

  -- Hide * markup for bold and italic
  conceallevel = 3, --0 -- so that `` is visible in markdown files

  -- Hide the command line unless needed
  cmdheight = 1,                                              -- 0 -- more space in the neovim command line for displaying messages

  grepprg = 'rg --vimgrep',                                   -- Use ripgrep as the grep program for neovim

  grepformat = '%f:%l:%c:%m',                                 -- Set the grep format

  completeopt = { "menu", "menuone", "noselect", "preview" }, -- Set completeopt to have a better completion experience

  -- Set key timeout to 1000ms
  -- timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
  timeoutlen = g.vscode and 1000 or 300, -- Lower than default (1000) to quickly trigger which-key

  -- Window config
  winwidth = 5,
  winminwidth = 5,
  equalalways = false,

  -- Always show the signcolumn
  signcolumn = 'yes', -- always show the sign column, otherwise it would shift the text each time

  -- Formatting options
  formatoptions = 'jcroqlnt', -- This is a sequence of letters which describes how automatic formatting is to be done.

  -- Put the cursor at the start of the line for large jumps
  startofline = true,

  -- Allow cursor to move where this is no text is visual block mode
  virtualedit = 'block',

  wildmode = 'longest:full,full', -- Command-line completion mode

  -- Enable autowrite
  -- autowrite = true,

  -- Number of items in a completion menu
  pumheight = 10,            -- 20, -- pop up menu height

  backup = false,            -- creates a backup file
  fileencoding = 'utf-8',    -- the encoding written to a file
  guifont = 'monospace:h17', -- the font used in graphical neovim applications
  hidden = true,             -- required to keep multiple buffers and open multiple buffers
  breakindent = true,        -- Every wrapped line will continue visually indented
  title = true,              -- set the title of window to the value of the titlestring
  writebackup = false,       -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  showcmd = true,
  ruler = false,
  autochdir = true,
  -- shell="/usr/bin/zsh",

  spelllang = { "en" },

  -- Session save options
  sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' },
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- vim.cmd([[
-- augroup vimrc-incsearch-highlight
--   autocmd!
--   autocmd CmdlineEnter /,\? :set hlsearch
--   autocmd CmdlineLeave /,\? :set nohlsearch
-- augroup END
-- ]])

-- AI completions functionality
-- g.ai_cmp = false

-- g.lazyvim_check_order = false

-- Disable lsp logging
vim.lsp.set_log_level('OFF')

-- Set LSP servers to be ignored when used with `util.root.detectors.lsp`
-- for detecting the LSP root
-- vim.g.root_lsp_ignore = { "copilot" }

-- Deprecation Warnings
g.deprecation_warnings = true

-- Disable certain builtins
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_logipat = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_fzf = 1

-- Disable provider warnings in the healthcheck
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
-- g.loaded_ruby_provider = 0

-- Fix markdown indentation settings
g.markdown_recommended_style = 0

-- better coop with fzf-lua
vim.env.FZF_DEFAULT_OPTS = ""

-- shortmess options
-- opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.spelllang:append('cjk') -- disable spellchecking for asian characters (VIM algorithm does not support it)
vim.opt.shortmess:append('c')   -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append('I')   -- don't show the default intro message
vim.opt.whichwrap:append('<,>,[,],h,l')

vim.filetype.add({
  extension = {
    tex = 'tex',
    zir = 'zir',
    cr = 'crystal',
    config = 'config',
    conf = 'config',
    mdx = "markdown.mdx",
  },
  pattern = {
    ['[jt]sconfig.*.json'] = 'jsonc',
    ['.*/kitty/*.conf'] = 'bash',
    ['.*/hypr/.*%.conf'] = 'hyprlang',
    ["compose.*%.ya?ml"] = "yaml.docker-compose",
    ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
  },
})

local icons = require('utils.icons')
local default_diagnostic_config = {
  signs = {
    active = true,
    values = {
      { name = 'DiagnosticSignError', text = icons.diagnostics.Error },
      { name = 'DiagnosticSignWarn',  text = icons.diagnostics.Warning },
      { name = 'DiagnosticSignHint',  text = icons.diagnostics.Hint },
      { name = 'DiagnosticSignInfo',  text = icons.diagnostics.Information },
    },
  },
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}
vim.diagnostic.config(default_diagnostic_config)


-- vim.lsp.set_log_level("debug")

-- Enable auto format
-- vim.g.autoformat = true

-- Se estiver rodando no VSCode, marca a variável global
if vim.env.VSCODE then
  g.vscode = true
end

g.my_active_completion = "blink" -- Set auto-complete mechanism "nvim-cmp" or "blink"

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
g.ai_cmp = true

-- Enable/Disable LazyDev
g.lazydev_enabled = true

-- Root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
-- vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }


-- Habilita realce de código para arquivos markdown
-- vim.cmd("let g:markdown_fenced_languages = ['bash', 'html', 'javascript', 'typescript', 'vim', 'lua', 'css']")

-- Configurações específicas para o LSP e Linters do LazyVim (Python)
-- vim.g.lazyvim_python_lsp = "basedpyright"
-- vim.g.lazyvim_python_ruff = "ruff"

-- Configuração de Terminal para Windows
-- if vim.fn.has("win32") == 1 then
--   LazyVim.terminal.setup("pwsh")
-- end

-- Define Blinking (Piscar) no Terminal como true se o sistema operacional não for Windows, e false se for Windows.
-- Sets Blinking to true if the operating system is not Windows, and false if it is Windows.
-- vim.g.lazyvim_blink_main = not jit.os:find("Windows")
