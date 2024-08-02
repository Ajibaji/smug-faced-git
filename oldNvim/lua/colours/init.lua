return {
  'EdenEast/nightfox.nvim',
  lazy = false,
  priority = 1000,
  build = ':NightfoxCompile',
  config = function()
    require('nightfox').setup({
      options = {
        compile_path = vim.fn.stdpath("cache") .. "/nightfox", -- Compiled file's destination location
        compile_file_suffix = "_compiled", -- Compiled file suffix
        transparent = false,    -- Disable setting background
        terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
        dim_inactive = true,   -- Non focused panes set to alternative background
        styles = {              -- Style to be applied to different syntax groups
          comments = "italic",    -- Value is any valid attr-list value `:help attr-list`
          conditionals = "NONE",
          constants = "NONE",
          functions = "NONE",
          keywords = "NONE",
          numbers = "NONE",
          operators = "NONE",
          strings = "NONE",
          types = "NONE",
          variables = "NONE",
        },
        inverse = {             -- Inverse highlight for different types
          match_paren = false,
          visual = false,
          search = false,
        },
        modules = {             -- List of various plugins and additional options
          cmp = true,
          dashboard = true,
          diagnostic = true,
          gitsigns = false,
          illuminate = true,
          indent_blanklines = true,
          modes = true,
          native_lsp = true,
          navic = true,
          notify = true,
          nvimtree = true,
          telescope = true,
          treesitter = true,
        },
      }
    })
    vim.cmd("colorscheme nightfox")
  end,
}
