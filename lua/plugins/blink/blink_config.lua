local M = {}

-- Use this function to check if the cursor is inside a comment block

local function inside_comment_block()
  if vim.api.nvim_get_mode().mode ~= 'i' then
    return false
  end

  local ft = vim.bo.filetype
  -- Tenta obter o parser para o filetype atual. Se não conseguir, retorna false.
  local ok_parser, parser = pcall(vim.treesitter.get_parser, 0, ft, { error = false })
  if not ok_parser or not parser then
    return false
  end

  local ok_node, node_under_cursor = pcall(vim.treesitter.get_node)
  if not ok_node or not node_under_cursor then
    return false
  end

  local ok_query, query = pcall(vim.treesitter.query.get, ft, 'highlights')
  if not ok_query or not query then
    return false
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
    local capture_name = query.captures[id]
    -- if capture_name and capture_name:find('comment') then
    if capture_name and (capture_name:find('comment') or capture_name:find('string')) then
      local start_row, start_col, end_row, end_col = node:range()
      if start_row <= row and row <= end_row then
        if start_row == row and end_row == row then
          if start_col <= col and col <= end_col then
            return true
          end
        elseif start_row == row then
          if start_col <= col then
            return true
          end
        elseif end_row == row then
          if col <= end_col then
            return true
          end
        else
          return true
        end
      end
    end
  end

  return false
end

local function transform_items(desc, apply_filter)
  return function(_, items)
    for _, item in ipairs(items) do
      item.labelDetails = {
        description = desc,
      }
    end
    if not apply_filter then
      return items
    else
      return vim.tbl_filter(function(item)
        return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
      end, items)
    end
  end
end

M.documentation = {
  auto_show = true,
  -- Whether to use treesitter highlighting, disable if you run into performance issues
  treesitter_highlighting = true,
  draw = function(opts)
    opts.default_implementation()
  end,
  window = {
    -- min_width = 10,
    -- max_width = 80,
    -- max_height = 20,
    -- Note that the gutter will be disabled when border ~= 'none'
    border = 'padded', -- or 'rounded'
    scrollbar = true,
  },
}

M.default_sources = function()
  -- Lista de fontes padrão
  local sources = {}

  local function add_sources(sources_list)
    local current_ft = vim.bo.filetype
    local in_comment = inside_comment_block()

    for _, config in ipairs(sources_list) do
      local source = config.source
      local filetypes = config.filetypes or {}
      -- local comment_flag = config.comment or false  -- Alinhado com a chave 'comment'
      local add_if_comment = config.comment
      local disable_if_comment = config.disable_comment

      local should_add = false

      -- Se a lista de filetypes estiver vazia, consideramos que a condição filetype é atendida.
      local filetype_match = (#filetypes == 0) or vim.tbl_contains(filetypes, current_ft)

      -- Condição 1: Filetype match
      if filetype_match then
        should_add = true
      end

      -- Se for para desabilitar em comentário e estivermos em comentário, força o não-add.
      if disable_if_comment and in_comment then
        should_add = false
      end
      -- Se foi definido para adicionar especificamente em comentário, ativa a fonte mesmo que o filetype não bata.
      if add_if_comment and in_comment then
        should_add = true
      end

      if should_add and not vim.tbl_contains(sources, source) then
        table.insert(sources, source)
      end
    end
  end

  -- Tabela de configuração das fontes
  local sources_config = {
    { source = 'lsp' },
    { source = 'snippets' },
    { source = 'buffer' },
    { source = 'path' },
    { source = 'lazydev' },
    { source = 'copilot' },
    -- { source = "cmp_tabnine", },
    { source = 'dadbod', filetypes = { 'sql' } },
    -- { source = "markdown", filetypes = { 'markdown' }},
    -- { source = "dictionary" , filetypes = { 'markdown', 'text' }, comment = true },
    { source = 'digraphs', filetypes = { 'markdown', 'text' }, comment = true },
    { source = 'spell', filetypes = { 'markdown', 'text' }, comment = true },
    { source = 'emoji', filetypes = { 'markdown', 'text', 'config' }, comment = true },
    { source = 'nerdfont', filetypes = { 'markdown', 'text', 'config' }, comment = true },
  }

  -- Chama a função uma única vez, passando a lista inteira de configurações
  add_sources(sources_config)

  return sources
end

M.providers = {
  lsp = {
    name = 'LSP',
    module = 'blink.cmp.sources.lsp',
    -- fallbacks = { 'buffer' },
    -- Filter text items from the LSP provider, since we have the buffer provider for that
    transform_items = transform_items('[LSP]', true),
    -- opts = { tailwind_color_icon = '██' },

    --- These properties apply to !!ALL sources!!
    --- NOTE: All of these options may be functions to get dynamic behavior
    --- See the type definitions for more information
    enabled = true, -- Whether or not to enable the provider
    -- async = false, -- Whether we should wait for the provider to return before showing the completions
    -- timeout_ms = 2000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
    should_show_items = true, -- Whether or not to show the items
    -- max_items = nil, -- Maximum number of items to display in the menu
    -- min_keyword_length = 2, -- Minimum number of characters in the keyword to trigger the provider
    -- If this provider returns 0 items, it will fallback to these providers.
    -- If multiple providers falback to the same provider, all of the providers must return 0 items for it to fallback
    score_offset = 98, -- Boost/penalize the score of the items
    override = nil, -- Override the source's functions
  },
  path = {
    name = 'Path',
    module = 'blink.cmp.sources.path',
    score_offset = 90,
    fallbacks = { 'buffer' },
    opts = {
      trailing_slash = true,
      label_trailing_slash = true,
      get_cwd = function(context)
        return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
      end,
      show_hidden_files_by_default = true,
    },
    transform_items = transform_items('[Path]'),
  },
  buffer = {
    name = 'Buffer',
    module = 'blink.cmp.sources.buffer',
    opts = {
      -- default to all visible buffers
      get_bufnrs = function()
        return vim
          .iter(vim.api.nvim_list_wins())
          :map(function(win)
            return vim.api.nvim_win_get_buf(win)
          end)
          :filter(function(buf)
            return vim.bo[buf].buftype ~= 'nofile'
          end)
          :totable()
      end,
    },
    score_offset = 85, -- Tune by preference
    min_keyword_length = 2, -- Minimum number of characters in the keyword to trigger the provider
    transform_items = transform_items('[Buffer]'),
  },
  omni = {
    name = 'Omni',
    module = 'blink.cmp.sources.complete_func',
    opts = {
      disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' },
    },
    score_offset = 50, -- Tune by preference
    transform_items = transform_items('[Omni]'),
  },
  -- markdown = {
  --   name = 'RenderMarkdown',
  --   module = 'render-markdown.integ.blink',
  --   fallbacks = { 'lsp' },
  --   score_offset = 50, -- Tune by preference
  --   transform_items = transform_items("[Markdown]"),
  -- },
  emoji = {
    module = 'blink-emoji',
    name = 'Emoji',
    score_offset = 50, -- Tune by preference
    opts = { insert = true }, -- Insert emoji (default) or complete its name
    -- should_show_items = function()
    --   return vim.tbl_contains(
    --     -- Enable emoji completion only for git commits and markdown.
    --     -- By default, enabled for all file-types.
    --     { "gitcommit", "markdown", "text" },
    --     vim.o.filetype
    --   )
    -- end,
    transform_items = transform_items('[Emoji]'),
  },
  nerdfont = {
    module = 'blink-nerdfont',
    name = 'Nerd Fonts',
    score_offset = 50, -- Tune by preference
    opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
    -- should_show_items = function()
    --   return vim.tbl_contains(
    --     -- Enable emoji completion only for git commits and markdown.
    --     -- By default, enabled for all file-types.
    --     { "gitcommit", "markdown", "text", "config", "jsonc" },
    --     vim.o.filetype
    --   )
    -- end,
    transform_items = transform_items('[NerdFont]'),
  },
  lazydev = {
    name = 'lazydev',
    module = 'lazydev.integrations.blink',
    score_offset = 95, -- show at a higher priority than lsp
    transform_items = transform_items('[LazyDev]'),
  },
  copilot = {
    name = 'copilot',
    module = 'blink-cmp-copilot',
    score_offset = 100,
    async = true,
    transform_items = transform_items('[Copilot]'),
  },
  -- cmp_tabnine = {
  --   name = "cmp_tabnine",
  --   module = 'blink.compat.source',
  --   score_offset = 50,
  --   -- async = true,
  --   opts = {
  --     -- set `cmp_name` to the name you would use for nvim-cmp, for instance:
  --     cmp_name = "cmp_tabnine"
  --   },
  --   transform_items = transform_items("[TabNine]"),
  -- },
  digraphs = {
    -- IMPORTANT: use the same name as you would for nvim-cmp
    name = 'digraphs',
    module = 'blink.compat.source',

    -- all blink.cmp source config options work as normal:
    score_offset = 50,

    -- this table is passed directly to the proxied completion source
    -- as the `option` field in nvim-cmp's source config
    --
    -- this is NOT the same as the opts in a plugin's lazy.nvim spec
    opts = {
      -- this is an option from cmp-digraphs
      cache_digraphs_on_start = true,

      -- If you'd like to use a `name` that does not exactly match nvim-cmp,
      -- set `cmp_name` to the name you would use for nvim-cmp, for instance:
      cmp_name = 'digraphs',
      -- then, you can set the source's `name` to whatever you like.
    },
    transform_items = transform_items('[Digraphs]'),
  },
  dadbod = {
    name = 'Dadbod',
    module = 'vim_dadbod_completion.blink',
    score_offset = 80, -- Tune by preference
    transform_items = transform_items('[Dadbod]'),
  },
  snippets = {
    name = 'Snippets',
    module = 'blink.cmp.sources.snippets',
    transform_items = transform_items('[Snippets]'),
    score_offset = 96, -- Tune by preference
    min_keyword_length = 2, -- Minimum number of characters in the keyword to trigger the provider
    -- For `snippets.preset == 'default'`
    -- opts = {
    --   friendly_snippets = true,
    --   search_paths = { vim.fn.stdpath('config') .. '/snippets' },
    --   global_snippets = { 'all' },
    --   extended_filetypes = {},
    --   ignored_filetypes = {},
    --   get_filetype = function(context)
    --     return vim.bo.filetype
    --   end
    --   -- Set to '+' to use the system clipboard, or '"' to use the unnamed register
    --   clipboard_register = nil,
    -- }

    -- For `snippets.preset == 'luasnip'`
    opts = {
      -- Whether to use show_condition for filtering snippets
      use_show_condition = true,
      -- Whether to show autosnippets in the completion list
      show_autosnippets = true,
    },

    -- For `snippets.preset == 'mini_snippets'`
    -- opts = {
    --   -- Whether to use a cache for completion items
    --   use_items_cache = true,
    -- }
  },
  spell = {
    name = 'Spell',
    module = 'blink-cmp-spell',
    opts = {
      -- EXAMPLE: Only enable source in `@spell` captures, and disable it
      -- in `@nospell` captures.
      enable_in_context = function()
        local curpos = vim.api.nvim_win_get_cursor(0)
        local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
        local in_spell_capture = false
        for _, cap in ipairs(captures) do
          if cap.capture == 'spell' then
            in_spell_capture = true
          elseif cap.capture == 'nospell' then
            return false
          end
        end
        return in_spell_capture
      end,
    },
    transform_items = transform_items('[Spell]'),
    score_offset = 50, -- Tune by preference
    min_keyword_length = 3, -- Minimum number of characters in the keyword to trigger the provider
    max_items = 4,
  },
  -- dictionary = {
  --   module = 'blink-cmp-dictionary',
  --   name = 'Dict',
  --   -- Make sure this is at least 2.
  --   -- 3 is recommended
  --   enabled = true,
  --   min_keyword_length = 3,
  --   max_items = 4,
  --   opts = {
  --     -- options for blink-cmp-dictionary
  --     dictionary_directories = { vim.fn.expand('~/.config/nvim/dictionary') },
  --   },
  --   transform_items = transform_items("[Dict]"),
  -- }
}

return M
