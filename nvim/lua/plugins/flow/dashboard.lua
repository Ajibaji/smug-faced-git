return {
  'goolord/alpha-nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Set header
    dashboard.section.header.val = {
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '                          ›—{zzü6ÞÅÅÅÅÅÅÅÅÅÅÅÅÅgÞ6üzz{—›                          ',
      '                     {ÇGGgÅggÅgÅgÅgÅgÅggÅggÅgÅgÅÅg—{6GÞíz6ÞÇ{                     ',
      '               ›íüÅÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅggÇ—    ÏÇÏ— —ÏÇüí›               ',
      '            ›ÇgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgg Ï6      —Þ6›  ›—ÇÞ—            ',
      '         {6ÅÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅÅggggggggggÅÅgg  ›Ç{       zÞízÞz ›6ü{         ',
      '       ÏggÅgÅgÅgÅgÅgÅgÅgÅgÅgÅÅgü—››     íí      ››    6—     —ÇGzG›     —ÞÏ       ',
      '     zggÅgÅgÅgÅgÅgÅgÅgÅgÅgÇ—            {í             GízüÇÏ     üü      ›6z     ',
      '   —GgÅgÅgÅgÅgÅgÅgÅgÅgg{íÇ{ÇGgÞí››      íí      ››íÇgGü—Ç›         {g       ›Þ{   ',
      '  zÅgÅgÅgÅgÅgÅgÅgÅgÅÞ{  Ç{        ›—íÏüüÇÇüüÏz{›        íz          ›Þ—       üz  ',
      ' ÏgÅgÅgÅgÅgÅgÅgÅgÅgü   {Ç               {í              ›Ç           {ü        zü ',
      '—gÅgÅgÅgÅgÅgÅgÅgÅgí    G—               íí               6—           6{        ü{',
      'ÇgÅgÅgÅgÅgÅgÅgÅgÅÏ    ›G                íí               zÏ           —Å        {6',
      'ggÅgÅgÅgÅgÅgÅgÅggí    ›G                íí               —Þ            g—       ›Ç',
      'ggÅgÅgÅgÅgÅgÅgÅggz{{{{{G{{{ÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅÅí{íg{{{{{{{{{{{—ÞÏ{í{í{í{íÞ',
      'ÇgÅgÅgÅgÅgÅgÅgÅggz    ›G  ›ÅÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅ› {Ç            Å›       {6',
      '—ÅgÅgÅgÅgÅgÅgÅgÅgg›    Þ{ ›ÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅÅ— üí           z6        ü{',
      ' ügÅgÅgÅgÅgÅgÅgÅgÅg—   —Ç ›ÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅggÅ› Ç›          ›Ç›       í6 ',
      '  ügÅgÅgÅgÅgÅgÅgÅgÅg{   6— —————ÅÅgÅgÅgÅgÅgÅgÅgÅgG————— íü           Ïz       Ïü  ',
      '   íggÅgÅgÅgÅgÅgÅgÅgÅgz {Ï ›íüü6ÅgÅgÅgÅgÅgÅgÅgÅgÅg6üÏí› ü{          6Ï      ›6í   ',
      '     ÇgÅgÅgÅgÅgÅgÅgÅgÅgÅÅÅz›    ÅÅgÅgÅgÅgÅgÅgÅgÅgÞ     üggí›      ›Þ—      üü     ',
      '      —6ÅgÅgÅgÅgÅgÅgÅgÅggÅggÞüz›ÅÅgÅgÅgÅgÅgÅgÅgÅgÞ    íÇ   —ÏÇü› Ï6›    —6ü›      ',
      '         ÏgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÞ   {ü        ígÇ›   zÅ{         ',
      '           —ÏgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅÞ ›ÇÏ      —6ü›  íg6z›           ',
      '               —ÞgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅÞíÇ›    —GÇ››—ÞGz                ',
      '                   —züGÅÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅgÅG› {ü66Þ6Ç6Ï{›                   ',
      '                          ›{zÞggGggggÅÅÅÅÅÅÅggggGggGü{›                           ',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button('r', ' Restore', [[<cmd> lua require("persistence").load() <cr>]]),
      -- dashboard.button('r', '  > Recent', ':Telescope oldfiles<CR>'),
      dashboard.button('s', ' Settings', ':e $MYVIMRC | :cd %:p:h | vsplit . | wincmd h | pwd<CR>'),
      -- dashboard.button('q', '  > Quit NVIM', ':qa<CR>'),
    }

    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    --     vim.cmd [[
    --     autocmd FileType alpha setlocal nofoldenable
    -- ]]
  end,
}
