return {
  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   event = 'BufReadPre',
  --   build = ':TSUpdate',
  --   opts = {
  --     -- ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'rust', 'javascript', 'json' },
  --     auto_install = true,
  --     highlight = {
  --       enable = true,
  --     },
  --     indent = { enable = true, disable = { 'ruby' } },
  --   },
  --   config = function(_, opts)
  --     -- Prefer git instead of curl in order to improve connectivity in some environments
  --     require('nvim-treesitter.install').prefer_git = true
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('nvim-treesitter.configs').setup(opts)
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = function()
      local TS = require("nvim-treesitter")
      TS.update(nil, { summary = true })
    end,
    event = { "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
      ensure_installed = {
        "bash",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter")
      TS.setup(opts)
    end,
  }
}
