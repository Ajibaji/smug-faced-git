return {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  priority = 1000,
  keys = {
    { '<leader>w', '<cmd>NvimTreeToggle<cr>', desc = 'NvimTree' },
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    local tree = require('nvim-tree')

    local function run_on_attach(bufnr)
      local api = require('nvim-tree.api')

      local popup_preview = function(file_path)
        local Popup = require('nui.popup')
        local autocmd = require('nui.utils.autocmd')
        local event = autocmd.event

        local popup_options = {
          enter = true,
          border = {
            style = 'single',
            highlight = 'Fg',
            text = {
              top_align = 'left',
            },
          },
          highlight = 'Normal:Normal',
          position = '50%',
          size = {
            width = '70%',
            height = '80%',
          },
          relative = 'editor',
          opacity = 1,
          -- zindex = 50,
          focusable = true,
        }

        local popup = Popup(popup_options)
        popup:mount()

        local fname = vim.fn.fnameescape(file_path)
        vim.fn.win_execute(popup.winid, 'edit ' .. fname)
        vim.wo[popup.winid].number = false
        vim.wo[popup.winid].signcolumn = 'no'
        vim.bo[vim.fn.winbufnr(popup.winid)].buflisted = false

        popup:on({ event.BufLeave, event.BufWinLeave, event.WinLeave, event.CmdWinEnter }, function()
          vim.schedule(function()
            popup:unmount()
          end)
        end, { once = true })

        popup:map('n', '<esc>', function()
          popup:unmount()
        end, { noremap = true })
      end

      local function preview()
        local node = api.tree.get_node_under_cursor()
        if node ~= nil then
          local path = node.absolute_path
          if vim.fn.isdirectory(path) == 1 then
            return
          end
          popup_preview(path)
        end
      end

      local function collapse()
        -- require("nvim-tree.actions.tree-modifiers.collapse-all").fn(true)
        api.tree.collapse_all(true)
      end

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      vim.keymap.set('n', '<s-Tab>', preview, opts('Open Preview'))
      vim.keymap.set('n', 'w', collapse, opts('Collapse keep open buffers'))
      -- vim.keymap.set("n", "W", api.tree.collapse_all(true), opts("Collapse keep open buffers"))
    end

    tree.setup({
      disable_netrw = false,
      hijack_netrw = true,
      create_in_closed_folder = false,
      open_on_tab = false,
      hijack_cursor = false,
      hijack_unnamed_buffer_when_opening = false,
      auto_reload_on_write = true,
      update_cwd = false,
      reload_on_bufenter = true,
      respect_buf_cwd = false,
      select_prompts = false,
      diagnostics = {
        enable = true,
        show_on_dirs = false,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.INFO,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint = '',
          info = '',
          warning = '',
          error = '',
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = false,
        ignore_list = { 'node_modules' },
      },
      system_open = {
        cmd = '',
        args = {},
      },
      filters = {
        dotfiles = false,
        custom = {
          '^.git$',
          '.vscode$',
          '.cache$',
          '.DS_Store$',
        },
        exclude = {
          '.gitignore',
        },
      },
      git = {
        --enable = true,
        enable = true,
        ignore = false,
        timeout = 500,
      },
      view = {
        centralize_selection = false,
        cursorline = true,
        --width = 30,
        --hide_root_folder = false,
        side = 'right',
        adaptive_size = true,
        preserve_window_proportions = false,
        -- mappings = {
        --   custom_only = false,
        --   list = {
        --     { key = '[tab]', action = 'preview', action_cb = preview },
        --     { key = 'W', action = 'collapse_keep_buffers', action_cb = collapse },
        --   }
        -- },
        on_attach = run_on_attach(),
        number = false,
        relativenumber = false,
        signcolumn = 'yes',
        float = {
          enable = false,
          quit_on_focus_loss = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local _width = screen_w * 0.7
            local _height = screen_h * 0.8
            local width = math.floor(_width)
            local height = math.floor(_height)
            local center_y = ((vim.opt.lines:get() - _height) / 2) - vim.opt.cmdheight:get()
            --local center_x = (screen_w - _width) / 2
            local center_x = screen_w * 0.6
            local layouts = {
              center = {
                anchor = 'NW',
                relative = 'editor',
                border = 'single',
                row = center_y,
                col = center_x,
                width = width,
                height = height,
              },
            }
            return layouts.center
          end,
        },
        --width = function()
        --  return math.floor(vim.opt.columns:get() * 0.7)
        --end,
        --height = function()
        --  return math.floor((vim.opt.lines:get() - vim.opt.cmdheight:get()) * 0.5)
        --end,
      },
      renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = 'all',
        root_folder_modifier = ':t:r',
        indent_width = 2,
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = '└',
            edge = '│',
            item = '│',
            bottom = '─',
            none = ' ',
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = 'after',
          modified_placement = 'after',
          padding = ' ',
          symlink_arrow = '➛',
          show = {
            file = false,
            folder = true,
            folder_arrow = true,
            --git = true,
            git = true,
            modified = true,
          },
          glyphs = {
            default = '',
            symlink = '',
            bookmark = '',
            modified = '●',
            folder = {
              arrow_closed = '',
              arrow_open = '',
              default = '',
              open = '',
              empty = '',
              empty_open = '',
              symlink = '',
              symlink_open = '',
            },
            git = {
              unstaged = '✗',
              staged = '✓',
              unmerged = '',
              renamed = '➜',
              untracked = '★',
              deleted = '',
              ignored = '◌',
            },
          },
        },
        special_files = {},
      },
      hijack_directories = {
        enable = true,
        auto_open = false,
      },
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
        },
        open_file = {
          quit_on_open = true,
          resize_window = true,
          window_picker = {
            enable = true,
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
            exclude = {
              filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
              buftype = { 'nofile', 'terminal', 'help' },
            },
          },
        },
        remove_file = {
          close_window = false,
        },
      },
      trash = {
        cmd = 'gio trash',
        require_confirm = true,
      },
      live_filter = {
        prefix = '[FILTER]: ',
        always_show_folders = false,
      },
      filesystem_watchers = {
        enable = true,
        ignore_dirs = { 'node_modules', '.git' },
      },
    })

    local events = require('nvim-tree.events')
    local subscribe = events.subscribe
    local Event = events.Event

    subscribe(Event.FileCreated, function(data)
      vim.cmd('edit ' .. data.fname)
    end)
  end,
}
