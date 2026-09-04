-- Set toggle word wrap key.
vim.keymap.set('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('wrap: ' .. (vim.wo.wrap and 'on' or 'off'))
end, { desc = 'Toggle word wrap' })

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
local cc_idx = 1

-- Toggle ruler function.
local function cycle_ruler(step)
  local cc_cols = { false, 72, 80, 120, 132 }
  cc_idx = (cc_idx - 1 + step) % #cc_cols + 1

  -- Colorcolumn shades text and empty cells alike, up to 256 columns past c.
  local c = cc_cols[cc_idx]
  local value = c and table.concat(vim.fn.range(c + 1, c + 256), ',') or ''

  -- Set every window plus the default inherited by new ones.
  vim.api.nvim_set_option_value('colorcolumn', value, { scope = 'global' })
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.api.nvim_set_option_value('colorcolumn', value, { win = win })
  end

  vim.notify('ruler: ' .. (c and tostring(c) or 'off'))
end

-- Set toggle ruler keys.
vim.keymap.set('n', '<leader>tr', function() cycle_ruler(1) end, { desc = 'Toggle ruler' })
vim.keymap.set('n', '<leader>tR', function() cycle_ruler(-1) end, { desc = 'Toggle ruler (go backwards)' })

-- Which lualine stop is active; persists across calls.
local ll_idx = 1

-- Toggle lualine function.
local function cycle_lualine(step)
  local stops = {
    { ls = 2, ch = 1, name = 'on' },
    { ls = 2, ch = 0, name = 'on, no cmdline' },
    { ls = 0, ch = 0, name = 'off' },
  }
  ll_idx = (ll_idx - 1 + step) % #stops + 1

  local s = stops[ll_idx]
  vim.o.laststatus, vim.o.cmdheight = s.ls, s.ch
  vim.notify('lualine: ' .. s.name)
end

-- Set toggle lualine keys.
vim.keymap.set('n', '<leader>ts', function() cycle_lualine(1) end, { desc = 'Toggle statusline' })
vim.keymap.set('n', '<leader>tS', function() cycle_lualine(-1) end, { desc = 'Toggle statusline (go backwards)' })
