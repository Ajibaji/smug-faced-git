return {
  -- { -- You can easily change to a different colorscheme.
  --   -- Change the name of the colorscheme plugin below, and then
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   opts = {
  --     style = 'storm',
  --     light_style = 'day',
  --     transparent = true,
  --     styles = {
  --       comments = { italic = true },
  --       -- Background styles. Can be "dark", "transparent" or "normal"
  --       sidebars = 'normal', -- style for sidebars, see below
  --       floats = 'normal', -- style for floating windows
  --     },
  --   },
  --   init = function()
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme('tokyonight')
  --
  --     -- You can configure highlights by doing something like:
  --     -- vim.cmd.hi('Comment gui=none')
  --
  --     -- custom colours
  --   end,
  -- },
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  opts = {
    flavour = 'auto', -- latte, frappe, macchiato, mocha
    background = { -- :h background
      light = 'latte',
      dark = 'frappe',
    },
    transparent_background = false, -- disables setting the background color.
    float = {
      transparent = false, -- enable transparent floating windows
      solid = vim.g.neovide, -- use solid styling for floating windows, see |winborder|
    },
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = 'dark',
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { 'italic' }, -- Change the style of comments
      conditionals = { 'italic' },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
      -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
      virtual_text = {
        errors = { 'italic' },
        hints = { 'italic' },
        warnings = { 'italic' },
        information = { 'italic' },
        ok = { 'italic' },
      },
      underlines = {
        errors = { 'underline' },
        hints = { 'underline' },
        warnings = { 'underline' },
        information = { 'underline' },
        ok = { 'underline' },
      },
      inlay_hints = {
        background = true,
      },
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    auto_integrations = true,
  },
  init = function()
    vim.cmd.colorscheme('catppuccin-nvim')
  end,
}
