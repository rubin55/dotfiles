-- Cached split width, updated when the split explorer is dragged.
local explorer_width = 40
require('nvim-tree').setup({
  filters = {
    dotfiles = false
  },
  renderer = {
    group_empty = true
  },
  sort = {
    sorter = 'case_sensitive'
  },
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false
  },
  view = {
    side = 'left',
    width = function() return explorer_width end,
    float = {
      enable = true,
      quit_on_focus_loss = true,
      open_win_config = function()
        local w = 40
        local h = vim.o.lines - 2
        local r = require('nvim-tree.config').g.view.side == 'right'
        return {
          relative = 'editor',
          border = 'none',
          width = w,
          height = h,
          row = 0,
          col = r and (vim.o.columns - w) or 0
        }
      end
    }
  }
})

-- Remember the split's dragged width so file-open restores it.
vim.api.nvim_create_autocmd('WinResized', {
  callback = function()
    local api = require('nvim-tree.api')
    if not api.tree.is_visible() then return end
    local winid = api.tree.winid()
    -- Track the split only, not the float.
    if winid and vim.api.nvim_win_get_config(winid).relative == '' then
      explorer_width = vim.api.nvim_win_get_width(winid)
    end
  end,
})

-- Snapshot the non-tree windows' widths in the current tab, keyed by winid.
local function snapshot_widths(tree_win)
  local snap = {}
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if w ~= tree_win and vim.api.nvim_win_get_config(w).relative == '' then
      snap[w] = vim.api.nvim_win_get_width(w)
    end
  end
  return snap
end

-- Restore snapshot widths; the explorer's neighbour absorbs the change.
local function absorb_adjacent(snap, side)
  local wins = {}
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if snap[w] and vim.api.nvim_win_get_config(w).relative == '' then
      wins[#wins + 1] = w
    end
  end
  if #wins < 2 then return end

  -- Adjacent window: nearest the explorer (leftmost for side 'left').
  local adjacent, best
  for _, w in ipairs(wins) do
    local col = vim.api.nvim_win_get_position(w)[2]
    if best == nil
       or (side == 'left' and col < best)
       or (side ~= 'left' and col > best) then
      best, adjacent = col, w
    end
  end

  -- Give non-adjacent windows their old width; neighbour takes the rest.
  local avail, others = 0, 0
  for _, w in ipairs(wins) do
    avail = avail + vim.api.nvim_win_get_width(w)
    if w ~= adjacent then others = others + snap[w] end
  end
  for _, w in ipairs(wins) do
    if w ~= adjacent then vim.api.nvim_win_set_width(w, snap[w]) end
  end
  vim.api.nvim_win_set_width(adjacent, math.max(1, avail - others))
end

-- Open nvim-tree as a float (closes on file open) or split (stays open).
local function toggle_explorer(float)
  local api = require('nvim-tree.api')
  local cfg = require('nvim-tree.config').g

  -- Snapshot other windows so a split toggle only resizes the neighbour.
  local snap = snapshot_widths(api.tree.winid())

  -- Already open: close it, and only reopen when switching modes.
  if api.tree.is_visible() then
    local winid = api.tree.winid()
    local was_float = winid and vim.api.nvim_win_get_config(winid).relative ~= ''
    api.tree.close()
    if not was_float then absorb_adjacent(snap, cfg.view.side) end
    if was_float == float then return end
  end

  -- Re-register autocommands so the float-only WinLeave closer matches mode.
  cfg.view.float.enable = float
  cfg.actions.open_file.quit_on_open = float
  require('nvim-tree.autocmd').global()
  api.tree.open()
  if not float then absorb_adjacent(snap, cfg.view.side) end
end

vim.keymap.set('n', '<leader>e', function() toggle_explorer(true)  end, { desc = 'Toggle explorer (float)' })
vim.keymap.set('n', '<leader>E', function() toggle_explorer(false) end, { desc = 'Toggle explorer (split)' })
