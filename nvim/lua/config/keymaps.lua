local map = vim.api.nvim_set_keymap
local opts = {
  noremap = true,
  silent = true,
}

-- Search
vim.opt.hlsearch = true
vim.keymap.set('n', '<A-/>', '<cmd>nohlsearch<CR>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

--> Other:
map('n', '<A-]>', ":lua require('goto-preview').goto_preview_definition()<CR>", opts)
map('n', '<A-[>', ':close<CR>', opts)
map('n', '<leader><leader><leader>', '<C-w>L', opts) --move floating window to split-right
map('n', '<leader><left>', '<C-W>h', opts)
map('n', '<leader><right>', '<C-W>l', opts)
map('n', '<leader><up>', '<C-W>k', opts)
map('n', '<leader><down>', '<C-W>j', opts)

--> buffer mappings
map('n', '<A-,>', ':bprev<CR>', opts)
map('n', '≤', ':bprev<CR>', opts)
map('n', '<A-.>', ':bnext<CR>', opts)
map('n', '≥', ':bnext<CR>', opts)
-- map('n', '<A-c>', ":lua require('bufdelete').bufwipeout(0)<CR>", opts)
-- map('n', 'ç', ":lua require('bufdelete').bufwipeout(0)<CR>", opts)

--Add move line shortcuts
map('n', '<A-j>', ':m .+1<CR>==', opts)
map('n', '∆', ':m .+1<CR>==', opts)
map('n', '<A-k>', ':m .-2<CR>==', opts)
map('n', '˚', ':m .-2<CR>==', opts)
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', opts)
map('i', '∆', '<Esc>:m .+1<CR>==gi', opts)
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', opts)
map('i', '˚', '<Esc>:m .-2<CR>==gi', opts)
map('v', '<A-j>', ":m '>+1<CR>gv=gv", opts)
map('v', '∆', ":m '>+1<CR>gv=gv", opts)
map('v', '<A-k>', ":m '<-2<CR>gv=gv", opts)
map('v', '˚', ":m '<-2<CR>gv=gv", opts)

vim.keymap.set('n', '<Space>d', utils.compare_to_clipboard)
