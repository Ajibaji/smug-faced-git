-- vim.cmd([[
-- augroup cdpwd
--     autocmd!
--     autocmd VimEnter * cd %:h
-- augroup END
-- ]])

local path = vim.fn.expand("%:p:h")
vim.api.nvim_set_current_dir(path)

require('settings')
require('plugins')
--require('flow')
--require('colours.nightfox')
--require('mappings')
----require('git.git-diff')
--require('git.git-signs')
--require('visual')
--require('lsp')

--vim.opt.cursorline = true
--vim.opt.cursorcolumn = false
-- jeff
