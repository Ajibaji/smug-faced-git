return {
  {
    'LuxVim/nvim-luxmotion',
    event = 'BufReadPre',
    cond = not vim.g.neovide,
    config = function()
      require('luxmotion').setup({
        cursor = {
          duration = 250,
          easing = 'ease-out',
          enabled = true,
        },
        scroll = {
          duration = 400,
          easing = 'ease-out',
          enabled = true,
        },
        performance = { enabled = true },
        keymaps = {
          cursor = true,
          scroll = true,
        },
      })
    end,
  },
  {
    'lewis6991/satellite.nvim',
    event = 'BufReadPre',
    config = function()
      require('satellite').setup({
        current_only = true,
        winblend = 50,
        zindex = 40,
        excluded_filetypes = {},
        width = 1,
        handlers = {
          cursor = {
            enable = true,
            overlap = true,
            priority = 100,
            symbols = { '⎺', '⎻', '⎼', '⎽' },
          },
          search = {
            enable = true,
          },
          diagnostic = {
            enable = true,
            signs = { '-', '=', '≡' },
            min_severity = vim.diagnostic.severity.HINT,
          },
          gitsigns = {
            enable = true,
            signs = { -- can only be a single character (multibyte is okay)
              add = '│',
              change = '│',
              delete = '-',
            },
          },
          marks = {
            enable = false,
            show_builtins = false, -- shows the builtin marks like [ ] < >
            key = 'm',
          },
          quickfix = {
            enable = true,
            overlap = true,
            priority = 50,
            signs = { '-', '=', '≡' },
          },
        },
      })
    end,
  },
}
