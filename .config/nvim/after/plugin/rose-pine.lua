-- Configure rose-pine theme.
require('rose-pine').setup({
  dark_variant = 'moon',
  styles = {
    bold = false
  },
  palette = {
    dawn = {
      base = '#f1e8e0',
      overlay = '#d0c8c1',
      surface = '#e0d8d1'
    }
  }
})

-- Cursor line overrides for rose-pine-dawn only.
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'rose-pine',
  callback = function()
    if vim.g.colors_name == 'rose-pine' and vim.o.background == 'light' then
      local palette = require('rose-pine.palette')
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = palette.surface })
      vim.api.nvim_set_hl(0, 'NvimTreeCursorLine', { bg = palette.overlay })
      -- Split separator same tone as the cursorline.
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = palette.surface })
    end
  end
})
