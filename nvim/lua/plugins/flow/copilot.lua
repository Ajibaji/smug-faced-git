return {
  {
    'olimorris/codecompanion.nvim', -- The KING of AI programming
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
    dependencies = {
      'ravitemer/codecompanion-history.nvim', -- Save and load conversation history
      -- { "echasnovski/mini.pick", config = true },
      -- { "ibhagwan/fzf-lua", config = true },
    },
    opts = {
      extensions = {},
      adapters = {},
      prompt_library = {},
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
      display = {
        action_palette = {
          provider = 'default',
        },
        chat = {
          -- show_references = true,
          -- show_header_separator = false,
          -- show_settings = false,
          icons = {
            tool_success = '󰸞',
          },
        },
        diff = {
          provider = 'mini_diff',
        },
      },
      opts = {},
    },
    keys = {
      {
        '<C-a>',
        '<cmd>CodeCompanionActions<CR>',
        desc = 'Open the action palette',
        mode = { 'n', 'v' },
      },
      {
        '<Leader>a',
        '<cmd>CodeCompanionChat Toggle<CR>',
        desc = 'Toggle a chat buffer',
        mode = { 'n', 'v' },
      },
      {
        '<LocalLeader>a',
        '<cmd>CodeCompanionChat Add<CR>',
        desc = 'Add code to a chat buffer',
        mode = { 'v' },
      },
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
    end,
  },
  {
    'echasnovski/mini.diff', -- Inline and better diff over the default
    config = function()
      local diff = require('mini.diff')
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },
  {
    'zbirenbaum/copilot.lua', -- AI programming
    event = 'InsertEnter',
    keys = {
      {
        '<C-a>',
        function()
          require('copilot.suggestion').accept()
        end,
        desc = 'Copilot: Accept suggestion',
        mode = { 'i' },
      },
      {
        '<C-x>',
        function()
          require('copilot.suggestion').dismiss()
        end,
        desc = 'Copilot: Dismiss suggestion',
        mode = { 'i' },
      },
      {
        '<C-//>',
        function()
          require('copilot.panel').open()
        end,
        desc = 'Copilot: Show panel',
        mode = { 'n', 'i' },
      },
    },
    init = function()
      vim.api.nvim_create_user_command('Copilot', function()
        require('copilot.suggestion').toggle_auto_trigger()
      end, {
        desc = 'Toggle Copilot suggestions',
        nargs = 0,
      })
    end,
    opts = {
      panel = { enabled = false },
      suggestion = {
        auto_trigger = true, -- Suggest as we start typing
        keymap = {
          accept_word = '<C-l>',
          accept_line = '<C-j>',
        },
      },
      filetypes = {
        yaml = true,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ['.'] = false,
      },
    },
  },
}
