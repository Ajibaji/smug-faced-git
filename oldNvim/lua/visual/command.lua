return {
  'VonHeikemen/fine-cmdline.nvim',
  lazy = false,
  priority = 999,
  dependencies = {
    'MunifTanjim/nui.nvim'
  },
  keys = {
    { ":", "<cmd>FineCmdline<CR>", desc = "FineCmdLine" },
  },
  config = function()
    require('fine-cmdline').setup({
      cmdline = {
        enable_keymaps = true,
        smart_history = true,
        prompt = ': '
      },
      popup = {
        position = {
          row = '70%',
          col = '50%',
        },
        size = {
          width = '40%',
        },
        border = {
          style = 'rounded',
          text = {
            top = "COMMAND",
            top_align = "left",
         },
        },
        relative = "editor",
        win_options = {
          winblend = 10,
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
      },
      hooks = {
        before_mount = function(input)
          -- code
        end,
        after_mount = function(input)
          -- code
        end,
        set_keymaps = function(imap, feedkeys)
          -- code
        end
      }
    })
  end,
}

--local event = require("nui.utils.autocmd").event
--popup:on({ event.BufLeave }, function()
--  popup:unmount()
--end, { once = true })
