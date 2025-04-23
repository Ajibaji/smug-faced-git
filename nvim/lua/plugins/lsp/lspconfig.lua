return {
  {
    'Decodetalkers/csharpls-extended-lsp.nvim',
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = true,
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('ammar-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition (Telescope)')
          map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences (Telescope)')
          map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          map('<leader>gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation (Telescope)')
          -- map('gI', vim.lsp.buf.implementations, '[G]oto [I]mplementation')
          map('<leader>gD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          -- map('<leader>F', function() vim.lsp.buf.format { async = true } end, '[F]ormat') -- replaced with conform.nvim

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('ammar-lsp-highlight', { clear = false })
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
              group = vim.api.nvim_create_augroup('ammar-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'ammar-lsp-highlight', buffer = event2.buf })
              end,
            })
          end

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
        bashls = {},
        bicep = {},
        biome = {
          root_dir = require('lspconfig.util').root_pattern('package.json', '.git'),
        },
        csharp_ls = {},
        cssls = {},
        cucumber_language_server = {},
        docker_compose_language_service = {},
        dockerls = {},
        -- eslint = {},
        helm_ls = {},
        html = {},
        markdown_oxide = {},
        neocmake = {},
        powershell_es = {},
        pylyzer = {},
        r_language_server = {},
        rnix = {},
        shfmt = {},
        snyk_ls = {
          cmd = { 'snyk-ls', '-f', '~/.local/share/logs/snyk-ls-vim.log' },
          filetypes = {
            'cs',
            'go',
            'gomod',
            'javascript',
            'typescript',
            'java',
            'json',
            'python',
            'requirements',
            'helm',
            'yaml',
            'rmd',
            'ruby',
            'terraform',
            'terraform-vars',
            'vb',
          },
          init_options = {
            activateSnykCode = 'true',
            activateSnykCodeQuality = 'true',
            activateSnykIac = 'true',
            activateSnykOpenSource = 'true',
            automaticAuthentication = 'true',
            enableTelemetry = 'false',
            enableTrustedFoldersFeature = 'false',
            integrationName = 'Neovim',
            organization = os.getenv('SNYK_ORG'),
            token = os.getenv('SNYK_TOKEN'),
          },
          root_dir = require('lspconfig.util').root_pattern('.git', '.snyk', '.svn'),
          settings = {},
          single_file_support = false,
        },
        sqlls = {},
        terraformls = {},
        -- ts_ls = {},
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
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' },
              },
            },
          },
          flags = {
            debounce_text_changes = 150,
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ['file://' .. HOME .. '/.config/schema-ado-pipelines-custom.json'] = {
                  '/azure-pipeline*.y*l',
                  '/*.azure*',
                  '*ipeline*/**/*.y*l',
                  '*uild/**/*.y*l',
                  'ci/**/*.y*l',
                  'CI/**/*.y*l',
                  'cd/**/*.y*l',
                  'CD/**/*.y*l',
                  '*eploy/**/*.y*l',
                },
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })

      require('mason-tool-installer').setup({
        ensure_installed = ensure_installed,
      })

      -- vim.fn.extend(servers, {
      --   msbuild_project_tools_server = {
      --     cmd = {
      --       'dotnet',
      --       os.getenv 'HOMEPATH' .. '/.vscode/extensions/tintoy.msbuild-project-tools-0.6.3/language-server/MSBuildProjectTools.LanguageServer.Host.dll',
      --     },
      --   },
      -- })

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            if server_name == 'csharp_ls' then
              server.capabilities.textDocument.definition = require('csharpls_extended').hander
              server.capabilities.textDocument.typeDefinition = require('csharpls_extended').hander
            end
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
    init = function()
      local signs = { Error = '󰅚', Warn = '󰀪', Hint = '󰌶', Info = '' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config({
        virtual_text = {
          prefix = 'jeff says...',
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = false,
        float = {
          focusable = false,
          style = 'minimal',
          border = 'rounded',
          source = 'if_many',
          header = '',
          prefix = '',
        },
      })
    end,
  },
}
