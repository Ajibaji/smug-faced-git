local sidebar = require("sidebar-nvim")

sidebar.setup({
		disable_default_keybindings = 0,
    bindings = nil,
    open = false,
    side = "left",
    initial_width = 40,
    hide_statusline = false,
    update_interval = 50,
    --sections = { "datetime", "buffers", "diagnostics", "git" },
    sections = { "datetime", "buffers", "diagnostics" },
    section_separator = { "" },
    section_title_separator = {},
    containers = {
        attach_shell = "/bin/sh", show_all = true, interval = 5000,
    },
    datetime = {
      format = "%a %b %d, %H:%M",
      clocks = {
        { name = "local" }
      }
    },
    todos = { ignored_paths = { "~" } },
    buffers = {
        ignored_buffers = {
					'nvim-tree',
					'SidebarNvim',
          'toggleterm'
				}, -- ignore buffers by regex
        sorting = "id", -- alternatively set it to "name" to sort by buffer name instead of buf id
        show_numbers = false, -- whether to also show the buffer numbers
        ignore_not_loaded = true, -- whether to ignore not loaded buffers
        ignore_terminal = false, -- whether to show terminal buffers in the list
    },
    files = {
    	icon = "",
    	show_hidden = true,
    	ignored_paths = {"%.git$"}
    }
})

