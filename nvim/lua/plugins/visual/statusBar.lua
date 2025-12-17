local section_separators = { left = '', right = '' }

local lsp_clients = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return ''
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  return '\u{f085} ' .. table.concat(c, '|')
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'BufReadPre',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = section_separators,
        disabled_filetypes = {
          'SidebarNvim',
          statusline = {},
          winbar = {
            'snacks_terminal',
          },
        },
        ignore_focus = {
          'SidebarNvim',
        },
        always_divide_middle = false,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {
          'mode',
        },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          {
            'navic',
            color_correction = 'dynamic', -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
            --   -- Many colorschemes don't define same backgroud for nvim-navic as their lualine statusline backgroud.
            --   -- Setting it to "static" will perform a adjustment once when the component is being setup. This should
            --   --	 be enough when the lualine section isn't changing colors based on the mode.
            --   -- Setting it to "dynamic" will keep updating the highlights according to the current modes colors for
            --   --	 the current section.
            navic_opts = {
              highlight = true,
              separator = ' > ',
              depth_limit = 0,
              depth_limit_indicator = '..',
              safe_output = true,
              click = true,
            },
          },
        },
        lualine_x = {
          -- lsp_status,
        },
        lualine_y = {
          lsp_clients,
        },
        lualine_z = { 'location' },
      },
      tabline = {},
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { 'diagnostics' },
        lualine_y = {},
        lualine_z = {
          {
            'filename',
            file_status = true,
            newfile_status = false,
            path = 1,
            symbols = {
              modified = '[+]',
              readonly = '[-]',
              unnamed = '[No Name]',
              newfile = '[New]',
            },
          },
        },
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          {
            'filename',
            file_status = true,
            newfile_status = false,
            path = 1,
            symbols = {
              modified = '[+]',
              readonly = '[-]',
              unnamed = '[No Name]',
              newfile = '[New]',
            },
          },
        },
      },
      extensions = {
        'lazy',
        'mason',
        'quickfix',
      },
    })
  end,
}

-- refresh lualine
-- vim.cmd([[
-- augroup lualine_augroup
--     autocmd!
--     autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
-- augroup END
-- ]])
