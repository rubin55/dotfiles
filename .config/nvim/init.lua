-- Neovim plugins.
vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-treesitter/nvim-treesitter',
})

-- LSP configs (if any).
for _, path in ipairs(vim.fn.glob(vim.fn.stdpath('config') .. '/lua/lsp/*.lua', false, true)) do
  local name = vim.fn.fnamemodify(path, ':t:r')
  require('lsp.' .. name)
end

-- LSP enablement.-ls
vim.lsp.enable({ 'ansiblels', 'asm_lsp', 'astro', 'awk_ls', 'bashls', 'biome', 'clangd', 'clojure_lsp', 'cmake', 'cssls', 'cue', 'dartls', 'diagnosticls', 'dockerls', 'elixirls', 'eslint', 'expert', 'flow', 'fsautocomplete', 'gopls', 'groovyls', 'helm_ls', 'html', 'jdtls', 'jsonls', 'kotlin_lsp', 'lemminx', 'lua_ls', 'marksman', 'metals', 'omnisharp', 'perlnavigator', 'powershell_es', 'pylsp', 'pyright', 'rubocop', 'ruff', 'rust_analyzer', 'scheme_langserver', 'solargraph', 'svelte', 'tailwindcss', 'vala_ls', 'vtsls', 'vue', 'yamlls', 'zls' })

-- Tree-sitter languages.
require('nvim-treesitter').install({ 'asm', 'astro', 'awk', 'bash', 'c', 'c_sharp', 'clojure', 'cmake', 'comment', 'cpp', 'css', 'csv', 'cuda', 'cue', 'dart', 'desktop', 'diff', 'dockerfile', 'editorconfig', 'eex', 'elixir', 'erlang', 'fsharp', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'glsl', 'go', 'gomod', 'gosum', 'gotmpl', 'gpg', 'groovy', 'haskell', 'heex', 'helm', 'hlsl', 'html', 'http', 'ini', 'java', 'javadoc', 'javascript', 'jinja', 'jinja_inline', 'jq', 'jsdoc', 'json', 'just', 'kotlin', 'latex', 'llvm', 'lua', 'luadoc', 'm68k', 'make', 'markdown', 'markdown_inline', 'mermaid', 'nasm', 'nginx', 'ninja', 'objc', 'objdump', 'passwd', 'pem', 'perl', 'php', 'phpdoc', 'powershell', 'printf', 'properties', 'python', 'query', 'racket', 'rbs', 'regex', 'requirements', 'robots_txt', 'rst', 'ruby', 'rust', 'scala', 'scheme', 'scss', 'slang', 'sql', 'ssh_config', 'strace', 'svelte', 'swift', 'systemverilog', 'tlaplus', 'tmux', 'todotxt', 'toml', 'tsv', 'tsx', 'typescript', 'udev', 'vala', 'vhdl', 'vim', 'vue', 'wgsl', 'xml', 'xresources', 'yaml', 'zig' }):wait(300000)

-- Default tab behavior.
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
