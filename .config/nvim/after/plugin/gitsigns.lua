-- Gitsigns configuration.
require('gitsigns').setup({
  current_line_blame = true,
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then vim.cmd.normal({ ']c', bang = true })
      else gs.nav_hunk('next') end
    end, { desc = 'Git next hunk' })
    map('n', '[c', function()
      if vim.wo.diff then vim.cmd.normal({ '[c', bang = true })
      else gs.nav_hunk('prev') end
    end, { desc = 'Git previous hunk' })

    map('n', '<leader>hs', gs.stage_hunk, { desc = 'Git stage hunk' })
    map('n', '<leader>hr', gs.reset_hunk, { desc = 'Git reset hunk' })
    map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Git stage hunk (visual)' })
    map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Git reset hunk (visual)' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = 'Git stage buffer' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = 'Git reset buffer' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'Git review hunk' })
    map('n', '<leader>hi', gs.preview_hunk_inline, { desc = 'Git preview hunk inline' })
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = 'Git blame line' })
    map('n', '<leader>hd', gs.diffthis, { desc = 'Git diff' })
    map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Git diff HEAD' })
    map('n', '<leader>hq', gs.setqflist, { desc = 'Git hunks to quickfix' })
    map('n', '<leader>hQ', function() gs.setqflist('all') end, { desc = 'Git all hunks to quickfix' })

    map('n', '<leader>b', gs.toggle_current_line_blame, { desc = 'Toggle git blame' })
    map('n', '<leader>d', gs.toggle_word_diff, { desc = 'Toggle git word diff' })

    map({ 'o', 'x' }, 'ih', gs.select_hunk, { desc = 'Select hunk' })
  end,
})
