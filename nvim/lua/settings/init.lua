local o = vim.o
local opt = vim.opt
local g = vim.g

g.loaded = 1
g.loaded_netrwPlugin = 1
g.perl_host_prog = '/usr/local/bin/perl'
g.python_host_prog = '/usr/bin/python2'
g.python3_host_prog = '/usr/local/bin/python3'

o.cmdheight = 1
o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
o.updatetime = 250

o.termguicolors = true
opt.termguicolors = true
opt.guifont = 'JetBrainsMono Nerd Font:h13'

opt.foldmethod = 'manual'
--o.foldcolumn = '1' -- '0' is not bad
o.foldlevel = 99
o.foldlevelstart = 99
--o.foldenable = true


opt.expandtab = true
opt.smarttab = false
opt.shiftwidth = 2
opt.tabstop = 2

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
-- opt.cursorline = true
opt.colorcolumn = ''
opt.number = true
opt.numberwidth = 2
opt.signcolumn = 'yes'
opt.fillchars = { eob = ' ' }
opt.linespace = 0
opt.list = true
-- opt.listchars:append "space:⋅"
-- opt.listchars:append "eol:↴"

opt.mouse = 'a'
opt.scrolloff = 5
opt.sidescrolloff = 8

opt.hidden = true
opt.splitbelow = true
opt.splitright = true
opt.wrap = false
opt.fileencoding = 'utf-8'

opt.undofile = true

vim.o.autoread = false       --> disabled due to unstable behaviour e.g. npm i
--vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
--  command = "if mode() != 'c' | checktime | endif",
--  pattern = { "*" },
--})

o.completeopt = 'menuone,noselect'

-- auto-reload kitty on editing kitty.conf
vim.api.nvim_create_autocmd(
  {
    "bufwritepost"
  },
  {
    pattern = vim.fn.expand("~").."/.config/kitty/*",
    command = "silent !kill -SIGUSR1 $(pgrep -a kitty)"
  }
)
