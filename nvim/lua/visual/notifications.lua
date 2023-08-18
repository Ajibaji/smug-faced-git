local stages_util = require("notify.stages.util")

require("notify").setup({
  stages = {
    function(state)
      local next_height = state.message.height + 2
      local next_row =
          stages_util.available_slot(state.open_windows, next_height, stages_util.DIRECTION.BOTTOM_UP)
      if not next_row then
        return nil
      end
      return {
        relative = "editor",
        anchor = "NE",
        --width = state.message.width,
        width = 1,
        height = state.message.height,
        col = vim.opt.columns:get(),
        row = next_row,
        border = "rounded",
        style = "minimal",
      }
    end,
    function(state)
      return {
        --opacity = { 100 },
        width = { state.message.width, frequency = 2 },
        col = { vim.opt.columns:get() },
      }
    end,
    function()
      return {
        col = { vim.opt.columns:get() },
        time = true,
      }
    end,
    function()
      return {
        width = {
          1,
          frequency = 2.5,
          damping = 0.9,
          complete = function(cur_width)
            --return cur_width < 3
            return cur_width < 2
          end,
        },
        -- opacity = {
        --  0,
        --  frequency = 2,
        --  complete = function(cur_opacity)
        --    return cur_opacity <= 4
        --  end,
        -- },
        col = { vim.opt.columns:get() },
      }
    end,
  },
})

vim.notify = require('notify')

require("telescope").load_extension("notify")

-- -- Utility functions shared between progress reports for LSP and DAP
--
-- local client_notifs = {}
--
-- local function get_notif_data(client_id, token)
--   if not client_notifs[client_id] then
--     client_notifs[client_id] = {}
--   end
--
--   if not client_notifs[client_id][token] then
--     client_notifs[client_id][token] = {}
--   end
--
--   return client_notifs[client_id][token]
-- end
--
-- local spinner_frames = {
--   "( ●    )",
--   "(  ●   )",
--   "(   ●  )",
--   "(    ● )",
--   "(     ●)",
--   "(    ● )",
--   "(   ●  )",
--   "(  ●   )",
--   "( ●    )",
--   "(●     )",
-- }
--
-- local function update_spinner(client_id, token)
--   local notif_data = get_notif_data(client_id, token)
--
--   if notif_data.spinner then
--     local new_spinner = (notif_data.spinner + 1) % #spinner_frames
--     notif_data.spinner = new_spinner
--
--     notif_data.notification = vim.notify(nil, nil, {
--       hide_from_history = true,
--       icon = spinner_frames[new_spinner],
--       replace = notif_data.notification,
--     })
--
--     vim.defer_fn(function()
--       update_spinner(client_id, token)
--     end, 100)
--   end
-- end
--
-- local function format_title(title, client_name)
--   return client_name .. (#title > 0 and ": " .. title or "")
-- end
--
-- local function format_message(message, percentage)
--   return (percentage and percentage .. "%\t" or "") .. (message or "")
-- end
--
-- -- -- LSP integration
-- -- -- Make sure to also have the snippet with the common helper functions in your config!
--
-- -- vim.lsp.handlers["$/progress"] = function(_, result, ctx)
-- --   local client_id = ctx.client_id
-- --
-- --   local val = result.value
-- --
-- --   if not val.kind then
-- --     return
-- --   end
-- --
-- --   local notif_data = get_notif_data(client_id, result.token)
-- --
-- --   if val.kind == "begin" then
-- --     local message = format_message(val.message, val.percentage)
-- --
-- --     notif_data.notification = vim.notify(message, "info", {
-- --       title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
-- --       icon = spinner_frames[1],
-- --       timeout = false,
-- --       hide_from_history = false,
-- --     })
-- --
-- --     notif_data.spinner = 1
-- --     update_spinner(client_id, result.token)
-- --   elseif val.kind == "report" and notif_data then
-- --     notif_data.notification = vim.notify(format_message(val.message, val.percentage), "info", {
-- --       replace = notif_data.notification,
-- --       hide_from_history = false,
-- --     })
-- --   elseif val.kind == "end" and notif_data then
-- --     notif_data.notification =
-- --         vim.notify(val.message and format_message(val.message) or "Complete", "info", {
-- --           icon = "",
-- --           replace = notif_data.notification,
-- --           timeout = 3000,
-- --         })
-- --
-- --     notif_data.spinner = nil
-- --   end
-- -- end
--
-- -- -- table from lsp severity to vim severity.
-- -- local severity = {
-- --   "error",
-- --   "warn",
-- --   "info",
-- --   "info", -- map both hint and info to info?
-- -- }
-- -- vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
-- --   vim.notify(method.message, severity[params.type])
-- -- end

