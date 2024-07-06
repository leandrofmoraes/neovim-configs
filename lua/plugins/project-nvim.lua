local M = {
  -- enabled = false,
  'ahmedkhalf/project.nvim',
  event = "VimEnter",
  -- event = "VeryLazy",
}
function M.config()
  require("project_nvim").settup = {
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true
    },
    {
      ---@usage set to true to disable setting the current-woriking directory
      --- Manual mode doesn't automatically change your root directory, so you have
      --- the option to manually do so using `:ProjectRoot` command.
      -- manual_mode = true,
      manual_mode = false,

      ---@usage Methods of detecting the root directory
      --- Allowed values: **"lsp"** uses the native neovim lsp
      --- **"pattern"** uses vim-rooter like glob pattern matching. Here
      --- order matters: if one is not detected, the other is used as fallback. You
      --- can also delete or rearangne the detection methods.
      -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
      detection_methods = { "pattern" },

      -- All the patterns used to detect root dir, when **"pattern"** is in
      -- detection_methods
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", 'angular.json', "pom.xml" },

      -- Table of lsp clients to ignore by name
      -- eg: { "efm", ... }
      ignore_lsp = {},

      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = {},

      -- Show hidden files in telescope
      -- show_hidden = true,
      show_hidden = false,

      -- When set to false, you will get a message when project.nvim changes your
      -- directory.
      -- silent_chdir = false,
      silent_chdir = true,

      -- What scope to change the directory, valid options are
      -- * global (default)
      -- * tab
      -- * win
      scope_chdir = 'global',

      -- Path where project.nvim will store the project history for use in
      -- telescope
      -- datapath = vim.fn.stdpath("data"),

      ---@type string
      ---@usage path to store the project history for use in telescope
      -- datapath = get_cache_dir(),
      datapath = vim.call("stdpath", "cache")
    }
  }
end

return M
