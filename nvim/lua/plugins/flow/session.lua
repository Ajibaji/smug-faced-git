return {
  "folke/persistence.nvim",
  event = "VimEnter",
  opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
  -- keys = {
  --   { "<leader>qs", function() require("persistence").select() end, desc = "Select Session to restore" },
  --   { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
  --   { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  -- },
}
