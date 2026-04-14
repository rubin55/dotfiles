-- Leader key.
vim.g.mapleader = ' '

-- Neovim plugins.
vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/ibhagwan/fzf-lua.git',
  'https://github.com/sindrets/diffview.nvim.git',
  'https://github.com/nvim-tree/nvim-web-devicons.git',
  'https://github.com/EdenEast/nightfox.nvim.git',
})

-- Enable extra icons.
require('nvim-web-devicons').setup()

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

-- Invoke DBUS-based background setting. Do this with a
-- slight delay for Neovide, immediately on terminal.
-- Additionally set some Neovide-specific settings
-- when Neovide is detected.
if vim.g.neovide then
  vim.o.guifont = 'PragmataPro Mono:h11.2:#e-subpixelantialias:#h-none'
  vim.g.neovide_pixel_geometry = 'RGBH'
  vim.g.neovide_text_gamma = 0.8
  vim.g.neovide_text_contrast = 0.1
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

-- Use system clipboard.
vim.opt.clipboard = 'unnamedplus'

-- Use block cursor always.
vim.opt.guicursor = 'a:block'

-- Set a character for deleted lines in diff.
vim.opt.fillchars:append { diff = '╱' }

-- Remove the how-to-disable menu item.
vim.cmd([[unmenu PopUp.How-to\ disable\ mouse]])

-- Default tab behavior.
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Case-(in)sensitivity.
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true

-- Enable window borders.
vim.o.winborder = 'rounded'

-- Disable providers.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

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

-- Fzf configuration.
local fzf = require('fzf-lua')
fzf.setup({
  'telescope',
  ui_select = true
})

-- Custom keybindings
vim.keymap.set('n', '<Leader>a', fzf.builtin)
vim.keymap.set('n', '<Leader>b', fzf.buffers)
vim.keymap.set('n', '<Leader>f', fzf.files)
vim.keymap.set('n', '<Leader>g', fzf.grep_project)
vim.keymap.set('n', '<Leader>h', fzf.help_tags)
vim.keymap.set('n', '<Leader>l', fzf.live_grep)

