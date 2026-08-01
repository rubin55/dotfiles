-- Leader key. Must precede any mapping that uses <leader>.
vim.g.mapleader = ' '

-- Disable (internal) netrw. Must happen before its plugin file is sourced.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neovim plugins. Puts them on the runtimepath for after/plugin/ to configure.
vim.pack.add({
  { name = 'catppuccin.nvim', src = 'https://github.com/catppuccin/nvim' },
  { name = 'diffview.nvim', src = 'https://github.com/sindrets/diffview.nvim' },
  { name = 'everforest.nvim', src = 'https://github.com/neanias/everforest-nvim' },
  { name = 'fidget.nvim', src = 'https://github.com/j-hui/fidget.nvim' },
  { name = 'fzf-lua', src = 'https://github.com/ibhagwan/fzf-lua' },
  { name = 'gitsigns.nvim', src = 'https://github.com/lewis6991/gitsigns.nvim.git' },
  { name = 'haunt.nvim', src = 'https://github.com/TheNoeTrevino/haunt.nvim' },
  { name = 'lualine.nvim', src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { name = 'nightfox.nvim', src = 'https://github.com/EdenEast/nightfox.nvim' },
  { name = 'nvim-lspconfig', src = 'https://github.com/neovim/nvim-lspconfig' },
  { name = 'nvim-tree', src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { name = 'nvim-treesitter', src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { name = 'nvim-web-devicons', src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { name = 'rose-pine.nvim', src = 'https://github.com/rose-pine/neovim' },
  { name = 'tomorrow-night-blue.nvim', src = 'https://github.com/gnfisher/tomorrow-night-blue.nvim' },
})

-- Mark PragmataPro's double-width characters (setcellwidths).
require('pragmatapro').setup()

-- Editor settings and mappings. Plugin setup lives in after/plugin/.
require('appearance')
require('editor')
require('keymaps')
require('toggles')
