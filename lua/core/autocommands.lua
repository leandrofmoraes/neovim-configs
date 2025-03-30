--------------------------------------------------------------------------------
-- Definição de autocomandos
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Abreviaturas para as funções de criação de autocomandos e grupos
-- Abbreviations for autocommand and group creation functions
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

--------------------------------------------------------------------------------
-- Função auxiliar para alternar o cursorline na janela
-- Helper function to toggle cursorline in window
--------------------------------------------------------------------------------
local function toggle_cursorline(enable)
  if enable then
    -- Se já tiver sido marcado para reativar o cursorline
    -- If it has already been checked to re-enable the cursorline
    if rawget(vim.w, "auto_cursorline") then
      vim.wo.cursorline = true
      rawset(vim.w, "auto_cursorline", nil)
    end
  else
    -- Se o cursorline estiver ativo, marca para ser reativado depois e desativa-o
    -- If the cursorline is active, mark it to be reactivated later and deactivate it
    if vim.wo.cursorline then
      rawset(vim.w, "auto_cursorline", true)
      vim.wo.cursorline = false
    end
  end
end

-- para ativar o cursorline quando sair do modo inserção ou entrar na janela
-- to activate cursorline when exiting insert mode or entering window
autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function() toggle_cursorline(true) end,
})

-- para desativar o cursorline ao entrar no modo inserção ou sair da janela
-- to disable cursorline when entering insert mode or exiting the window
autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function() toggle_cursorline(false) end,
})

--------------------------------------------------------------------------------
-- Remover espaços em branco ao salvar um arquivo
-- Remove whitespace when saving a file
--------------------------------------------------------------------------------
autocmd('BufWritePre', {
  group = augroup('trailing_space'),
  command = '%s/\\s\\+$//e'
})

--------------------------------------------------------------------------------
-- Rebalancear janelas automaticamente quando o Neovim for redimensionado
-- Automatically rebalance windows on vim resize
--------------------------------------------------------------------------------
-- autocmd('VimResized', {
--   group = augroup('resize_splits'),
--   command = 'tabdo wincmd ='
-- })
autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

--------------------------------------------------------------------------------
-- Impedir que uma nova linha inserida com "o" se torne um comentário
-- Never insert line as a comment when using 'o' to enter insert mode
--------------------------------------------------------------------------------
autocmd('BufWinEnter', {
  group = augroup('no_comment_on_o'),
  command = 'setlocal formatoptions-=o'
})

--------------------------------------------------------------------------------
-- Fechar janelas de ajuda, man, lspinfo, checkhealth, quickfix, query, notify com "q"
-- Close man and help, man, lspinfo, checkhealth, quickfix, query, notify with just <q>
--------------------------------------------------------------------------------
-- autocmd('FileType', {
--     group = augroup('close_with_q'),
--     pattern = { 'help', 'man', 'lspinfo', 'checkhealth', 'qf', 'query', 'notify' },
--     callback = function(event)
--         vim.bo[event.buf].buflisted = false
--         vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
--     end,
-- })
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
          buffer = event.buf,
          silent = true,
          desc = "Quit buffer",
        })
    end)
  end,
})

--------------------------------------------------------------------------------
-- Criar automaticamente diretórios ausentes ao salvar um arquivo
-- Auto create dir when saving a file where some intermediate directory does not exist
--------------------------------------------------------------------------------
autocmd('BufWritePre', {
  group = augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

--------------------------------------------------------------------------------
-- Ativar verificação ortográfica e quebra de linha para tipos de arquivo específicos
-- Check for spelling in text filetypes and enable wrapping, and set gj and gk keymaps
--------------------------------------------------------------------------------
autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'gitcommit', 'markdown', 'text', 'NeogitCommitMessage' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

--------------------------------------------------------------------------------
-- Retomar a última posição do cursor ao reabrir um buffer
-- Go to the last loc when opening a buffer
--------------------------------------------------------------------------------
autocmd('BufReadPost', {
  group = augroup('last_loc'),
  callback = function(event)
    local exclude = { 'gitcommit', 'NeogitCommitMessage' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    -- vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--------------------------------------------------------------------------------
-- Verificar se o arquivo foi modificado externamente e recarregar, se necessário
-- Check if the file needs to be reloaded when it's changed
--------------------------------------------------------------------------------
-- autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
--   group = augroup('checktime'),
--   command = 'checktime'
-- })
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

--------------------------------------------------------------------------------
-- Atualizar os destaques de cores (transparência) ao trocar de esquema de cores
-- Update color highlights (transparency) when switching color schemes
--------------------------------------------------------------------------------
autocmd('ColorScheme', {
  group = augroup('nobg'),
  pattern = '*',
  callback = function()
    local hl_groups = {
      'Normal',
      'SignColumn',
      'NormalNC',
      'TelescopeBorder',
      'NvimTreeNormal',
      'NvimTreeNormalNC',
      'EndOfBuffer',
      'MsgArea',
      'NeoTreeNormal',
      'NeoTreeNormalNC',
    }
    for _, name in ipairs(hl_groups) do
      vim.cmd(string.format('highlight %s ctermbg=none guibg=none', name))
      -- Alternativamente, use:
      -- vim.api.nvim_set_hl(0, name, { bg = 'NONE', ctermbg = 'NONE' })
    end
  end,
})

--------------------------------------------------------------------------------
-- vim-incsearch-highlight será um grupo de autocomandos para destacar o texto de todas as ocorrências de uma pesquisa incremental
-- vim-incsearch-highlight will be a group of autocommands to highlight the text of all occurrences of an incremental search
--------------------------------------------------------------------------------
local incsearch_group = augroup("vimrc-incsearch-highlight")

--------------------------------------------------------------------------------
-- Função para registrar autocomandos
-- Function to register autocommands
--------------------------------------------------------------------------------
local function set_autocmd(event, command)
  vim.api.nvim_create_autocmd(event, {
    group = incsearch_group,
    pattern = { "/", "?" },
    command = command,
  })
end

-- Define os autocomandos
set_autocmd("CmdlineEnter", "set hlsearch")
set_autocmd("CmdlineLeave", "set nohlsearch")

--------------------------------------------------------------------------------
-- Ajuste de fillchars para suprimir o "~" na última linha do buffer
-- Adjust fillchars to suppress the "~" on the last line of the buffer
--------------------------------------------------------------------------------
vim.opt.fillchars = 'eob: '

--------------------------------------------------------------------------------
-- Destaca visualmente o texto copiado (yank) por 1s usando a cor do 'IncSearch'.
-- Visually highlights copied (yank) text for 1s using the 'IncSearch' color.
--------------------------------------------------------------------------------
autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 }) -- Or set to higroup = 'Visual' to Use the visual selection color (default blue)
  end,
})
--------------------------------------------------------------------------------
-- Outras configurações (comentadas) que podem ser habilitadas futuramente:
-- Exemplo: ajuste de cmdheight durante gravação,
-- integração com plugins como barbecue, etc.
--------------------------------------------------------------------------------

-- Fix conceallevel for json files
autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- make it easier to close man-files when opened inline
autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})
--
-- autocmd('RecordingEnter', {
--   group = augroup('macro_cmdheight_on'),
--   callback = function()
--     vim.opt.cmdheight = 1
--   end,
-- })
--
-- autocmd('RecordingLeave', {
--   group = augroup('macro_cmdheight_off'),
--   callback = function()
--     vim.opt.cmdheight = 0
--   end,
-- })

-- Corrige erros de digitação
local typos = { 'W', 'Wq', 'WQ', 'Wqa', 'WQa', 'WQA', 'WqA', 'Q', 'Qa', 'QA' }
for _, cmd in ipairs(typos) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    vim.api.nvim_cmd({
      cmd = cmd:lower(),
      bang = opts.bang,
      mods = { noautocmd = true },
    }, {})
  end, { bang = true })
end
