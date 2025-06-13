local o = vim.o
local opt = vim.opt
local g = vim.g


-- Don't show the mode, since it's already in the status line
o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
o.clipboard = 'unnamedplus'

-- Enable break indent
o.breakindent = true

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
o.timeoutlen = 500

-- Preview substitutions live, as you type!
o.inccommand = 'split'

if g.neovide then
  require('/config/neovide')
end

if g.fvim_loaded then
  require('/config/fvim')
end

g.loaded = 1
g.loaded_netrwPlugin = 1
g.mapleader = ' '
g.maplocalleader = ' '
g.have_nerd_font = true
--g.perl_host_prog = '/usr/local/bin/perl'
--g.python_host_prog = '/usr/bin/python2'
--g.python3_host_prog = '/usr/local/bin/python3'

o.cmdheight = 1
o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
o.updatetime = 250

if g.neovide then
  opt.guifont = 'JetBrainsMono Nerd Font:h17'
else
  opt.guifont = 'JetBrainsMono Nerd Font:h13'
end

o.termguicolors = true
opt.termguicolors = true

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
o.relativenumber = true
opt.numberwidth = 2
opt.signcolumn = 'yes'
opt.fillchars = { eob = ' ' }
opt.linespace = 0
opt.list = true
-- o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
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

o.autoread = false       --> disabled due to unstable behaviour e.g. npm i
o.completeopt = 'menuone,noselect'
