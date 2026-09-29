-- Toggle gutter function.
local function toggle_gutter()
  if not vim.o.number then
    vim.o.number = true
    vim.o.relativenumber = false
    vim.o.signcolumn = 'number'
    vim.notify('gutter: absolute')
  elseif not vim.o.relativenumber then
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.signcolumn = 'number'
    vim.notify('gutter: relative')
  else
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.signcolumn = 'yes'
    vim.notify('gutter: off')
  end
end

-- Set toggle gutter key.
vim.keymap.set('n', '<leader>tg', toggle_gutter, { desc = 'Toggle gutter' })

-- Which ruler stop is active; persists across calls.
local tr_idx = 1

-- Toggle ruler function.
local function toggle_ruler()
  local tr_cols = { false, 72, 80, 120, 132 }
  tr_idx = tr_idx % #tr_cols + 1

  -- Colorcolumn shades text and empty cells alike, up to 256 columns past c.
  local c = tr_cols[tr_idx]
  local value = c and table.concat(vim.fn.range(c + 1, c + 256), ',') or ''

  -- Set every window plus the default inherited by new ones.
  vim.api.nvim_set_option_value('colorcolumn', value, { scope = 'global' })
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.api.nvim_set_option_value('colorcolumn', value, { win = win })
  end

  vim.notify('ruler: ' .. (c and tostring(c) or 'off'))
end

-- Set toggle ruler key.
vim.keymap.set('n', '<leader>tr', toggle_ruler, { desc = 'Toggle ruler' })

-- Which statusline stop is active; persists across calls.
local ts_idx = 1

-- Toggle statusline function.
local function toggle_statusline()
  local stops = {
    { ls = 2, ch = 1, name = 'on' },
    { ls = 2, ch = 0, name = 'on, no cmdline' },
    { ls = 0, ch = 0, name = 'off' },
  }
  ts_idx = ts_idx % #stops + 1

  local s = stops[ts_idx]
  vim.o.laststatus, vim.o.cmdheight = s.ls, s.ch
  vim.notify('statusline: ' .. s.name)
end

-- Set toggle statusline key.
vim.keymap.set('n', '<leader>ts', toggle_statusline, { desc = 'Toggle statusline' })
-- Set toggle word wrap key.
vim.keymap.set('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('wrap: ' .. (vim.wo.wrap and 'on' or 'off'))
end, { desc = 'Toggle word wrap' })

