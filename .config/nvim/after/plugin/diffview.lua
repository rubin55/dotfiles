-- Diffview file panel: transparent separator background, so the fill
-- character renders as a divider line in the statusline color.
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local sl = vim.api.nvim_get_hl(0, { name = 'StatusLine', link = false })
    vim.api.nvim_set_hl(0, 'DiffviewWinSeparator', { fg = sl.bg, bg = 'NONE' })
  end
})

vim.keymap.set('n', '<leader>tv', function()
  local lib = require('diffview.lib')
  if lib.get_current_view() then
    vim.cmd('DiffviewClose')
  else
    vim.cmd('DiffviewOpen')
  end
end, { desc = 'Toggle diffview' })
