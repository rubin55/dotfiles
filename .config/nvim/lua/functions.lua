function cycle_colorcolumn()
  local columns = { "", "72", "80", "120" }
  local current = vim.wo.colorcolumn
  local index = 1

  -- find the next column size
  for count, column in ipairs(columns) do
    if column == current then
      index = count % #columns + 1
      break
    end
  end

  -- set colorcolumn
  vim.wo.colorcolumn = columns[index]

  -- let user know which column size is active
  local message = columns[index] == "" and "ColorColumn disabled" or "ColorColumn set to " .. columns[index]
  vim.api.nvim_echo({ { message, "None" } }, false, {})
end

function toggle_fullscreen()
  vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end

function toggle_gutter()
  vim.o.signcolumn = vim.o.signcolumn == "yes" and "no" or "yes"
  vim.o.number = not vim.o.number
end
