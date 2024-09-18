require "nvchad.options"

-- add yours here!
local g = vim.g
local o = vim.o

-- enable cursorline
o.cursorlineopt ='both'

-- neovide settings
if vim.g.neovide then
  g.neovide_hide_mouse_when_typing = true
  g.neovide_cursor_animation_length = 0
end
