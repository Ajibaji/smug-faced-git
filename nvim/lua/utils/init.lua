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

function M.OpenTerminalHere()
  local command = 'ToggleTerm dir=%:h'
  -- local command = string.format('ToggleTerm dir=%s', currentBuffPath)
  vim.cmd(command)
end

-- Toggle-Theme (tt)
function M.tt(arg)
  if arg == 1 then
    utils.SwitchTheme('light', LightTheme)
  else
    utils.SwitchTheme('dark', DarkTheme)
  end
end

function M.SwitchTheme(mode, scheme)
  vim.api.nvim_set_option_value('background', mode, { scope = 'global' })
  vim.cmd.colorscheme(scheme)
end

function M.compare_to_clipboard()
  local ftype = vim.api.nvim_eval('&filetype')
  vim.cmd(string.format(
    [[
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
  ]],
    ftype,
    ftype
  ))
end

return M
