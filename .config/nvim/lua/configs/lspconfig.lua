-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "ansiblels",
  "bashls",
  "clangd",
  "clojure_lsp",
  "cmake",
  "cssls",
  "dartls",
  "dockerls",
  "elixirls",
  "erlangls",
  "gopls",
  "groovyls",
  "hls",
  "html",
  "jdtls",
  "jsonls",
  "lemminx",
  "lua_ls",
  "m68k",
  "metals",
  "omnisharp",
  "perlnavigator",
  "pylsp",
  "remark_ls",
  "rubocop",
  "rust_analyzer",
  "solargraph",
  "ts_ls",
  "vala_ls",
  "vimls",
  "vtsls",
  "yamlls",
  "zls",
}

local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
