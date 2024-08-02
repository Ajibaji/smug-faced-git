require('visual.tree')
require('visual.mode')
if vim.g.neovide then
  require('visual.neovide')
end
if vim.g.fvim_loaded then
  require('visual.fvim')
end
require('visual.notifications')
require('visual.reticle')
