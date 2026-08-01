-- Tree-sitter grammars.
require('nvim-treesitter').install({
  'asm', 'astro', 'awk', 'bash', 'c', 'c_sharp', 'clojure', 'cmake', 'comment',
  'cpp', 'css', 'csv', 'cuda', 'cue', 'dart', 'desktop', 'diff', 'dockerfile',
  'editorconfig', 'eex', 'elixir', 'erlang', 'fsharp', 'git_config',
  'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'glsl', 'go',
  'gomod', 'gosum', 'gotmpl', 'gpg', 'groovy', 'haskell', 'heex', 'helm',
  'hlsl', 'html', 'http', 'ini', 'java', 'javadoc', 'javascript', 'jinja',
  'jinja_inline', 'jq', 'jsdoc', 'json', 'just', 'kotlin', 'latex', 'llvm',
  'lua', 'luadoc', 'm68k', 'make', 'markdown', 'markdown_inline', 'mermaid',
  'nasm', 'nginx', 'ninja', 'objc', 'objdump', 'passwd', 'pem', 'perl', 'php',
  'phpdoc', 'powershell', 'printf', 'properties', 'python', 'query', 'racket',
  'rbs', 'regex', 'requirements', 'robots_txt', 'rst', 'ruby', 'rust', 'scala',
  'scheme', 'scss', 'slang', 'sql', 'ssh_config', 'strace', 'svelte', 'swift',
  'systemverilog', 'tlaplus', 'todotxt', 'toml', 'tsv', 'tsx', 'typescript',
  'udev', 'vala', 'vhdl', 'vim', 'vimdoc', 'vue', 'wgsl', 'xml', 'xresources',
  'yaml', 'zig',
}):wait(300000)

-- Starts tree-sitter on supported file-types.
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end
})
