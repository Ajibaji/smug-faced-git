local M = {}

function M.RequireDir(targetDir)
  local directoryPath = vim.fn.stdpath('config') .. '/lua/' .. targetDir
  local directoryList = vim.fn.readdir(directoryPath, [[v:val =~ '\.lua$']])
  local allDirModules = {}
  for _, file in ipairs(directoryList) do
    local requiredFile = targetDir .. '/' .. file:gsub('%.lua$', '')
    allDirModules[_] = require(requiredFile)
  end
  return allDirModules
end

-- Toggle-Theme (tt)
-- call this function from outside Neovim with a simple 1 or 0 argument
function M.tt(arg)
  local mode = arg == 1 and 'light' or 'dark'
  utils.SetTheme(mode)
end

function M.SetTheme(mode)
  local theme = mode == 'dark' and DarkTheme or LightTheme
  -- vim.api.nvim_set_option_value('background', mode, { scope = 'global' })
  vim.cmd.colorscheme(theme)

  CURRENT_THEME = string.upper(mode)
  vim.env.CURRENT_THEME = CURRENT_THEME

  LG_CONFIG_FILE = HOME .. '/.config/lazygit/' .. string.upper(mode) .. '-config.yml'
  vim.env.LG_CONFIG_FILE = LG_CONFIG_FILE

  local batThemeRef = 'BAT_THEME_' .. CURRENT_THEME
  BAT_THEME = os.getenv(batThemeRef)
  vim.env.BAT_THEME = BAT_THEME
end

-- function M.compare_to_clipboard()
--   local ftype = vim.api.nvim_eval('&filetype')
--   vim.cmd(string.format(
--     [[
--     execute "normal! \"xy"
--     vsplit
--     enew
--     normal! P
--     setlocal buftype=nowrite
--     set filetype=%s
--     diffthis
--     execute "normal! \<C-w>\<C-w>"
--     enew
--     set filetype=%s
--     normal! "xP
--     diffthis
--   ]],
--     ftype,
--     ftype
--   ))
-- end

return M
