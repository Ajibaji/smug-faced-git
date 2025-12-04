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

-- set OS window title to repo name as base path. fallback to working directory
local repo_name = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null | tr -d '\n'")
local git_working_dir = string.find(vim.fn.getcwd(), vim.fn.fnamemodify(repo_name, ':t'), 1, true)
local title = repo_name ~= '' and string.sub(vim.fn.getcwd(), git_working_dir) or vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
o.title = true
o.titlestring = title

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
g.perl_host_prog = '/usr/bin/perl'
g.loaded_perl_provider = 0
--g.python_host_prog = '/usr/bin/python2'
--g.python3_host_prog = '/usr/local/bin/python3'

o.cmdheight = 1
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

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

o.autoread = false       --> disabled due to unstable behaviour e.g. npm i
o.completeopt = 'menuone,noselect'
