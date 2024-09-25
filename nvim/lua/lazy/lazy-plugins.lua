require('lazy').setup({
  -- {
  --   'tpope/vim-sleuth',
  --   event = 'VimEnter',
  -- },
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
  utils.RequireDir 'plugins/lsp',
  utils.RequireDir 'plugins/visual',
  utils.RequireDir 'plugins/flow',

}, {
  defaults = {
    lazy = true,
    version = nil,
    cond = nil, ---@type boolean|fun(self:LazyPlugin):boolean|nil
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
