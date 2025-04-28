require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>cc", ":lua cycle_colorcolumn()<cr>", { desc = "cycle line length indicator" })
map("n", "<leader>tg", ":lua toggle_gutter()<cr>", { desc = "toggle line number and sign gutter" })
map("n", "<leader>tt", ":lua require('base46').toggle_theme()<cr>", { desc = "toggle dark/light theme" })
map("n", "<f11>", ":lua toggle_fullscreen()<cr>", { desc = "toggle full screen" })
