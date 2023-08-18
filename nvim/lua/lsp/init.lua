MAX_FILE_SIZE = 100 * 1024 -- 100 KB

require('lsp.treesetter')
require('lsp.mason')
require('lsp.auto-complete')

-- local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   callback = function()
--     vim.highlight.on_yank()
--   end,
--   group = highlight_group,
--   pattern = '*',
-- })
