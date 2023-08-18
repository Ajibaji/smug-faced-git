local u = require("settings.utils")
local navic = require("nvim-navic")

local eslint_disabled_buffers = {}

local lsp_formatting = function(bufnr)
  -- local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  vim.lsp.buf.format({
    async = false,
    bufnr = bufnr,
    -- filter = function(client)
    --   if client.name == "eslint" then
    --     return not eslint_disabled_buffers[bufnr]
    --   end
    -- end,
  })
end

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format { async = true } end, opts)
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, opts)
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, opts)
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, opts)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, opts)
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').oldfiles, opts)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, opts)

require('telescope').setup {}
pcall(require('telescope').load_extension, 'fzf')

vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = true,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    -- style = 'minimal',
    -- border = 'rounded',
    -- source = 'always',
    -- header = '',
    -- prefix = '',
    border = 'single',
    scope = 'line',
  },
})

local signs = {
  { name = 'DiagnosticSignError', text = "" },
  { name = 'DiagnosticSignWarn',  text = "" },
  { name = 'DiagnosticSignHint',  text = "" },
  { name = 'DiagnosticSignInfo',  text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  focusable = false,
  -- style = 'minimal',
  border = 'single',

})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  -- style = 'minimal',
  -- border = 'rounded',
  focusable = false,
  border = 'single',
  scope = 'line',
})

-- track buffers that eslint can't format to use prettier instead
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
--   local client = vim.lsp.get_client_by_id(ctx.client_id)
--   if not (client and client.name == "eslint") then
--     goto done
--   end
--
--   for _, diagnostic in ipairs(result.diagnostics) do
--     if diagnostic.message:find("The file does not match your project config") then
--       local bufnr = vim.uri_to_bufnr(result.uri)
--       eslint_disabled_buffers[bufnr] = true
--     end
--   end
--
--   ::done::
--   return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, config)
-- end

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    local formatting_cb = function()
      lsp_formatting(bufnr)
    end
    u.buf_command(bufnr, "LspFormatting", formatting_cb)
    u.buf_map(bufnr, "n", "<space>f", formatting_cb)

    -- vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   group = augroup,
    --   buffer = bufnr,
    --   command = "LspFormatting",
    -- })
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc') -- Enable completion triggered by <c-x><c-o>

  local bufopts = { noremap = true, silent = true }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>r', require('telescope.builtin').lsp_references, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
end

require('neodev').setup({
  override = function(root_dir, library)
    if root_dir:match("dotfiles") then
      library.enabled = true
      library.plugins = true
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local mason_lspconfig = require('mason-lspconfig')

local servers = {
  bashls = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  cmake = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  cssls = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  eslint = {
    root_dir = require('lspconfig').util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json"),
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
    end,
    capabilities = capabilities,
    settings = {
      format = {
        enable = true,
      },
    },
    handlers = {
      ["window/showMessageRequest"] = function(_, result)
        if result.message:find("ENOENT") then
          return vim.NIL
        end

        return vim.lsp.handlers["window/showMessageRequest"](nil, result)
      end,
    },
  },
  gopls = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  html = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  jsonls = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      json = {
        schemas = require("schemastore").json.schemas {
          select = {
            '.eslintrc',
            'package.json',
          },
        },
      },
      validate = { enable = true },
    },
  },
  lua_ls = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        telemetry = {
          enable = false,
        },
        workspace = {
          checkThirdParty = false,
        },
      },
    },
    flags = {
      debounce_text_changes = 150,
    },
  },
  powershell_es = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  pyright = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  ruby_ls = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  rust_analyzer = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  sqlls = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  terraformls = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
  },
  yamlls = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      yaml = {
        schemas = vim.list_extend(
          {
            ['/Users/ammararjomand/seeshellontheseasaw/custom-schemas/bp-ado-pipelines.json'] = {
              'ado/**/*.y*ml',
              '**/*azure*.y*ml',
              '**/*ado*.y*ml',
              '**/*ipeline*/**/*.y*ml',
            }
          },
          require('schemastore').yaml.schemas()
        ),
        validate = { enable = true },
      },
    },
  },
}

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup(servers[server_name] or {})
  end,
}

require("typescript-tools").setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end,
  settings = {
    -- spawn additional tsserver instance to calculate diagnostics on it
    separate_diagnostic_server = true,
    -- "change"|"insert_leave" determine when the client asks the server about diagnostic
    publish_diagnostic_on = "insert_leave",
    -- array of strings("fix_all"|"add_missing_imports"|"remove_unused")
    -- specify commands exposed as code_actions
    expose_as_code_action = {},
    -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
    -- not exists then standard path resolution strategy is applied
    tsserver_path = nil,
    -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
    -- (see 💅 `styled-components` support section)
    tsserver_plugins = {},
    -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
    -- memory limit in megabytes or "auto"(basically no limit)
    tsserver_max_memory = "auto",
    -- described below
    tsserver_format_options = {},
    tsserver_file_preferences = {},
  },
}

--> prettier
-- local status, prettier = pcall(require, "prettier")
-- if (not status) then return end
--
-- prettier.setup {
--   bin = 'prettierd',
--   filetypes = {
--     "css",
--     "javascript",
--     "javascriptreact",
--     "typescript",
--     "typescriptreact",
--     "json",
--     "scss",
--     "less"
--   }
-- }


-- suppress irrelevant messages
-- local notify = vim.notify
-- vim.notify = function(msg, ...)
--     if msg:match("%[lspconfig%]") then
--         return
--     end
--
--     if msg:match("warning: multiple different client offset_encodings") then
--         return
--     end
--
--     notify(msg, ...)
-- end
