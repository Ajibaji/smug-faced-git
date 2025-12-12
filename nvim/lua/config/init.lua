require 'config.constants'
require 'config.autocommands'
require 'config.options'
require 'config.keymaps'

CURRENT_THEME = string.lower(os.getenv('CURRENT_THEME') or 'DARK')
