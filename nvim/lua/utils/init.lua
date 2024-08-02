LightTheme = 'tokyonight-day'
DarkTheme = 'tokyonight-moon'

function RequireDir(targetDir)
  local directoryPath = vim.fn.stdpath 'config' .. '/lua/' .. targetDir
  local directoryList = vim.fn.readdir(directoryPath, [[v:val =~ '\.lua$']])
  local allDirModules = {}
  for _, file in ipairs(directoryList) do
    local requiredFile = targetDir .. '/' .. file:gsub('%.lua$', '')
    allDirModules[_] = require(requiredFile)
  end
  return allDirModules
end

function OpenTerminalHere()
  local command = 'ToggleTerm dir=%:h'
  -- local command = string.format('ToggleTerm dir=%s', currentBuffPath)
  vim.cmd(command)
end

-- Toggle-Theme (tt)
function tt(arg)
  if arg == 1 then
    SwitchTheme('light', LightTheme)
  else
    SwitchTheme('dark', DarkTheme)
  end
end

function SwitchTheme(mode, scheme)
  vim.api.nvim_set_option_value('background', mode, { scope = 'global' })
  vim.cmd.colorscheme(scheme)
end
