require 'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {
    "bash",
    "dockerfile",
    "help",
    "html",
    "javascript",
    "json",
    "lua",
    "make",
    "python",
    "ruby",
    "rust",
    "typescript",
    "vim",
    "yaml"
  },
  sync_install = false,
  highlight = {
    enable = true,
    disable = function(lang, buf)
      -- if #vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] > 1000 then
      if vim.api.nvim_buf_line_count(buf) > 1000 then
        return true
      end
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > MAX_FILE_SIZE then
        return true
      end
    end,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<A-space>",
      node_incremental = "<A-space>",
      scope_incremental = "<A-s>",
      node_decremental = "<A-backspace>",
    },
  },
  indent = {
    enable = true,
    disable = { 'python' }
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  context_commentstring = {
    enable = true,
    config = {
      css = '// %s'
    }
  }
}
