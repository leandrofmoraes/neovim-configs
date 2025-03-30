local function dedup(list)
  local seen = {}
  local result = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(result, v)
      seen[v] = true
    end
  end
  return result
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,  -- usa sempre o commit mais recente
    build = ":TSUpdate",
    -- event = { 'BufReadPost', 'BufNewFile' },
    event = { "BufReadPost", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- Carrega cedo se nenhum arquivo for passado na linha de comando
    init = function(plugin)
      -- Adiciona as queries customizadas ao runtime
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    opts = function(_, opts)

      opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed or {}, {
        "lua", "luadoc", "luap", "c", "cpp", "java", "markdown", "markdown_inline",
        "git_config", "git_rebase", "gitcommit", "gitignore", "diff", "vimdoc",
        "bash", "toml", "ssh_config", "dockerfile",
        "html", "javascript", "jsdoc", "json", "jsonc", "printf", "python",
        "query", "regex", "tsx", "typescript", "vim", "xml", "yaml",
        "make", "cmake", "css", "http", "scss", "sql",
      })

      -- Configuração de highlight
      opts.highlight = vim.tbl_deep_extend("force", opts.highlight or {}, {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
      })

      -- Configuração de context_commentstring
      opts.context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
          typescript = "// %s",
          css = "/* %s */",
          scss = "/* %s */",
          html = "<!-- %s -->",
          svelte = "<!-- %s -->",
          vue = "<!-- %s -->",
          json = "",
        },
      }

      -- Configuração de indentação
      opts.indent = { enable = true, disable = { "yaml", "python" } }
      -- Outras opções
      opts.autotag = { enable = false }
      opts.auto_install = true
      -- opts.matchup = { enable = true, include_match_words = true, enable_quotes = true }
      opts.matchup = {
        enable = true,              -- mandatory, false will disable the whole extension
        disable = { "c", "ruby" },  -- optional, list of language that will be disabled
        -- [options]
      }

      -- Incremental selection e textobjects (da configuração do LazyVim)
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      }
      -- opts.textobjects = {
      --   move = {
      --     enable = true,
      --     goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
      --     goto_next_end   = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
      --     goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
      --     goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      --   },
      -- }

      return opts
    end,
    config = function(_, opts)
      -- if type(opts.ensure_installed) == "table" then
      --   -- opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
      --   opts.ensure_installed = dedup(opts.ensure_installed or {})
      -- end
      require("nvim-treesitter.configs").setup(opts)
      -- Use o parser bash para arquivos zsh
      vim.treesitter.language.register("bash", "zsh")
    end,
  },
  -- {
  --   "windwp/nvim-ts-autotag",
  --   event = "LazyFile",
  --   opts = {},
  -- },
}

-- return { -- Highlight, edit, and navigate code
--   'nvim-treesitter/nvim-treesitter',
--   build = ':TSUpdate',
--   dependencies = {
--     {
--       'nvim-treesitter/nvim-treesitter-textobjects',
--     },
--
--     {
--       'nvim-treesitter/nvim-treesitter-context',
--       enabled = true,
--       opts = { mode = 'cursor', max_lines = 3 },
--     },
--   },
--   opts = {
--     ensure_installed = {
--       'bash',
--       'c',
--       'diff',
--       'html',
--       'javascript',
--       'jsdoc',
--       'json',
--       'jsonc',
--       'lua',
--       'luadoc',
--       'luap',
--       'markdown',
--       'markdown_inline',
--       'python',
--       'query',
--       'regex',
--       'toml',
--       'tsx',
--       'typescript',
--       'vim',
--       'vimdoc',
--       'xml',
--       'yaml',
--       'hyprlang',
--       'rasi',
--       'dockerfile',
--     },
--     -- Autoinstall languages that are not installed
--     auto_install = true,
--     highlight = { enable = true },
--     indent = { enable = true },
--
--     incremental_selection = {
--       enable = true,
--       keymaps = {
--         init_selection = '<M-space>',
--         node_incremental = '<M-space>',
--         scope_incremental = false,
--         node_decremental = '<M-bs>',
--       },
--     },
--     textobjects = {
--       select = {
--         enable = true,
--         lookahead = true,
--         kahead = true,
--         selection_modes = {
--           ['@parameter.outer'] = 'v', -- charwise
--           ['@function.outer'] = 'V', -- linewise
--           ['@class.outer'] = '<c-v>', -- blockwise
--         },
--         keymaps = {
--
--           ['aa'] = { query = '@parameter.outer', desc = '🌲select around function' },
--           ['ia'] = { query = '@parameter.inner', desc = '🌲select inside function' },
--
--           ['af'] = { query = '@function.outer', desc = '🌲select around function' },
--           ['if'] = { query = '@function.inner', desc = '🌲select inside function' },
--           ['ac'] = { query = '@class.outer', desc = '🌲select around class' },
--           ['ic'] = { query = '@class.inner', desc = '🌲select inside class' },
--           ['al'] = { query = '@loop.outer', desc = '🌲select around loop' },
--           ['il'] = { query = '@loop.inner', desc = '🌲select inside loop' },
--           ['ab'] = { query = '@block.outer', desc = '🌲select around block' },
--           ['ib'] = { query = '@block.inner', desc = '🌲select inside block' },
--         },
--       },
--       move = {
--         enable = true,
--         set_jumps = true,
--         goto_next_start = {
--         },
--         goto_previous_start = {
--         },
--       },
--       lsp_interop = {
--         enable = true,
--         border = 'rounded',
--         peek_definition_code = {
--         },
--       },
--     },
--   },
--   config = function(_, opts)
--     vim.filetype.add {
--       extension = { rasi = 'rasi' },
--       pattern = {
--         ['.*/waybar/config'] = 'jsonc',
--         ['.*/mako/config'] = 'dosini',
--         ['.*/kitty/*.conf'] = 'bash',
--         ['.*/hypr/.*%.conf'] = 'hyprlang',
--       },
--     }
--
--     ---@diagnostic disable-next-line: missing-fields
--     require('nvim-treesitter.configs').setup(opts)
--   end,
-- }
