-- Mix color a into color b by alpha (0 to 1).
local function blend(a, b, alpha)
  local c = 0
  for shift = 0, 16, 8 do
    local x, y = bit.rshift(a, shift) % 256, bit.rshift(b, shift) % 256
    c = c + bit.lshift(math.floor(y + (x - y) * alpha + 0.5), shift)
  end
  return c
end

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local get = function(name)
      return vim.api.nvim_get_hl(0, { name = name, link = false })
    end

    -- Diffview file panel: transparent separator background, so the fill
    -- character renders as a divider line in the statusline color.
    vim.api.nvim_set_hl(0, 'DiffviewWinSeparator', { fg = get('StatusLine').bg, bg = 'NONE' })

    -- Diff filler lines: fade the fill character into the delete color.
    local del, fg = get('DiffDelete').bg, get('Comment').fg
    if del and fg then
      vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', { fg = blend(fg, del, 0.3), bg = del })
    end
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
