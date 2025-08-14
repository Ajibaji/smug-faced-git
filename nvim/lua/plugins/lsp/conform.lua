return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
      },
      notify_on_error = true,
      format_on_save = false,
      formatters_by_ft = {
        cs = { "csharpier" },
        css = { "biome" },
        html = { "biome" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { "deno_fmt" },
        nix = { "nixfmt" },
        scss = { "biome" },
        sh = { "shellcheck" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
      },
    },
  },
}
