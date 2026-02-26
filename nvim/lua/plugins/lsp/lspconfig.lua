return {
  {
    'Decodetalkers/csharpls-extended-lsp.nvim',
    cond = function()
      return not os.getenv('OS') == 'NixOS'
    end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = 'Mason',
    event = 'BufReadPre',
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = true,
      },
      {
        'williamboman/mason-lspconfig.nvim',
        opts = {
          auto_install = true,
        },
      },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('ammar-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          map('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.server_capabilities.documentSymbolProvider then
            local navic = require('nvim-navic')
            navic.attach(client, event.buf)
          end
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

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        -- angularls = {},
        bashls = {},
        docker_compose_language_service = {},
        dockerls = {},
        gopls = {},
        helm_ls = {},
        html = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
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
        markdown_oxide = {},
        neocmake = {},
        nil_ls = {},
        pylsp = {},
        ruff = {},
        shellcheck = {},
        -- copilot = {}, -- i think this is included in copilot-cmp
        -- snyk_ls = {
        --   cmd = { 'snyk-ls', '-f', '~/.local/share/logs/snyk-ls-vim.log' },
        --   filetypes = {
        --     'cs',
        --     'go',
        --     'gomod',
        --     'javascript',
        --     'typescript',
        --     'java',
        --     'json',
        --     'python',
        --     'requirements',
        --     'helm',
        --     'yaml',
        --     'rmd',
        --     'ruby',
        --     'terraform',
        --     'terraform-vars',
        --     'vb',
        --   },
        --   init_options = {
        --     activateSnykCode = 'true',
        --     activateSnykCodeQuality = 'true',
        --     activateSnykIac = 'true',
        --     activateSnykOpenSource = 'true',
        --     automaticAuthentication = 'true',
        --     enableTelemetry = 'false',
        --     enableTrustedFoldersFeature = 'false',
        --     integrationName = 'Neovim',
        --     organization = os.getenv('SNYK_ORG'),
        --     token = os.getenv('SNYK_TOKEN'),
        --   },
        --   root_dir = require('lspconfig.util').root_pattern('.git', '.snyk', '.svn'),
        --   settings = {},
        --   single_file_support = false,
        -- },
        sqlls = {},
        terraformls = {},
        tflint = {},
        ts_ls = {
          cmd = { 'typescript-language-server', '--stdio' },
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
          root_dir = require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
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

      if not os.getenv('OS') == 'NixOS' then
        vim.fn.extend(servers, {
          csharp_ls = {},
          powershell_es = {}
        })
      end

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
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '󰌶',
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = 'Error',
            [vim.diagnostic.severity.WARN] = 'Warn',
            [vim.diagnostic.severity.INFO] = 'Info',
            [vim.diagnostic.severity.HINT] = 'Hint',
          },
        },
        virtual_text = false,
        virtual_lines = false,
        underline = true,
        update_in_insert = false,
        severity_sort = false,
        float = {
          focusable = true,
          border = 'rounded',
          source = false,
          header = '',
          prefix = function(diagnostic)
            local severity, hlgroup
            if diagnostic.severity == 1 then
              severity = 'Error'
              hlgroup = 'DiagnosticError'
            elseif diagnostic.severity == 2 then
              severity = 'Warn'
              hlgroup = 'DiagnosticWarn'
            elseif diagnostic.severity == 3 then
              severity = 'Info'
              hlgroup = 'DiagnosticInfo'
            elseif diagnostic.severity == 4 then
              severity = 'Hint'
              hlgroup = 'DiagnosticHint'
            end
            return '[' .. severity .. '] - ', hlgroup
          end,
          suffix = function(diagnostic)
            return " [" .. diagnostic.source .. "]", "DiagnosticUnnecessary"
          end,
          scope = 'line',
          offset_x = 10,
          anchor_bias = 'above',
        },
      })
    end,
  },
}
