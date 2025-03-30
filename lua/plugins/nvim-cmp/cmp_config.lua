
-- cmp_config.lua
-- Configuração modularizada para o nvim-cmp
-- Para ativar essa configuração, defina: vim.g.my_active_completion = "cmp"

local M = {}

vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })

-- Função auxiliar para verificar se há palavras antes do cursor
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end
  local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return current_line:sub(col, col):match("%s") == nil
end

-- Configuração dos mapeamentos de teclas para o cmp
local function cmp_mappings(cmp, luasnip)
  return cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),

    ["<CR>"] = cmp.mapping(function(fallback)
      local cmp_types = require("cmp.types.cmp")
      local ConfirmBehavior = cmp_types.ConfirmBehavior
      local confirm_opts = { behavior = ConfirmBehavior.Replace, select = false }
      if cmp.visible() then
        -- Em modo de inserção, usa o comportamento 'Insert' para evitar sobrescrever parênteses, por exemplo
        if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
          confirm_opts.behavior = ConfirmBehavior.Insert
        end
        local entry = cmp.get_selected_entry()
        -- Se for uma sugestão do copilot, aceita com Replace e seleção ativa
        if entry and entry.source.name == "copilot" then
          confirm_opts.behavior = ConfirmBehavior.Replace
          confirm_opts.select = true
        end
        if cmp.confirm(confirm_opts) then
          return
        end
      end
      fallback()
    end),

    ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ["<C-CR>"] = cmp.mapping(function(fallback)
      cmp.abort()
      fallback()
    end),
  })
end

-- Configuração das fontes de completamento
local function cmp_sources(cmp)
  return cmp.config.sources({
    -- Fonte do Copilot com prioridade no grupo 2
    {
      name = "copilot",
      group_index = 2,
      max_item_count = 3,
      trigger_characters = { ".", ":", "(", "'", '"', "[", ",", "#", "*", "@", "|", "=", "-", "{", "/", "\\", "+", "?", " " },
    },
    {
      name = "nvim_lsp",
      entry_filter = function(entry, ctx)
        local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
        if kind == "Snippet" and ctx.prev_context.filetype == "java" then
          return false
        end
        return true
      end,
    },
    { name = "path" },
    { name = "luasnip" },
    { name = "cmp_tabnine" },
    { name = "nvim_lua" },
    { name = "lazydev" },
    { name = "buffer" },
    { name = "calc" },
    { name = "emoji" },
    { name = "treesitter" },
    { name = "render-markdown" },
    { name = "digraphs" },
    { name = "crates" },
    { name = "tmux" },
  })
end

-- Configurar a formatação dos itens de completamento, utilizando o lspkind.
local function cmp_formatting()
  return {
    icons = require('utils.icons').kind,
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      -- vim_item.dup = { buffer = 1, path = 1, nvim_lsp = 0 }
      local icons = require('utils.icons')
      local kind = require('lspkind').cmp_format({
        -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
        mode = 'symbol_text',
        ellipsis_char = '...',
        maxwidth = 50; -- 50,
        -- symbol_map = source_mapping,
      })(entry, vim_item)

      local strings = vim.split(kind.kind, '%s', { trimempty = true })
      -- kind.kind = ' ' .. (strings[1] or '') .. ' '
      kind.kind = (strings[1] or '')
      if entry.source.name == 'calc' then
        -- Get the custom icon for 'calc' source
        local custom_menu_icon = {
          calc = ' 󰃬 ',
          --NOTE: requires a nerdfont to be rendered
          --you could include other sources here as well
        }
        -- Replace the kind glyph with the custom icon
        vim_item.kind = custom_menu_icon.calc
      end
      if entry.source.name == 'copilot' then
        vim_item.kind = icons.git.Octoface
        vim_item.kind_hl_group = 'CmpItemKindCopilot'
      end

      if entry.source.name == 'cmp_tabnine' then
        vim_item.kind = icons.misc.Robot
        vim_item.kind_hl_group = 'CmpItemKindTabnine'
      end

      if entry.source.name == 'crates' then
        vim_item.kind = icons.misc.Package
        vim_item.kind_hl_group = 'CmpItemKindCrate'
      end

      if entry.source.name == 'lab.quick_data' then
        vim_item.kind = icons.misc.CircuitBoard
        vim_item.kind_hl_group = 'CmpItemKindConstant'
      end

      if entry.source.name == 'emoji' then
        vim_item.kind = icons.misc.Smiley
        vim_item.kind_hl_group = 'CmpItemKindEmoji'
      end
      kind.menu = '   (' .. (strings[2] or '') .. ')'

      kind.menu = ({
        nvim_lsp = '(LSP)',
        emoji = '(Emoji)',
        path = '(Path)',
        calc = '(Calc)',
        cmp_tabnine = '(Tabnine)',
        vsnip = '(Snippet)',
        luasnip = '(Snippet)',
        buffer = '(Buffer)',
        tmux = '(TMUX)',
        copilot = '(Copilot)',
        treesitter = '(TreeSitter)',
        digraphs = '(Digraphs)',
        lazydev = '(LazyDev)',
      })[entry.source.name]
      return kind
    end,
    duplicates = {
      buffer = 1,
      path = 1,
      nvim_lsp = 0,
      luasnip = 1,
    },
    duplicates_default = 0
  }
end

-- Função principal de setup, que aplica todas as configurações do cmp.
function M.setup()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  cmp.setup({
    confirm_opts = {
      behavior = require("cmp.types.cmp").ConfirmBehavior.Replace,
      select = false,
    },
    completion = {
      completeopt = "menu,menuone,preview,noselect",
      keyword_length = 1,
    },
    snippet = {
      -- Utiliza o LuaSnip para expandir os snippets
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp_mappings(cmp, luasnip),
    sources = cmp_sources(cmp),
    formatting = cmp_formatting(),
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        cmp.config.compare.score,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
        cmp.config.compare.abbr,
        cmp.config.compare.menu,
      },
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

    experimental = { ghost_text = { hl_group = "CmpGhostText" } },
  })

  -- Configuração para o modo cmdline (pesquisa e comandos)
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
  })
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
      { name = "cmdline" },
    }),
  })
end

return M
