local M = {}
local icons = require('utils.icons')

function M.is_active()
  local ok, hydra = pcall(require, 'hydra.statusline')
  return ok and hydra.is_active()
end

function M.get_name()
  local ok, hydra = pcall(require, 'hydra.statusline')
  if ok then
    -- return hydra.get_name()
    return icons.ui.Cursor
  end
  return ''
end

-- M.getLspClients = function()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local ft = vim.bo[bufnr].filetype
--   -- local active_clients = vim.lsp.get_active_clients({ bufnr = bufnr })
--   local active_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
--   local client_names = {}
--
--   for _, client in ipairs(active_clients) do
--     if client and client.name ~= "" then
--       -- Se o cliente definir quais filetypes ele atende, filtra pelo filetype atual.
--       if client.config and client.config.filetypes then
--         local supports_ft = false
--         for _, t in ipairs(client.config.filetypes) do
--           if t == ft then
--             supports_ft = true
--             break
--           end
--         end
--         if not supports_ft then
--           goto continue  -- pula para o próximo cliente
--         end
--       end
--
--       if client.name == "copilot" then
--         table.insert(client_names, icons.git.Octoface)
--       elseif client.name == "cmp_tabnine" then
--         table.insert(client_names, icons.misc.Tabnine)  -- certifique-se de ter definido esse ícone
--       else
--         table.insert(client_names, "[" .. client.name .. "]")
--       end
--     end
--     ::continue::
--   end
--
--   return table.concat(client_names, " ")
-- end

function M.getLspClients()
  return require('lsp-progress').progress({
    -- format = function(messages)
    format = function()
      -- local active_clients = vim.lsp.get_active_clients()
      -- local active_clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })  --deprecated in v0.10.0
      local active_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
      -- if #messages > 0 then
      --   -- return ' LSP:' .. table.concat(messages, ' ')
      --   return table.concat(messages, ' ')
      -- end
      local client_names = {}
      for _, client in ipairs(active_clients) do
        if client and client.name ~= '' then
          if client.name == 'copilot' then
            table.insert(client_names, icons.git.Octoface)
          else
            table.insert(client_names, '[' .. client.name .. ']')
          end
        end
      end
      -- return ' LSP:' .. table.concat(client_names, ' ')
      return table.concat(client_names, ' ')
    end,
  })
end

function M.diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

-- local copilot = function(_, opts)
--   local Util = require("lazyvim.util")
--   local colors = {
--     [""] = Util.ui.fg("Special"),
--     ["Normal"] = Util.ui.fg("Special"),
--     ["Warning"] = Util.ui.fg("DiagnosticError"),
--     ["InProgress"] = Util.ui.fg("DiagnosticWarn"),
--   }
--   table.insert(opts.sections.lualine_x, 2, {
--     function()
--       local icon = require("lazyvim.config").icons.kinds.Copilot
--       local status = require("copilot.api").status.data
--       return icon .. (status.message or "")
--     end,
--     cond = function()
--       if not package.loaded["copilot"] then
--         return
--       end
--       local ok, clients = pcall(require("lazyvim.util").lsp.get_clients, { name = "copilot", bufnr = 0 })
--       if not ok then
--         return false
--       end
--       return ok and #clients > 0
--     end,
--     color = function()
--       if not package.loaded["copilot"] then
--         return
--       end
--       local status = require("copilot.api").status.data
--       return colors[status.status] or colors[""]
--     end,
--   })
-- end

-- local function overseer()
-- return {
--         "overseer",
--         label = "", -- Prefix for task counts
--         colored = true, -- Color the task icons and counts
--         symbols = {
--           [overseer.STATUS.FAILURE] = "F:",
--           [overseer.STATUS.CANCELED] = "C:",
--           [overseer.STATUS.SUCCESS] = "S:",
--           [overseer.STATUS.RUNNING] = "R:",
--         },
--         unique = false, -- Unique-ify non-running task count by name
--         name = nil, -- List of task names to search for
--         name_not = false, -- When true, invert the name search
--         status = nil, -- List of task statuses to display
--         status_not = false, -- When true, invert the status search
--       }
-- end

return M
