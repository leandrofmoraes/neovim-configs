---@class snacks.toggle.Config
---@field icon? string|{ enabled: string, disabled: string }
---@field color? string|{ enabled: string, disabled: string }
---@field wk_desc? string|{ enabled: string, disabled: string }
---@field map? fun(mode: string|string[], lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts)
---@field which_key? boolean
---@field notify? boolean
return {
  map = vim.keymap.set, -- keymap.set function to use
  which_key = true,     -- integrate with which-key to show enabled/disabled icons and colors
  notify = true,        -- show a notification when toggling
  -- icons for enabled/disabled states
  icon = {
    enabled = " ",
    disabled = " ",
  },
  -- colors for enabled/disabled states
  color = {
    enabled = "green",
    disabled = "yellow",
  },
  wk_desc = {
    enabled = "Disable ",
    disabled = "Enable ",
  },
}

-- Snacks.toggle()
-- ---@type fun(... :snacks.toggle.Opts): snacks.toggle.Class
-- Snacks.toggle()
-- Snacks.toggle.animate()
-- Snacks.toggle.diagnostics()
-- ---@param opts? snacks.toggle.Config
-- Snacks.toggle.diagnostics(opts)
-- Snacks.toggle.dim()
-- Snacks.toggle.get()
-- ---@param id string
-- ---@return snacks.toggle.Class?
-- Snacks.toggle.get(id)
-- Snacks.toggle.indent()
-- Snacks.toggle.inlay_hints()
-- ---@param opts? snacks.toggle.Config
-- Snacks.toggle.inlay_hints(opts)
-- Snacks.toggle.line_number()
-- ---@param opts? snacks.toggle.Config
-- Snacks.toggle.line_number(opts)
-- Snacks.toggle.new()
-- ---@param ... snacks.toggle.Opts
-- Snacks.toggle.new(...)
-- Snacks.toggle.option()
-- ---@param option string
-- ---@param opts? snacks.toggle.Config | {on?: unknown, off?: unknown, global?: boolean}
-- Snacks.toggle.option(option, opts)
-- Snacks.toggle.profiler()
-- Snacks.toggle.profiler_highlights()
-- Snacks.toggle.scroll()
-- Snacks.toggle.treesitter()
-- ---@param opts? snacks.toggle.Config
-- Snacks.toggle.treesitter(opts)
-- Snacks.toggle.words()
-- Snacks.toggle.zen()
-- Snacks.toggle.zoom()
