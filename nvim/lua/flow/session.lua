local nvimTree = require('nvim-tree.view')

function _G.close_all_floating_wins()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
end

function Pre_save()
  _G.close_all_floating_wins()
  nvimTree.close()
end

function Post_save()
end

require('auto-session').setup {
  log_level = "warn",
  auto_session_suppress_dirs = nil,
  auto_session_allowed_dirs = { "~/Documents/code/*", "~/.config/*", "~/.local/share/nvim",
    "~/.local/share/nvim/site/pack/packer/*" },
  pre_save_cmds = { Pre_save },
  post_save_cmds = { Post_save }
}
