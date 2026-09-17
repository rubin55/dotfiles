-- Lualine configuration.

-- Has file conditional helper.
local function has_file()
  return vim.fn.empty(vim.fn.expand('%:t')) == 0
end

-- Fzf extensions.
local fzf_ext = require('lualine.extensions.fzf')
fzf_ext.sections = {
  lualine_a = fzf_ext.sections.lualine_a,
  lualine_b = fzf_ext.sections.lualine_y,
  lualine_z = fzf_ext.sections.lualine_z,
}

-- Use certain separators with certain font-sizes.
local dyn_sep = (tonumber(vim.o.guifont:match(':h(%d+%.?%d*)')) or 0) >= 12
  and { left = '', right = '' }
  or { left = '', right = '' }

-- Lualine setup.
require('lualine').setup({
  extensions = { fzf_ext, 'nvim-tree', 'quickfix' },
  options = {
    always_show_tabline = false,
    component_separators = { left = '', right = '' },
    disabled_filetypes = { winbar = { 'NvimTree', 'fzf' } },
    globalstatus = false,
    section_separators = dyn_sep,
    theme = 'auto'
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {},
  tabline = {
    lualine_a = {
      {
        'tabs', mode = 1, path = 0,
        max_length = function() return vim.o.columns end,
        fmt = function(name, context)
          local tp = vim.api.nvim_list_tabpages()[context.tabnr]
          local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tp))
          local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')
          local icon = require('nvim-web-devicons').get_icon(
            fname, vim.fn.fnamemodify(fname, ':e'), { default = true })
          return icon and (icon .. ' ' .. name) or name
        end
      }
    }
  },
  winbar = {
    lualine_b = { { 'filetype', icon_only = true, colored = true, cond = has_file }, },
    lualine_c = { { 'filename', path = 1, cond = has_file } },
    lualine_x = {'encoding', 'fileformat' },
  },
  inactive_winbar = {
    lualine_b = { { 'filetype', icon_only = true, colored = false, cond = has_file }, },
    lualine_c = { { 'filename', path = 1, cond = has_file } },
    lualine_x = {'encoding', 'fileformat' },
  }
})
