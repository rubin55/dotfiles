-- System clipboard shortcuts under <leader>, mirroring Vim's y/p grammar.
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y',  { desc = 'Yank to system clipboard' })
vim.keymap.set({ 'n'      }, '<leader>Y', '"+y$', { desc = 'Yank to end of line to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p',  { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P',  { desc = 'Paste before from system clipboard' })

-- Make shift-arrow move selection in normal mode.
vim.keymap.set('n', '<S-Down>', 'v$', { desc = 'Select start down' })
vim.keymap.set('n', '<S-Up>', 'v$o', { desc = 'Select start up' })
vim.keymap.set('n', '<S-Right>', 'v<Right>', { desc = 'Select start right' })
vim.keymap.set('n', '<S-Left>', 'v<Left>', { desc = 'Select start left' })

-- Make shift-arrow move selection in visual mode.
vim.keymap.set('v', '<S-Down>', '<Down>', { desc = 'Select extend down' })
vim.keymap.set('v', '<S-Up>', '<Up>', { desc = 'Select extend up' })
vim.keymap.set('v', '<S-Right>', '<Right>', { desc = 'Select extend right' })
vim.keymap.set('v', '<S-Left>', '<Left>', { desc = 'Select extend left' })

-- Dismiss floating windows, such as LSP hover from K and nvim-tree with <Esc>.
vim.keymap.set('n', '<Esc>', function()
  vim.cmd('nohlsearch')
  local wins = vim.list_extend({ vim.api.nvim_get_current_win() }, vim.api.nvim_list_wins())
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
end, { desc = 'Close float, clear search highlight', nowait = true })

-- Shift-enter in terminal sends newline.
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(ev)
    vim.keymap.set('t', '<S-CR>', function()
      vim.api.nvim_chan_send(vim.b[ev.buf].terminal_job_id, '\n')
    end, { buffer = ev.buf, desc = 'Send newline to terminal' })
  end
})

-- Close buffer without closing window.
vim.keymap.set('c', '<CR>', function()
  if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'bd' then
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()

      -- Don't do anything on an empty, unmodified, unnamed buffer.
      if vim.api.nvim_buf_get_name(bufnr) == ''
        and vim.bo[bufnr].buftype == ''
        and not vim.bo[bufnr].modified then
        return
      end

      -- All windows showing given 'bufnr'.
      local wins  = vim.fn.win_findbuf(bufnr)

      if #wins > 1 then
        -- Buffer is still open elsewhere: just blank this window.
        vim.cmd('enew')
      else
        -- Last window, switch away, then delete.
        vim.cmd('bprevious')
        if bufnr == vim.api.nvim_get_current_buf() then
          vim.cmd('enew')
        end
        vim.cmd('silent! bdelete ' .. bufnr)
      end
    end)

    return '<C-c>'
  end

  return '<CR>'
end, { expr = true, desc = ':bd closes buffer, keeping window, else normal Enter' })
