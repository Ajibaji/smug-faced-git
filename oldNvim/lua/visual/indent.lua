--require("indent_blankline").setup {
--    show_current_context = true,
--    show_current_context_start =  false,
--}

--vim.opt.list = true

--require("indent_blankline").setup {
--    space_char_blankline = " ",
--    show_current_context = true,
--    show_current_context_start = true,
--    -- use_treesitter = true,
--    show_first_indent_level = false,
--    -- use_treesitter_scope = false,
--    show_trailing_blankline_indent = false,
--    char_highlight_list = {
--      "NvimTreeIndentMarker",
--    }
--}

return {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require("ibl").setup()
  end,
}
