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

-- Float that shows LSP hover docs; the next K reuses it.
local hover_win

-- Float width as a share of its window; a drag or resize changes it.
local hover_ratio = 0.4

-- Full-height float on the right edge of window src.
-- getwininfo() height leaves out the winbar, unlike nvim_win_get_height.
local function hover_config(src)
  local info = vim.fn.getwininfo(src)[1]
  local w = math.floor(info.width * hover_ratio + 0.5)
  return {
    relative = 'win',
    win = src,
    style = 'minimal',
    border = 'none',
    width = w,
    height = info.height,
    row = 0,
    col = info.width - w
  }
end

-- Show LSP hover docs in a float on the right side.
local function hover_right()
  local src = vim.api.nvim_get_current_win()
  local params = function(client)
    return vim.lsp.util.make_position_params(0, client.offset_encoding)
  end
  vim.lsp.buf_request_all(0, 'textDocument/hover', params, function(results)
    local lines = {}
    for _, res in pairs(results) do
      local contents = res.result and res.result.contents
      if contents then
        if #lines > 0 then table.insert(lines, '---') end
        local md = vim.lsp.util.convert_input_to_markdown_lines(contents)
        vim.list_extend(lines, md)
      end
    end
    if #lines == 0 then
      vim.notify('No hover information')
      return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = 'markdown'
    vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = buf })

    -- Reuse an open float, and move it to the source window.
    if hover_win and vim.api.nvim_win_is_valid(hover_win) then
      vim.api.nvim_win_set_buf(hover_win, buf)
      vim.api.nvim_win_set_config(hover_win, hover_config(src))
    else
      hover_win = vim.api.nvim_open_win(buf, false, hover_config(src))
    end
    vim.wo[hover_win].wrap = true
    vim.wo[hover_win].conceallevel = 2
    -- An empty sign column gives two columns of left padding.
    vim.wo[hover_win].signcolumn = 'yes'
    -- Keep the float colour when it is not the current window.
    vim.wo[hover_win].winhighlight = 'NormalNC:NormalFloat,SignColumn:NormalFloat'
  end)
end

-- True while the mouse drags the left padding of the hover float.
local resizing = false

-- Resize the hover float by dragging its left padding with the mouse.
-- Other mouse events keep their default action.
local function hover_mouse(key)
  return function()
    local pos = vim.fn.getmousepos()
    if key == '<LeftMouse>' then
      resizing = pos.winid == hover_win and pos.wincol <= 2
    elseif key == '<LeftDrag>' and resizing
        and vim.api.nvim_win_is_valid(hover_win) then
      local src = vim.api.nvim_win_get_config(hover_win).win
      local info = vim.fn.getwininfo(src)[1]
      local w = info.wincol + info.width - pos.screencol
      w = math.max(10, math.min(info.width, w))
      hover_ratio = w / info.width
      vim.api.nvim_win_set_config(hover_win, hover_config(src))
    elseif key == '<LeftRelease>' and resizing then
      resizing = false
      return ''
    end
    return resizing and '' or key
  end
end

for _, key in ipairs({ '<LeftMouse>', '<LeftDrag>', '<LeftRelease>' }) do
  vim.keymap.set({ 'n', 'i' }, key, hover_mouse(key),
    { expr = true, desc = 'Mouse, resizes hover float' })
end

-- Keep the float on the right edge when it or its window is resized.
-- A new float width, from <C-w>< or :vertical resize, sets the ratio.
vim.api.nvim_create_autocmd('WinResized', {
  callback = function()
    if not (hover_win and vim.api.nvim_win_is_valid(hover_win)) then return end
    local src = vim.api.nvim_win_get_config(hover_win).win
    local wins = vim.v.event.windows
    if vim.list_contains(wins, hover_win) then
      local width = vim.fn.getwininfo(src)[1].width
      hover_ratio = math.min(1, vim.api.nvim_win_get_width(hover_win) / width)
    elseif not vim.list_contains(wins, src) then
      return
    end
    vim.api.nvim_win_set_config(hover_win, hover_config(src))
  end
})

-- Enables LSP completion and hover docs in a float.
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    vim.keymap.set('n', 'K', hover_right, { buffer = ev.buf, desc = 'LSP hover in float' })
  end
})

