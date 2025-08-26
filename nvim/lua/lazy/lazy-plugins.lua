require('lazy').setup({
  -- {
  --   'tpope/vim-sleuth',
  --   event = 'VimEnter',
  -- },
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  utils.RequireDir('plugins/lsp'),
  utils.RequireDir('plugins/visual'),
  utils.RequireDir('plugins/flow'),
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
