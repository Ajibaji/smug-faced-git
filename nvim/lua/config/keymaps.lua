require '/utils'

local map = vim.api.nvim_set_keymap
local opts = {
  noremap = true,
  silent = true,
}

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

function OpenTerminalHere()
  local command = 'ToggleTerm dir=%:h'
  -- local command = string.format('ToggleTerm dir=%s', currentBuffPath)
  vim.cmd(command)
end

map('n', '<c-§>', ':lua OpenTerminalHere()<CR>', opts)
map('n', '<A-\\>', ':lua OpenTerminalHere()<CR>', opts)

--> Other:
-- map('n', '<A-]>', ":lua require('goto-preview').goto_preview_definition()<CR>", opts)
map('n', '<A-[>', ':close<CR>', opts)
map('n', '<leader><leader>', '<C-w>L', opts) --move floating window to split-right
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
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

local function compare_to_clipboard()
  local ftype = vim.api.nvim_eval '&filetype'
  vim.cmd(string.format(
    [[
    execute "normal! \"xy"
    vsplit
    enew
    normal! P
    setlocal buftype=nowrite
    set filetype=%s
    diffthis
    execute "normal! \<C-w>\<C-w>"
    enew
    set filetype=%s
    normal! "xP
    diffthis
  ]],
    ftype,
    ftype
  ))
end

vim.keymap.set('n', '<Space>d', compare_to_clipboard)

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
