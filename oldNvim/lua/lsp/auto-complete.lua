local cmp = require 'cmp'
local luasnip = require 'luasnip'

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local bufIsBig = function(bufnr)
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size > MAX_FILE_SIZE then
    return true
  else
    return false
  end
end

local default_cmp_sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'nvim_lsp_signature_help' },
}, {
  { name = 'luasnip' },
  { name = 'async_path' }
}, {
  { name = 'npm' }
}, {
  { name = 'buffer' }
})

local cmp_kinds = {
  Text = '  ',
  Method = '  ',
  Function = '  ',
  Constructor = '  ',
  Field = '  ',
  Variable = '  ',
  Class = '  ',
  Interface = '  ',
  Module = '  ',
  Property = '  ',
  Unit = '  ',
  Value = '  ',
  Enum = '  ',
  Keyword = '  ',
  Snippet = '  ',
  Color = '  ',
  File = '  ',
  Reference = '  ',
  Folder = '  ',
  EnumMember = '  ',
  Constant = '  ',
  Struct = '  ',
  Event = '  ',
  Operator = '  ',
  TypeParameter = '  ',
}

local source_mapping = {
  nvim_lsp = "[Lsp]",
  luasnip = "[Snpt]",
  async_path = "[Path]",
  npm = "[Npm]",
  buffer = "[Buf]",
}

vim.api.nvim_create_autocmd('BufReadPre', {
  callback = function(t)
    local sources = default_cmp_sources
    if not bufIsBig(t.buf) then
      sources[#sources + 1] = { name = 'treesitter', group_index = 2 }
    end
    cmp.setup.buffer {
      sources = sources,
      enabled = function()
        -- disable completion in comments
        local context = require 'cmp.config.context'
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
          return true
        else
          return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
        end
      end,
      formatting = {
        fields = { "kind", "abbr" },
        format = function(entry, vim_item)
          vim_item.kind = cmp_kinds[vim_item.kind]
          vim_item.menu = source_mapping[entry.source.name]
          return vim_item
        end,
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete({
          reason = cmp.ContextReason.Auto,
        }),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
    }
  end
})

-- cmp.setup {
--   formatting = {
--     fields = { "kind", "abbr" },
--     format = function(entry, vim_item)
--       vim_item.kind = cmp_kinds[vim_item.kind]
--       vim_item.menu = source_mapping[entry.source.name]
--       return vim_item
--     end,
--   },
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body)
--     end,
--   },
--   mapping = cmp.mapping.preset.insert {
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete({
--       reason = cmp.ContextReason.Auto,
--     }),
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--     ['<S-Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' },
--     { name = 'path' },
--     { name = 'npm' },
--   },


--require('luasnip.loaders.from_vscode').lazy_load()
