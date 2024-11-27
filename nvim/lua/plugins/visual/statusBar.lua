local section_separators
-- if vim.env.TERM == 'xterm-kitty' and not vim.g.neovide and not vim.g.fvim_loaded then
--   section_separators = { left = '', right = '' }
-- else
--   section_separators = { left = '', right = '' }
-- end

section_separators = { left = '', right = '' }

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

-- local function lsp_status()
--   return require("lsp-progress").progress({
--     format = function(messages)
--       return #messages > 0 and table.concat(messages, " ") or ""
--     end,
--   })
-- end

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  priority = 999,
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
          'NvimTree',
          'SidebarNvim',
          'TelescopePrompt',
          statusline = {},
        },
        ignore_focus = {
          'NvimTree',
          'SidebarNvim',
          'TelescopePrompt',
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
          {
            require('noice').api.statusline.mode.get,
            cond = require('noice').api.statusline.mode.has,
            color = {
              fg = '#420D09',
            },
          },
        },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          {
            draw_empty = true,
            'navic',
            color_correction = 'dynamic', -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
            -- Many colorschemes don't define same backgroud for nvim-navic as their lualine statusline backgroud.
            -- Setting it to "static" will perform a adjustment once when the component is being setup. This should
            --	 be enough when the lualine section isn't changing colors based on the mode.
            -- Setting it to "dynamic" will keep updating the highlights according to the current modes colors for
            --	 the current section.
            {
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
        --lualine_z = { "os.date('%H:%M')" }
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
        --  lualine_a = {},
        --  lualine_b = {},
        --	lualine_c = {},
        --	lualine_x = {
        --	  {
        --	    'buffers',
        --	    show_filename_only = true,
        --	    hide_filename_extension = false,
        --	    show_modified_status = true,
        --	    mode = 0,
        --	    max_length = vim.o.columns * 2 / 3,
        --	    filetype_names = {
        --				NvimTree = '',
        --	      TelescopePrompt = '',
        --	      dashboard = 'Dashboard',
        --	     	packer = 'packer',
        --	      fzf = 'FZF',
        --	      alpha = 'Alpha'
        --	    },
        --	    buffers_color = {
        --	      active = 'StatusLine',
        --	      inactive = 'StatusLineNC'
        --	    },
        --	    symbols = {
        --	      modified = ' ●',
        --	      alternate_file = '',
        --	      directory =  ''
        --	    }
        --	  }
        --	},
        --  lualine_y = {},
        --  lualine_z = {}
      },
      extensions = {
        'nvim-tree',
        'quickfix',
        'toggleterm',
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
