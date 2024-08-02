--local colors = require("nightfox.palette").load()

-- require('hlslens').setup({
--   auto_enable = true,
--   calm_down = true,
--   nearest_only = false,
--   nearest_float_when = 'auto',
--   enable_incsearch = true,
--   build_position_cb = function(plist, _, _, _)
--     require("scrollbar.handlers.search").handler.show(plist.start_pos)
--   end
-- })

--require("scrollbar").setup({
--    handle = {
--        color = colors.bg_highlight,
--    },
--    marks = {
--        Search = { color = colors.orange },
--        Error = { color = colors.error },
--        Warn = { color = colors.warning },
--        Info = { color = colors.info },
--        Hint = { color = colors.hint },
--        Misc = { color = colors.purple },
--    },
--    handlers = {
--        diagnostic = true,
--        search = true, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
--    },
--})

-- return {
--   'petertriho/nvim-scrollbar',
--   lazy = false,
--   priority = 999,
--   config = function()
--     require("scrollbar").setup({
--       show = true,
--       show_in_active_only = false,
--       set_highlights = true,
--       folds = 1000,                 -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
--       max_lines = false,            -- disables if no. of lines in buffer exceeds this
--       hide_if_all_visible = true,   -- Hides everything if all lines are visible
--       throttle_ms = 100,
--       handle = {
--         text = " ",
--         blend = 30,                     -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
--         color = nil,
--         color_nr = nil,                 -- cterm
--         highlight = "CursorColumn",
--         hide_if_all_visible = true,     -- Hides handle if all lines are visible
--       },
--       marks = {
--         Cursor = {
--           text = "•",
--           priority = 0,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil,       -- cterm
--           highlight = "Normal",
--         },
--         Search = {
--           text = { "-", "=" },
--           priority = 1,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil,       -- cterm
--           highlight = "Search",
--         },
--         Error = {
--           text = { "-", "=" },
--           priority = 2,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil,       -- cterm
--           highlight = "DiagnosticVirtualTextError",
--         },
--         Warn = {
--           text = { "-", "=" },
--           priority = 3,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil,       -- cterm
--           highlight = "DiagnosticVirtualTextWarn",
--         },
--         Info = {
--           text = { "-", "=" },
--           priority = 4,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil,       -- cterm
--           highlight = "DiagnosticVirtualTextInfo",
--         },
--         Hint = {
--           text = { "-", "=" },
--           priority = 5,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil,       -- cterm
--           highlight = "DiagnosticVirtualTextHint",
--         },
--         Misc = {
--           text = { "-", "=" },
--           priority = 6,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil,       -- cterm
--           highlight = "Normal",
--         },
--         --GitAdd = {
--         --  text = "┆",
--         --  priority = 7,
--         --  gui = nil,
--         --  color = nil,
--         --  cterm = nil,
--         --  color_nr = nil,       -- cterm
--         --  highlight = "GitSignsAdd",
--         --},
--         --GitChange = {
--         --  text = "┆",
--         --  priority = 7,
--         --  gui = nil,
--         --  color = nil,
--         --  cterm = nil,
--         --  color_nr = nil,       -- cterm
--         --  highlight = "GitSignsChange",
--         --},
--         --GitDelete = {
--         --  text = "▁",
--         --  priority = 7,
--         --  gui = nil,
--         --  color = nil,
--         --  cterm = nil,
--         --  color_nr = nil,       -- cterm
--         --  highlight = "GitSignsDelete",
--         --},
--       },
--       excluded_buftypes = {
--         "terminal",
--       },
--       excluded_filetypes = {
--         "cmp_docs",
--         "cmp_menu",
--         "noice",
--         "prompt",
--         "TelescopePrompt",
--       },
--       autocmd = {
--         render = {
--           "BufWinEnter",
--           "TabEnter",
--           "TermEnter",
--           "WinEnter",
--           "CmdwinLeave",
--           "TextChanged",
--           "VimResized",
--           "WinScrolled",
--         },
--         clear = {
--           "BufWinLeave",
--           "TabLeave",
--           "TermLeave",
--           "WinLeave",
--         },
--       },
--       handlers = {
--         cursor = true,
--         diagnostic = true,
--         gitsigns = false,     -- Requires gitsigns
--         handle = true,
--         search = true,        -- Requires hlslens
--       },
--     })
--   end,
-- }

if not vim.g.neovide then
  return {
    'karb94/neoscroll.nvim',
    event = "VeryLazy",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,            -- Hide cursor while scrolling
        stop_eof = true,               -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false,   -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false,     -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true,   -- The cursor will keep on scrolling even if the window cannot scroll further
        performance_mode = false,      -- Disable "Performance Mode" on all buffers.
      })
    end
  }
else
  return {}
end
