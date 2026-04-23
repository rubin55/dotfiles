-- Leader key.
vim.g.mapleader = ' '

-- Disable netrw.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neovim plugins.
vim.pack.add({
  'https://github.com/EdenEast/nightfox.nvim.git',
  'https://github.com/TheNoeTrevino/haunt.nvim.git',
  'https://github.com/ibhagwan/fzf-lua.git',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-tree.lua.git',
  'https://github.com/nvim-tree/nvim-web-devicons.git',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/sindrets/diffview.nvim.git',
})

-- Tell neovim about double-width characters
-- in the PragmataPro font (setcellwidths).
require('pragmatapro').setup()

-- Enable extra icons.
require('nvim-web-devicons').setup()

-- Enable notifications.
require('fidget').setup()

-- Background light/dark based on DBUS inspection.
local function set_bg_from_dbus()
  if vim.fn.executable('dbus-send') == 0 then return end

  local sudo_user = os.getenv('SUDO_USER')
  local cmd

  if sudo_user then
    local uid = vim.fn.system({ 'id', '-u', sudo_user }):gsub('%s+', '')
    local dbus_addr = string.format('unix:path=/run/user/%s/bus', uid)
    local dbus_envs = string.format('DBUS_SESSION_BUS_ADDRESS=%s', dbus_addr)
    cmd = { 'sudo', '-u', sudo_user, dbus_envs, 'dbus-send' }
  else
    cmd = { 'dbus-send' }
  end

  vim.list_extend(cmd, {
    '--session', '--print-reply=literal',
    '--dest=org.freedesktop.portal.Desktop',
    '/org/freedesktop/portal/desktop',
    'org.freedesktop.portal.Settings.Read',
    'string:org.freedesktop.appearance',
    'string:color-scheme'
  })

  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then return end
  local val = out:match('(%d+)%s*$')
  if val == '1' then
    vim.o.background = 'dark'
  elseif val == '0' or val == '2' then
    vim.o.background = 'light'
  end
end

-- Sets italic comments on any theme.
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local old_hl = vim.api.nvim_get_hl(0, { name = 'Comment' })
    local new_hl = vim.tbl_extend('force', old_hl, { italic = true })
    vim.api.nvim_set_hl(0, 'Comment', new_hl)
  end
})

-- Sets theme based on background.
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  nested = true,
  callback = function()
    if vim.o.background == 'dark' then
      vim.cmd.colorscheme('nightfox')
    elseif vim.o.background == 'light' then
      vim.cmd.colorscheme('dayfox')
    end
    if vim.g.neovide then
      vim.g.neovide_theme = vim.o.background
    end
  end
})

-- Set GUI font.
vim.o.guifont = 'Monospace:h11.2:#e-subpixelantialias:#h-none'

-- Invoke DBUS-based background setting. Do this with a
-- slight delay for Neovide, immediately on terminal.
-- Additionally set some Neovide-specific settings
-- when Neovide is detected.
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_cell_color_fallback = true
  vim.g.neovide_cursor_smooth_blink = false
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_floating_blur_amount_x = 0
  vim.g.neovide_floating_blur_amount_y = 0
  vim.g.neovide_pixel_geometry = 'RGBH'
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_text_contrast = 0.1
  vim.g.neovide_text_gamma = 0.8
  vim.api.nvim_create_autocmd('UIEnter', {
    callback = function()
      vim.defer_fn(set_bg_from_dbus, 10)
    end
  })
else
  set_bg_from_dbus()
end

-- Remember where you were in a file.
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end
})

-- Set a character for deleted lines in diff.
vim.opt.fillchars:append { diff = '╱' }

-- Use system clipboard.
vim.o.clipboard = 'unnamedplus'

-- Enable highlighted of line where cursor is.
vim.o.cursorline = true

-- Use block cursor always.
vim.o.guicursor = 'a:block-blinkwait500-blinkon500-blinkoff500'

-- Remove the how-to-disable menu item.
vim.cmd([[unmenu PopUp.How-to\ disable\ mouse]])

-- Default tab behavior.
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Case-(in)sensitivity.
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildignorecase = true

-- Configure linebreak on words.
vim.o.linebreak = true

-- Configure window border.
vim.o.winborder = 'solid'

-- Disable unused providers.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Set number defaults.
vim.o.number = false
vim.o.relativenumber = false
vim.o.signcolumn = 'yes'

-- Toggle gutter function.
local function toggle_gutter()
  if not vim.o.number then
    vim.o.number = true
    vim.o.relativenumber = false
    vim.o.signcolumn = 'number'
  elseif not vim.o.relativenumber then
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.signcolumn = 'number'
  else
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.signcolumn = 'yes'
  end
end

-- Set toggle gutter key.
vim.keymap.set('n', 'tg', toggle_gutter, { desc = 'Toggle gutter' })

--Configure nvim-tree.
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
    update_root = true
  },
  view = {
    adaptive_size = true,
    side = 'left'
  },
})

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle Explorer' })

-- Tree-sitter grammars.
require('nvim-treesitter').install({ 'asm', 'astro', 'awk', 'bash', 'c', 'c_sharp', 'clojure', 'cmake', 'comment', 'cpp', 'css', 'csv', 'cuda', 'cue', 'dart', 'desktop', 'diff', 'dockerfile', 'editorconfig', 'eex', 'elixir', 'erlang', 'fsharp', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'glsl', 'go', 'gomod', 'gosum', 'gotmpl', 'gpg', 'groovy', 'haskell', 'heex', 'helm', 'hlsl', 'html', 'http', 'ini', 'java', 'javadoc', 'javascript', 'jinja', 'jinja_inline', 'jq', 'jsdoc', 'json', 'just', 'kotlin', 'latex', 'llvm', 'lua', 'luadoc', 'm68k', 'make', 'markdown', 'markdown_inline', 'mermaid', 'nasm', 'nginx', 'ninja', 'objc', 'objdump', 'passwd', 'pem', 'perl', 'php', 'phpdoc', 'powershell', 'printf', 'properties', 'python', 'query', 'racket', 'rbs', 'regex', 'requirements', 'robots_txt', 'rst', 'ruby', 'rust', 'scala', 'scheme', 'scss', 'slang', 'sql', 'ssh_config', 'strace', 'svelte', 'swift', 'systemverilog', 'tlaplus', 'tmux', 'todotxt', 'toml', 'tsv', 'tsx', 'typescript', 'udev', 'vala', 'vhdl', 'vim', 'vimdoc', 'vue', 'wgsl', 'xml', 'xresources', 'yaml', 'zig' }):wait(300000)

-- Starts tree-sitter on supported file-types.
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end
})

-- LSP servers.
vim.lsp.enable({ 'ansiblels', 'asm_lsp', 'astro', 'awk_ls', 'bashls', 'biome', 'clangd', 'clojure_lsp', 'cmake', 'cssls', 'cue', 'dartls', 'diagnosticls', 'dockerls', 'elixirls', 'eslint', 'expert', 'flow', 'fsautocomplete', 'gopls', 'groovyls', 'helm_ls', 'html', 'jdtls', 'jsonls', 'kotlin_lsp', 'lemminx', 'lua_ls', 'marksman', 'metals', 'omnisharp', 'perlnavigator', 'powershell_es', 'pylsp', 'pyright', 'rubocop', 'ruff', 'rust_analyzer', 'scheme_langserver', 'solargraph', 'svelte', 'tailwindcss', 'vala_ls', 'vtsls', 'vue_ls', 'yamlls', 'zls' })

-- Enables LSP completion.
vim.opt.completeopt = { 'fuzzy', 'menuone', 'noselect', 'popup' }
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end
})

-- Shift-enter in terminal sends newline.
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(ev)
    vim.keymap.set('t', '<S-CR>', function()
      vim.api.nvim_chan_send(vim.b[ev.buf].terminal_job_id, '\n')
    end, { buffer = ev.buf })
  end
})

-- Close buffer without closing window.
vim.keymap.set('c', '<CR>', function()
  if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'bd' then
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.cmd('bprevious')

      if bufnr == vim.api.nvim_get_current_buf() then
        vim.cmd('enew')
      end

      vim.cmd('silent! bdelete ' .. bufnr)
    end)

    return '<C-c>'
  end

  return '<CR>'
end, { expr = true })

-- Lualine configuration.
local separators = (tonumber(vim.o.guifont:match(':h(%d+%.?%d*)')) or 0) >= 12
  and { left = '', right = '' }
  or { left = '', right = '' }

require('lualine').setup({
  options = {
    component_separators = { left = '', right = '' },
    section_separators = separators,
    theme = 'auto'
  }
})

-- Haunt configuration.
local haunt = require('haunt')
local haunt_api = require('haunt.api')
local haunt_picker = require('haunt.picker')

haunt.setup({
  data_dir = '~/.haunt',
  per_branch_bookmarks = false,
  picker = 'fzf'
})

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
vim.keymap.set('n', '<Leader>m', function() haunt_picker.show({ prompt = 'Bookmarks> ' }) end, { desc = 'Show bookmark picker' })

-- Fzf configuration.
local fzf = require('fzf-lua')
local actions = require('fzf-lua.actions')

fzf.setup({
  'telescope',
  ui_select = true,
  actions = {
    files = {
      true,
      ['enter']  = actions.file_edit_or_qf,
      ['ctrl-s'] = actions.file_split,
      ['ctrl-v'] = actions.file_vsplit,
      ['ctrl-t'] = actions.file_tabedit,
      ['alt-q']  = actions.file_sel_to_qf,
      ['alt-Q']  = actions.file_sel_to_ll,
      ['alt-i']  = actions.toggle_ignore,
      ['alt-h']  = actions.toggle_hidden,
      ['alt-f']  = actions.toggle_follow,
    },
  }
})

vim.keymap.set('n', '<Leader>a', fzf.builtin, { desc = 'All pickers' })
vim.keymap.set('n', '<Leader>b', fzf.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<Leader>c', fzf.changes, { desc = 'Changes' })
vim.keymap.set('n', '<Leader>d', fzf.diagnostics_workspace, { desc = 'Diagnostics' })
vim.keymap.set('n', '<Leader>f', fzf.files, { desc = 'Files' })
vim.keymap.set('n', '<Leader>g', fzf.grep_project, { desc = 'Grep' })
vim.keymap.set('n', '<Leader>h', fzf.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<Leader>k', fzf.keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<Leader>r', fzf.lsp_references, { desc = 'References' })
vim.keymap.set('n', '<Leader>s', fzf.lsp_live_workspace_symbols, { desc = 'Symbols' })
vim.keymap.set('n', '<Leader>t', fzf.treesitter, { desc = 'Treesitter' })
