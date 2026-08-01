-- Haunt configuration.
local haunt = require('haunt')
local haunt_api = require('haunt.api')
local haunt_picker = require('haunt.picker')

haunt.setup({
  per_branch_bookmarks = false,
  picker = 'fzf'
})

-- Regular expression escape helper for customized picker.
local function fzf_regex_escape(s)
  return vim.fn.escape(s, [[\^$.*+?()[]{}|]])
end

-- Function to assist with setting haunt.nvim project directory.
local function haunt_set_project_dir()
  local cwd = vim.fn.getcwd()
  local project_root = vim.fs.root(cwd, '.git') or cwd
  haunt_api.change_data_dir(project_root .. '/.haunt/')
end

-- Set haunt.nvim project dir on startup and whenever directory changes.
vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, { callback = haunt_set_project_dir })

-- Various common haunt.nvim keybindings.
vim.keymap.set('n', 'ma', function() haunt_api.annotate() end, { desc = 'Add bookmark' })
vim.keymap.set('n', 'md', function() haunt_api.delete() end, { desc = 'Delete bookmark' })
vim.keymap.set('n', 'mC', function() haunt_api.clear_all() end, { desc = 'Delete all bookmarks' })
vim.keymap.set('n', 'mp', function() haunt_api.prev() end, { desc = 'Previous bookmark' })
vim.keymap.set('n', 'mn', function() haunt_api.next() end, { desc = 'Next bookmark' })
vim.keymap.set('n', 'mt', function() haunt_api.toggle_annotation() end, { desc = 'Toggle bookmark inline annotation message' })
vim.keymap.set('n', 'mT', function() haunt_api.toggle_all_lines() end, { desc = 'Toggle all bookmark inline annotation messages' })
vim.keymap.set('n', 'mQ', function() haunt_api.to_quickfix({ current_buffer = true }) end, { desc = 'Send bookmarks to Quickfix (buffer)' })
vim.keymap.set('n', 'mq', function() haunt_api.to_quickfix() end, { desc = 'Send bookmarks to Quickfix (all)' })
vim.keymap.set('n', 'my', function() haunt_api.yank_locations({ current_buffer = true }) end, { desc = 'Send bookmarks to Clipboard (buffer)' })
vim.keymap.set('n', 'mY', function() haunt_api.yank_locations() end, { desc = 'Send bookmarks to Clipboard (all)' })

-- Show the bookmark picker, customized.
vim.keymap.set('n', '<Leader>m', function()
  local cwd = vim.fn.getcwd():gsub('/$', '')
  haunt_picker.show({
    prompt = 'Bookmarks> ',
    fzf_opts = {
      ['--delimiter'] = '^' .. fzf_regex_escape(cwd) .. '/|^.*/|:[0-9]+ |:[0-9]+$|:',
      ['--with-nth'] = '{4..} ({2}:{3})',
    },
  })
end, { desc = 'Show bookmark picker' })
