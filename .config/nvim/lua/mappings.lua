require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>cc", ":lua cycle_colorcolumn()<CR>", { desc = "CMD toggle colorcolumn" })
