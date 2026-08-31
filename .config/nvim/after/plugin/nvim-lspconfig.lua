-- LSP servers. Per-server settings live in after/lsp/<name>.lua.
vim.lsp.enable({
  'ansiblels', 'asm_lsp', 'astro', 'awk_ls', 'bashls', 'biome', 'clangd',
  'clojure_lsp', 'cmake', 'cssls', 'cue', 'dartls', 'diagnosticls', 'dockerls',
  'elixirls', 'eslint', 'expert', 'flow', 'fsautocomplete', 'gopls', 'groovyls',
  'helm_ls', 'hls', 'html', 'jdtls', 'jsonls', 'kotlin_lsp', 'lemminx',
  'lua_ls', 'marksman', 'metals', 'omnisharp', 'perlnavigator', 'powershell_es',
  'pylsp', 'pyright', 'rubocop', 'ruff', 'rust_analyzer', 'scheme_langserver',
  'solargraph', 'svelte', 'tailwindcss', 'vala_ls', 'vtsls', 'vue_ls',
  'yamlls', 'zls',
})

-- Enables LSP completion.
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end
})

