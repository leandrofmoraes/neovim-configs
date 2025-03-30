return {
  "olimorris/codecompanion.nvim",
  enabled = false,
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "copilot",
      },
      cmd = {
        adapter = "deepseek",
      }
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ",                   -- Prompt used for interactive LLM calls
        provider = "default",                 -- default|telescope|mini_pick
        opts = {
          show_default_actions = true,        -- Show the default actions in the action palette?
          show_default_prompt_library = true, -- Show the default prompt library in the action palette?
        },
      },
    },
  },
}
