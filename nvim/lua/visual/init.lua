require('visual.lspProgress')
require('visual.icons')
require('visual.tree')
require('visual.statusBar')
require('visual.indent')
require('visual.scroller')
require('visual.mode')
if vim.g.neovide then
  require('visual.neovide')
end
if vim.g.fvim_loaded then
  require('visual.fvim')
end
require('visual.notifications')
require('visual.reticle')
