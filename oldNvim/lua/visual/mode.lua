# Toggle-Theme (tt)
function tt(arg)
  local mode = arg == 1 and 'light' or 'dark'
  local scheme = arg == 1 and 'dawnfox' or 'nightfox'
  vim.api.nvim_set_option('background', mode)
  vim.cmd("colorscheme " .. scheme)
  require('visual.indent')
end

function GoDark()
  vim.api.nvim_set_option('background', 'dark')
  vim.cmd("colorscheme nightfox")
  require('visual.indent')
end

function GoLight()
  vim.api.nvim_set_option('background', 'light')
  vim.cmd("colorscheme dawnfox")
  require('visual.indent')
end

-- local auto_dark_mode = require('auto-dark-mode')
--
-- auto_dark_mode.setup({
--   update_interval = 1000,
--   set_dark_mode = GoDark(),
--   set_light_mode = GoLight(),
-- })
--
-- auto_dark_mode.init()
-- function ApplyTheme()
  -- local osTheme = os.getenv('LIGHT_THEME')
  -- local on_exit = function(obj)
    -- vim.print(obj.code)
    -- vim.print(obj.signal)
    -- vim.print(obj.stdout)
    -- vim.print(obj.stdout)
    -- vim.print(obj.stderr)
  -- end
-- Runs asynchronously:
  -- vim.system({'whoami'}, { text = true }, on_exit)
  -- local osTheme = os.execute('echo %LIGHT_THEME%')
  -- local checkOsTheme = io.popen("echo %LIGHT_THEME%")
  -- local osTheme = checkOsTheme:read("*a")
  -- checkOsTheme:close()
  -- local osTheme = vim.fn.system('[System.Environment]::GetEnvironmentVariable("LIGHT_THEME","User")')
  -- local osTheme = vim.fn.system('get-childitem')
  -- local osTheme = vim.fn.system("dir")
  -- local command = [[echom system("[System.Environment]::GetEnvironmentVariable('LIGHT_THEME','User')")]]
  -- local osTheme = vim.cmd([[echom system("[System.Environment]::GetEnvironmentVariable('LIGHT_THEME','User')")]])
  -- if osTheme == nil then
  --   osTheme = "jefffff"
  -- end
  -- if  osTheme == '1' then
  --   GoLight()
  -- else
  --   GoDark()
  -- end
  -- vim.print("osTheme is:" .. osTheme)
  -- vim.print(command)
-- end

-- ApplyTheme()
