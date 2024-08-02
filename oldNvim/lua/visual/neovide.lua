-- Helper function for transparency formatting
local alpha = function()
  return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
end
-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
vim.g.neovide_transparency = 0.9
vim.g.transparency = 0.9
-- vim.g.neovide_background_color = "#0f1117" .. alpha()
-- vim.g.neovide_background_color = "#0f1117"
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
vim.g.neovide_scroll_animation_length = 0.3
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_underline_automatic_scaling = false
vim.g.neovide_theme = 'auto'
vim.g.neovide_refresh_rate_idle = 5
-- vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_touch_deadzone = 6.0
vim.g.neovide_touch_drag_timeout = 0.17
vim.g.neovide_cursor_trail_size = 0.8
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_profiler = false


--vim.g.neovide_window_position_animation_length = 0.0
--vim.g.neovide_window_floating_opacity = 0.5
--vim.g.neovide_floating_opacity = 0.2
--vim.g.neovide_transparency=0.8
--vim.g.neovide_floating_blur_amount_x = 2.0
--vim.g.neovide_floating_blur_amount_y = 2.0
-- vim.opt.guifont = 'FiraCode Nerd Font:h9'

-- vim.g.neovide_input_macos_alt_is_meta=true
vim.g.neovide_cursor_animation_length=0.03
vim.g.neovide_input_use_logo = 1
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
