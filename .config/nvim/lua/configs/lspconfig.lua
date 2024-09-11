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
  "m68k",
  "marksman",
  "metals",
  "omnisharp",
  "perlnavigator",
  "pylsp",
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

-- configuring single server: lua_ls
lspconfig.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}




