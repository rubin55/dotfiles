-- Custom fill characters: deleted diff lines, solid split bar.
vim.opt.fillchars:append { diff = '╱', vert = '█' }

-- Enable highlighted of line where cursor is.
vim.o.cursorline = true

-- Use block cursor always.
vim.o.guicursor = 'a:block-blinkwait500-blinkon500-blinkoff500'

-- Set GUI font. Read by after/plugin/lualine.lua, which runs later.
vim.o.guifont = 'Monospace:h11.2:#e-subpixelantialias:#h-none'

-- Configure window border.
vim.o.winborder = 'solid'

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

local function set_theme_from_bg()
  if vim.o.background == 'dark' then
    vim.cmd.colorscheme('nightfox')
  elseif vim.o.background == 'light' then
    vim.cmd.colorscheme('rose-pine')
  end

  if vim.g.neovide then
    vim.g.neovide_theme = vim.o.background
  end
end

-- Configure font and colorcolumn for colorscheme events.
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    -- Italic comments.
    local old_hl = vim.api.nvim_get_hl(0, { name = 'Comment' })
    local new_hl = vim.tbl_extend('force', old_hl, { italic = true })
    vim.api.nvim_set_hl(0, 'Comment', new_hl)

    -- No bold.
    for _, name in ipairs(vim.fn.getcompletion('', 'highlight')) do
      local hl = vim.api.nvim_get_hl(0, { name = name, link = true })
      if hl.bold then
        vim.api.nvim_set_hl(0, name, vim.tbl_extend('force', hl, { bold = false }))
      end
    end

    -- Make colorcolumn color match cursorline.
    vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'CursorLine' })
  end
})

-- Causes theme to be set when changing background with set bg.
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  nested = true,
  callback = set_theme_from_bg
})

-- Apply the theme once everything is configured. VimEnter runs after every
-- after/plugin/ file, so the theme plugins are set up whatever order they
-- loaded in. Nested, or :colorscheme would not fire the ColorScheme event.
local function apply_theme()
  set_bg_from_dbus()
  set_theme_from_bg()
end

-- Neovide settings.
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_cell_color_fallback = true
  vim.g.neovide_cursor_smooth_blink = false
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_floating_blur_amount_x = 0
  vim.g.neovide_floating_blur_amount_y = 0
  vim.g.neovide_pixel_geometry = 'RGBH'
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_text_contrast = 0.1
  vim.g.neovide_text_gamma = 0.8
  vim.api.nvim_create_autocmd('UIEnter', {
    callback = function()
      vim.defer_fn(apply_theme, 10)
    end
  })
  vim.keymap.set('n', '<F11>', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end, { desc = 'Toggle neovide fullscreen' })
else
  vim.api.nvim_create_autocmd('VimEnter', {
    nested = true,
    callback = apply_theme
  })
end
