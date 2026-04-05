-- Neovim plugins.
vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/ibhagwan/fzf-lua.git',
  'https://github.com/EdenEast/nightfox.nvim.git',
})

-- Use system clipboard.
vim.opt.clipboard = 'unnamedplus'

-- Default tab behavior.
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Case-(in)sensitivity.
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true

-- Disable providers.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Tree-sitter grammars.
require('nvim-treesitter').install({ 'asm', 'astro', 'awk', 'bash', 'c', 'c_sharp', 'clojure', 'cmake', 'comment', 'cpp', 'css', 'csv', 'cuda', 'cue', 'dart', 'desktop', 'diff', 'dockerfile', 'editorconfig', 'eex', 'elixir', 'erlang', 'fsharp', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'glsl', 'go', 'gomod', 'gosum', 'gotmpl', 'gpg', 'groovy', 'haskell', 'heex', 'helm', 'hlsl', 'html', 'http', 'ini', 'java', 'javadoc', 'javascript', 'jinja', 'jinja_inline', 'jq', 'jsdoc', 'json', 'just', 'kotlin', 'latex', 'llvm', 'lua', 'luadoc', 'm68k', 'make', 'markdown', 'markdown_inline', 'mermaid', 'nasm', 'nginx', 'ninja', 'objc', 'objdump', 'passwd', 'pem', 'perl', 'php', 'phpdoc', 'powershell', 'printf', 'properties', 'python', 'query', 'racket', 'rbs', 'regex', 'requirements', 'robots_txt', 'rst', 'ruby', 'rust', 'scala', 'scheme', 'scss', 'slang', 'sql', 'ssh_config', 'strace', 'svelte', 'swift', 'systemverilog', 'tlaplus', 'tmux', 'todotxt', 'toml', 'tsv', 'tsx', 'typescript', 'udev', 'vala', 'vhdl', 'vim', 'vimdoc', 'vue', 'wgsl', 'xml', 'xresources', 'yaml', 'zig' }):wait(300000)

-- Tree-sitter start.
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end
})

-- LSP servers.
vim.lsp.enable({ 'ansiblels', 'asm_lsp', 'astro', 'awk_ls', 'bashls', 'biome', 'clangd', 'clojure_lsp', 'cmake', 'cssls', 'cue', 'dartls', 'diagnosticls', 'dockerls', 'elixirls', 'eslint', 'expert', 'flow', 'fsautocomplete', 'gopls', 'groovyls', 'helm_ls', 'html', 'jdtls', 'jsonls', 'kotlin_lsp', 'lemminx', 'lua_ls', 'marksman', 'metals', 'omnisharp', 'perlnavigator', 'powershell_es', 'pylsp', 'pyright', 'rubocop', 'ruff', 'rust_analyzer', 'scheme_langserver', 'solargraph', 'svelte', 'tailwindcss', 'vala_ls', 'vtsls', 'vue', 'yamlls', 'zls' })

-- LSP completion.
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

-- Fzf configuration.
local fzf = require('fzf-lua')
fzf.setup({ 'telescope' })
vim.keymap.set('n', '<C-\\>', fzf.buffers)
vim.keymap.set('n', '<C-k>', fzf.builtin)
vim.keymap.set('n', '<C-p>', fzf.files)
vim.keymap.set('n', '<C-l>', fzf.live_grep)
vim.keymap.set('n', '<C-g>', fzf.grep_project)
vim.keymap.set('n', '<F1>', fzf.help_tags)

-- Theme configuration.
require('nightfox').setup({
  options = {
    styles = {
      comments = 'italic'
    }
  }
})

-- Theme based on background.
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = function()
    if vim.o.background == 'light' then
      vim.cmd.colorscheme('dayfox')
    end
    if vim.o.background == 'dark' then
      vim.cmd.colorscheme('nightfox')
    end
  end
})

-- Set dark or light based on system theme.
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.defer_fn(function()
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
    end, 10)
  end
})

-- Neovide configuration.
if vim.g.neovide then
  vim.o.guifont = 'Monospace:h11.2:#e-subpixelantialias:#h-slight'
  vim.g.neovide_pixel_geometry = 'RGBH'
  vim.g.neovide_text_gamma = 0.8
  vim.g.neovide_text_contrast = 0.1
  vim.g.neovide_theme = 'auto'
end
