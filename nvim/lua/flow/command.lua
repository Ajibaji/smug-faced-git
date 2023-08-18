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
      style = 'double',
  		text = {
    		top = "COMMAND",
    		top_align = "left",
  		},
    },
		relative = "editor",
    win_options = {
	    winblend = 10,
      winhighlight = 'Normal:NormalFloat,FloatBorder:Italic',
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

--local event = require("nui.utils.autocmd").event
--popup:on({ event.BufLeave }, function()
--  popup:unmount()
--end, { once = true })
