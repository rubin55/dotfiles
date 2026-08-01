-- Remove the how-to-disable menu item.
vim.cmd([[unmenu PopUp.How-to\ disable\ mouse]])

-- Preserve window proportions.
vim.o.equalalways = false

-- Default tab behavior.
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2

-- Case-(in)sensitivity.
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildignorecase = true

-- Enable linebreak on words.
vim.o.linebreak = true

-- Disable word wrap.
vim.o.wrap = false

-- Set number defaults.
vim.o.number = false
vim.o.relativenumber = false
vim.o.signcolumn = 'yes'

-- Disable unused providers.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Remember where you were in a file.
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end
})
