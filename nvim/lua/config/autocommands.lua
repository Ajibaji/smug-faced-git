-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('ammar-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
--  command = "if mode() != 'c' | checktime | endif",
--  pattern = { "*" },
--})

-- auto-reload kitty on editing kitty.conf
--vim.api.nvim_create_autocmd(
--  {
--    "bufwritepost"
--  },
--  {
--    pattern = vim.fn.expand("~").."/.config/kitty/*",
--    command = "silent !kill -SIGUSR1 $(pgrep -a kitty)"
--  }
--)

vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Automatically resize all windows on VimResize event',
  command = 'wincmd =',
})

-- show diagnostics float on hover
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  desc = "show diagnostics float on hover",
  pattern = '*',
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float({
      scope = 'cursor',
      focusable = false,
      close_events = {
        'CursorMoved',
        'CursorMovedI',
        'BufHidden',
        'InsertCharPre',
        'WinLeave',
      },
    })
  end,
})
