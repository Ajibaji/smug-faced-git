vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
-- vim.g.neovide_input_use_logo = 1
vim.g.neovide_theme = 'auto'
-- vim.g.neovide_opacity = 0.8
vim.g.neovide_opacity = 0.9
vim.g.neovide_normal_opacity = 0.9
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 10.0
vim.g.neovide_floating_blur_amount_y = 10.0
vim.g.neovide_show_border = false

vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

vim.g.neovide_scroll_animation_length = 0.3
-- vim.g.neovide_scroll_animation_length = 0 -- stops the jittery winbar scrolling issue
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_underline_automatic_scaling = false
vim.g.neovide_refresh_rate_idle = 5

vim.g.neovide_touch_deadzone = 6.0
vim.g.neovide_touch_drag_timeout = 0.17

vim.g.neovide_cursor_animation_length = 0.06
vim.g.neovide_cursor_trail_size = 0.6
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true

vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_profiler = false

vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

vim.g.neovide_scale_factor = 1.186565625
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set('n', '<C-=>', function()
  change_scale_factor(1.05)
end)
vim.keymap.set('n', '<C-->', function()
  change_scale_factor(1 / 1.05)
end)
