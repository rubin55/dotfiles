-- Cycle gutter function.
local function cycle_gutter()
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

-- Set cycle gutter key.
vim.keymap.set('n', '<leader>cg', cycle_gutter, { desc = 'Cycle gutter' })

-- Which ruler stop is active; persists across calls.
local cr_idx = 1

-- Cycle ruler function.
local function cycle_ruler(step)
  local cr_cols = { false, 72, 80, 120, 132 }
  cr_idx = (cr_idx - 1 + step) % #cr_cols + 1

  -- Colorcolumn shades text and empty cells alike, up to 256 columns past c.
  local c = cr_cols[cr_idx]
  local value = c and table.concat(vim.fn.range(c + 1, c + 256), ',') or ''

  -- Set every window plus the default inherited by new ones.
  vim.api.nvim_set_option_value('colorcolumn', value, { scope = 'global' })
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.api.nvim_set_option_value('colorcolumn', value, { win = win })
  end

  vim.notify('ruler: ' .. (c and tostring(c) or 'off'))
end

-- Set cycle ruler keys.
vim.keymap.set('n', '<leader>cr', function() cycle_ruler(1) end, { desc = 'Cycle ruler' })
vim.keymap.set('n', '<leader>cR', function() cycle_ruler(-1) end, { desc = 'Cycle ruler (go backwards)' })

-- Which statusline stop is active; persists across calls.
local cs_idx = 1

-- Cycle statusline function.
local function cycle_statusline(step)
  local stops = {
    { ls = 2, ch = 1, name = 'on' },
    { ls = 2, ch = 0, name = 'on, no cmdline' },
    { ls = 0, ch = 0, name = 'off' },
  }
  cs_idx = (cs_idx - 1 + step) % #stops + 1

  local s = stops[cs_idx]
  vim.o.laststatus, vim.o.cmdheight = s.ls, s.ch
  vim.notify('statusline: ' .. s.name)
end

-- Set cycle statusline keys.
vim.keymap.set('n', '<leader>cs', function() cycle_statusline(1) end, { desc = 'Cycle statusline' })
vim.keymap.set('n', '<leader>cS', function() cycle_statusline(-1) end, { desc = 'Cycle statusline (go backwards)' })
