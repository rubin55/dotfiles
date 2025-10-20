require "nvchad.options"

-- add yours here!
local g = vim.g
local o = vim.o

-- enable cursorline
o.cursorlineopt = 'both'
o.cmdheight = 0

-- don't wrap cursor movement to next line
o.whichwrap = "b,s"

-- neovide settings
if vim.g.neovide then
  g.neovide_cursor_animation_length = 0
  g.neovide_hide_mouse_when_typing = true
  g.neovide_remember_window_size = true
end
