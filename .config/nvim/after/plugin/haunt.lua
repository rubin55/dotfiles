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
vim.keymap.set('n', '<Leader>ma', function() haunt_api.annotate() end, { desc = 'Bookmark add' })
vim.keymap.set('n', '<Leader>md', function() haunt_api.delete() end, { desc = 'Bookmark delete' })
vim.keymap.set('n', '<Leader>mC', function() haunt_api.clear_all() end, { desc = 'Bookmark delete all' })
vim.keymap.set('n', '<Leader>mp', function() haunt_api.prev() end, { desc = 'Bookmark go to previous' })
vim.keymap.set('n', '<Leader>mn', function() haunt_api.next() end, { desc = 'Bookmark go to next' })
vim.keymap.set('n', '<Leader>mt', function() haunt_api.toggle_annotation() end, { desc = 'Bookmark toggle inline annotation' })
vim.keymap.set('n', '<Leader>mT', function() haunt_api.toggle_all_lines() end, { desc = 'Bookmark toggle all inline annotations' })
vim.keymap.set('n', '<Leader>mQ', function() haunt_api.to_quickfix({ current_buffer = true }) end, { desc = 'Bookmark send to quickfix (buffer)' })
vim.keymap.set('n', '<Leader>mq', function() haunt_api.to_quickfix() end, { desc = 'Bookmark send to quickfix (all)' })
vim.keymap.set('n', '<Leader>my', function() haunt_api.yank_locations({ current_buffer = true }) end, { desc = 'Bookmark send to clipboard (buffer)' })
vim.keymap.set('n', '<Leader>mY', function() haunt_api.yank_locations() end, { desc = 'Bookmark send to clipboard (all)' })

-- Show the bookmark picker, customized.
vim.keymap.set('n', '<Leader>fm', function()
  local cwd = vim.fn.getcwd():gsub('/$', '')
  haunt_picker.show({
    prompt = 'Bookmarks> ',
    fzf_opts = {
      ['--delimiter'] = '^' .. fzf_regex_escape(cwd) .. '/|^.*/|:[0-9]+ |:[0-9]+$|:',
      ['--with-nth'] = '{4..} ({2}:{3})',
    },
  })
end, { desc = 'Show bookmarks' })
