--require('flow.command')
require('flow.session')
require('flow.goto')
require('flow.save')
require('flow.terminal')
--require('flow.dashboard')

require('Comment').setup()

-- vim.cmd([[
--   augroup My_group
--     autocmd!
--     autocmd FileType c setlocal cindent
--   augroup END
-- ]])
-- autocmd FileType typescript,typescriptreact set makeprg=./node_modules/.bin/tsc\ \\\|\ sed\ 's/(\\(.*\\),\\(.*\\)):/:\\1:\\2:/'
-- autocmd BufNewFile,BufReadPost *.js set filetype=javascriptreact
-- autocmd FileType typescript,typescriptreact setl makeprg=npx\ tsc errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m

vim.cmd([[
  augroup typeface
    autocmd FileType typescript,typescriptreact set makeprg=./node_modules/.bin/tsc\ \\\|\ sed\ 's/(\\(.*\\),\\(.*\\)):/:\\1:\\2:/'
  augroup END
]])
