return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      {
        'williamboman/mason.nvim',
        config = true,
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition (Telescope)')
          map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences (Telescope)')
          map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          map('<leader>gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation (Telescope)')
          -- map('gI', vim.lsp.buf.implementations, '[G]oto [I]mplementation')
          map('<leader>gD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
        angularls = {},
        azure_pipelines_ls = {},
        bashls = {},
        bicep = {},
        biome = {},
        csharp_ls = {},
        cssls = {},
        cucumber_language_server = {},
        docker_compose_language_service = {},
        dockerls = {},
        eslint = {},
        helm_ls = {},
        html = {},
        htmx = {},
        jqls = {},
        markdown_oxide = {},
        neocmake = {},
        powershell_es = {},
        puppet = {},
        pylyzer = {},
        r_language_server = {},
        rnix = {},
        -- ruby_lsp = {},
        -- snyk_ls = {}, --needs active snyk account
        sqls = {},
        terraformls = {},
        tsserver = {},
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
          flags = {
            debounce_text_changes = 150,
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      vim.fn.extend(servers, {
        msbuild_project_tools_server = {
          cmd = {
            'dotnet',
            os.getenv 'HOMEPATH' .. '/.vscode/extensions/tintoy.msbuild-project-tools-0.6.3/language-server/MSBuildProjectTools.LanguageServer.Host.dll',
          },
        },
      })

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
