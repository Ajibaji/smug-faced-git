vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})

vim.cmd([[
FVimCursorSmoothMove v:true
FVimCursorSmoothBlink v:true
FVimBackgroundComposition 'acrylic'
FVimBackgroundOpacity 0.85
FVimBackgroundAltOpacity 0.85
FVimCustomTitleBar v:true 
FVimFontAntialias v:true
FVimFontAutohint v:true
FVimFontHintLevel 'full'
FVimFontLigature v:true
FVimFontLineHeight '+1.0'
FVimFontSubpixel v:true
FVimFontNoBuiltinSymbols v:true
FVimFontAutoSnap v:true
FVimUIPopupMenu v:true
]])
