-- Toggle gutter function, for the current window.
local function toggle_gutter()
  local wo = vim.wo
  if not wo.number then
    wo.number = true
    wo.relativenumber = false
    wo.signcolumn = 'number'
    vim.notify('gutter: absolute')
  elseif not wo.relativenumber then
    wo.number = true
    wo.relativenumber = true
    wo.signcolumn = 'number'
    vim.notify('gutter: relative')
  else
    wo.number = false
    wo.relativenumber = false
    wo.signcolumn = 'yes'
    vim.notify('gutter: off')
  end
end

-- Set toggle gutter key.
vim.keymap.set('n', '<Leader>tg', toggle_gutter, { desc = 'Toggle gutter' })

-- Toggle ruler function, for the current window.
local function toggle_ruler()
  local stops = { 72, 80, 120, 132 }

  -- Current ruler: the first colorcolumn entry minus one, else off.
  local cur = (tonumber(vim.wo.colorcolumn:match('^%d+')) or 0) - 1
  local c = stops[1]
  for i, s in ipairs(stops) do
    if s == cur then c = stops[i + 1] end
  end

  -- Colorcolumn shades text and empty cells alike, up to 256 columns past c.
  vim.wo.colorcolumn = c and table.concat(vim.fn.range(c + 1, c + 256), ',') or ''
  vim.notify('ruler: ' .. (c and tostring(c) or 'off'))
end

-- Set toggle ruler key.
vim.keymap.set('n', '<Leader>tr', toggle_ruler, { desc = 'Toggle ruler' })

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
vim.keymap.set('n', '<Leader>ts', toggle_statusline, { desc = 'Toggle statusline' })
-- Set toggle word wrap key.
vim.keymap.set('n', '<Leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('wrap: ' .. (vim.wo.wrap and 'on' or 'off'))
end, { desc = 'Toggle word wrap' })
