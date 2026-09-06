-- Set toggle word wrap key.
vim.keymap.set('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('wrap: ' .. (vim.wo.wrap and 'on' or 'off'))
end, { desc = 'Toggle word wrap' })

