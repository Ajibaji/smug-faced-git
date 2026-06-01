require 'config.constants'
require 'config.autocommands'
require 'config.options'
require 'config.keymaps'

CURRENT_THEME = os.getenv('CURRENT_THEME') or 'DARK'
LG_CONFIG_FILE = os.getenv('LG_CONFIG_FILE') or '~/.config/lazygit/DARK-config.yml'
BAT_THEME = os.getenv('BAT_THEME') or 'Catppuccin Frappe'

vim.env.LG_CONFIG_FILE = LG_CONFIG_FILE
vim.env.CURRENT_THEME = CURRENT_THEME
vim.env.BAT_THEME = BAT_THEME

vim.g.LG_CONFIG_FILE = LG_CONFIG_FILE
vim.g.CURRENT_THEME = CURRENT_THEME
vim.g.BAT_THEME = BAT_THEME
