-- Lualine configuration.
local fzf_ext = require('lualine.extensions.fzf')
fzf_ext.sections = {
  lualine_a = fzf_ext.sections.lualine_a,
  lualine_b = fzf_ext.sections.lualine_y,
  lualine_z = fzf_ext.sections.lualine_z,
}

local dyn_sep = (tonumber(vim.o.guifont:match(':h(%d+%.?%d*)')) or 0) >= 12
  and { left = '', right = '' }
  or { left = '', right = '' }

require('lualine').setup({
  extensions = { fzf_ext, 'nvim-tree', 'quickfix' },
  options = {
    component_separators = { left = '', right = '' },
    section_separators = dyn_sep,
    theme = 'auto',
    always_show_tabline = false,
  },
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
  }
})
