local map = vim.api.nvim_set_keymap
local opts = {
    noremap = true,
    silent = true
}

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
--vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

function OpenFileInNewKittyWindow()
  local currentBuffPath = vim.fn.expand('%:p')
  local line, column = unpack(vim.api.nvim_win_get_cursor(0))
  local command = string.format('kitty @ launch --type os-window --keep-focus --cwd current nvim +%s %s -n', line,
          currentBuffPath)
  require('bufdelete').bufwipeout(0)
  vim.fn.system(command)
  --vim.fn.system('kitty @ focus-window --match recent:1')
end

-- map('n', '<leader>b', '<cmd>lua OpenFileInNewKittyWindow()<CR>', opts)

function OpenTerminalHere()
  local command = 'ToggleTerm dir=%:h'
  -- local command = string.format('ToggleTerm dir=%s', currentBuffPath)
  vim.cmd(command)
end

map('n', '<c-§>', ':lua OpenTerminalHere()<CR>', opts)
map('n', '<A-\\>', ':lua OpenTerminalHere()<CR>', opts)


--> command remap
map('n', ':', '<cmd>FineCmdline<CR>', opts)

--> nvim-tree mappings
map('n', '<leader>w', ":NvimTreeToggle<CR>", opts)

--> buffer mappings
map('n', '<A-,>', ':bprev<CR>', opts)
map('n', '≤', ':bprev<CR>', opts)
map('n', '<A-.>', ':bnext<CR>', opts)
map('n', '≥', ':bnext<CR>', opts)
-- map('n', '<A-c>', ":lua require('bufdelete').bufwipeout(0)<CR> | NvimTreeCollapseKeepBuffers", opts)
-- map('n', 'ç', ":lua require('bufdelete').bufwipeout(0)<CR> | NvimTreeCollapseKeepBuffers", opts)
map('n', '<A-c>', ":lua require('bufdelete').bufwipeout(0)<CR>", opts)
map('n', 'ç', ":lua require('bufdelete').bufwipeout(0)<CR>", opts)

--> Other:
map('n', '<A-]>', ":lua require('goto-preview').goto_preview_definition()<CR>", opts)
map('n', '<A-[>', ':close<CR>', opts)
map('n', '<leader><leader>', '<C-w>L', opts) --move floating window to split-right
--map('n', '<leader>r', ":lua require('goto-preview').goto_preview_references()<CR>", opts)
map('n', '<leader><left>', '<C-W>h', opts)
map('n', '<leader><right>', '<C-W>l', opts)
map('n', '<leader><up>', '<C-W>k', opts)
map('n', '<leader><down>', '<C-W>j', opts)

--Add move line shortcuts
map('n', '<A-j>', ':m .+1<CR>==', opts)
map('n', '∆', ':m .+1<CR>==', opts)
map('n', '<A-k>', ':m .-2<CR>==', opts)
map('n', '˚', ':m .-2<CR>==', opts)
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', opts)
map('i', '∆', '<Esc>:m .+1<CR>==gi', opts)
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', opts)
map('i', '˚', '<Esc>:m .-2<CR>==gi', opts)
map('v', '<A-j>', ':m \'>+1<CR>gv=gv', opts)
map('v', '∆', ':m \'>+1<CR>gv=gv', opts)
map('v', '<A-k>', ':m \'<-2<CR>gv=gv', opts)
map('v', '˚', ':m \'<-2<CR>gv=gv', opts)

local function compare_to_clipboard()
  local ftype = vim.api.nvim_eval("&filetype")
  vim.cmd(string.format([[
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
  ]], ftype, ftype))
end

vim.keymap.set('n', '<Space>d', compare_to_clipboard)
