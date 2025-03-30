local copilot_auto_trigger = true

local function toggle_copilot_suggestions()
  local suggestion = require("copilot.suggestion")
  suggestion.toggle_auto_trigger()

  copilot_auto_trigger = not copilot_auto_trigger

  if copilot_auto_trigger then
    vim.notify("✅ Copilot Auto-Trigger: ON", vim.log.levels.INFO)
  else
    vim.notify("⛔ Copilot Auto-Trigger: OFF", vim.log.levels.WARN)
  end
end

return {
  {
    -- copilot
    "zbirenbaum/copilot.lua",
    -- cond = vim.g.ai_cmp == nil and true or vim.g.ai_cmp,
    cmd = "Copilot",
    build = ":Copilot auth",
    -- event = "BufReadPost",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = "<C-Right>", -- handled by nvim-cmp / blink.cmp
          accept_word = false,
          accept_line = false,
          next = "<C-Up",
          prev = "<C-Down",
          dismiss = "<C-Left>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },
        layout = {
          position = "right", -- | top | left | right | horizontal | vertical
          ratio = 0.4
        },
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    keys = {
      { "<leader>Ce", toggle_copilot_suggestions,                                     desc = "Toggle Auto-Suggestions" },
      -- map("i", "<C-Space>", '<cmd>lua require("copilot.suggestion").toggle_auto_trigger()<CR>', { desc = "Toggle Auto-Trigger (Insert Mode)" })
      { "<leader>Cp", function() require("copilot.panel").open({ "right", 0.4 }) end, desc = "Open Panel" },
      { "<leader>Cs", "<cmd>Copilot status<CR>",                                      desc = "Status" }
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = function()
      -- Definindo os autocomandos para ocultar sugestões quando o blink.cmp abre
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  }
}
